import 'dart:io' show File, Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:arcs_agro/api/api_service.dart';
import 'package:arcs_agro/api/model/location_result.dart';
import 'package:arcs_agro/api/response/absen_response.dart';
import 'package:arcs_agro/api/response/active_absen_response.dart';
import 'package:arcs_agro/api/response/default_response.dart';
import 'package:arcs_agro/font_color.dart';
import 'package:arcs_agro/screen/main/main_page.dart';
import 'package:arcs_agro/util.dart';
import 'package:arcs_agro/util/preferences.dart';

import '../../service/location_foreground_service.dart';

class AbsensiProvider extends ChangeNotifier {
  List<AbsenData> absens = [];
  String selected = "Semua";
  String fromDate = "";
  String toDate = "";
  bool isLoading = false;
  bool isMaxReached = false;
  EnhancedStatus enhancedStatus = EnhancedStatus.loaded;

  AbsenData? absenResult;
  bool isLoadingDetail = false;

  String search = '';
  String sort = 'DESC';
  String start = '';
  String end = '';

  void setSearch(String value) {
    search = value;
    notifyListeners();
  }
  void setSort(String value) {
    sort = value;
    notifyListeners();
  }

  void setStart(String value) {
    start = value;
    notifyListeners();
  }

  void setEnd(String value) {
    end = value;
    notifyListeners();
  }


  void clear() {
    sort = 'DESC';
    start = '';
    end = '';
    notifyListeners();
  }

  void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: LottieBuilder.asset(
              'assets/lottie/loading.json',
              width: 70,
              height: 70,
            ),
          );
        });
  }

  Future<void> getAbsensi(BuildContext context,int page) async {
    isLoading = true;
    absens = [];
    notifyListeners();
    isMaxReached = false;
    final response = await ApiService.getAbsensi(context,page,search,sort,start,end);
    if (response.runtimeType == AbsenResponse) {
      final resp = response as AbsenResponse;
      if (!resp.error) {
        isLoading = false;
        absens = resp.result.results;
        notifyListeners();
      }
    }
  }

  Future<void> loadMoreAbsensi(BuildContext context,int page) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.getAbsensi(context,page,search,sort,start,end);
    if (response.runtimeType == AbsenResponse) {
      final resp = response as AbsenResponse;
      if (!resp.error) {
        absens.addAll(resp.result.results);
        enhancedStatus = EnhancedStatus.loaded;
        if (absens.length >= resp.result.total) {
          isMaxReached = true;
          notifyListeners();
        }
        notifyListeners();
      }
    }
  }

  Future<void> getDetailAbsensi(String id, BuildContext context) async {
    isLoadingDetail = true;
    notifyListeners();
    final response = await ApiService.getDetailAbsensi(context,id);
    if (response.runtimeType == ActiveAbsenResponse) {
      final resp = response as ActiveAbsenResponse;
      if (!resp.error) {
        isLoadingDetail = false;
        absenResult = resp.result.absen;
        notifyListeners();
      }
    }
  }

  Future<void> addAbsen(
      BuildContext context, List<File> files, String kios,String kiosId, String note) async {
    if (files.isNotEmpty && kios != 'Pilih Kios') {
      showLoading(context);
      final result = await _determinePosition();

      if (result.type == 1) {
        if (context.mounted) {
          Navigator.pop(context);
          showCheckFailed(context, result.message, result.type);
        }
      } else if (result.type == 2) {
        if (context.mounted) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: result.message.toString());
        }
      } else if (result.type == 4) {
        if (context.mounted) {
          Navigator.pop(context);
          showCheckFailed(context, result.message, result.type);
        }
      } else {
        if (context.mounted) {
          final f = await Util.watermarkImageF(files,'${result.position!.latitude},${result.position!.longitude}');
          final response = await ApiService.addAbsen(context,
              f, result.position!.latitude, result.position!.longitude,
              kios,kiosId,note);


          if (response.runtimeType == DefaultResponse) {
            final resp = response as DefaultResponse;
            if (!resp.error) {
              await Preferences.saveStatusCheckIn(1);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()), (
                    e) => false);
                await _startService();
              }
              Fluttertoast.showToast(msg: 'Absensi Berhasil');
            } else {
              if (context.mounted) {
                Navigator.pop(context);
              }
              Fluttertoast.showToast(msg: resp.message);
            }
          } else {
            if (context.mounted) {
              Navigator.pop(context);
            }
            Fluttertoast.showToast(msg: response.toString());
          }
        }
      }
    } else {
      Fluttertoast.showToast(msg: 'Data Belum Lengkap');
    }


  }

  Future<void> checkPermiss(BuildContext context) async {
    final result = await _determinePosition();

    if (result.type == 1) {
      if (context.mounted) {
        showCheckFailed(context, result.message, result.type);
      }
    } else if (result.type == 2) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      Fluttertoast.showToast(msg: result.message.toString());
    } else if (result.type == 4) {
      if (context.mounted) {
        showCheckFailed(context, result.message, result.type);
      }
    }
  }

  Future<void> checkOut(BuildContext context, String id) async {
    showLoading(context);
    final result = await _determinePosition();

    if (result.type == 1) {
      if (context.mounted) {
        showCheckFailed(context, result.message, result.type);
      }
    } else if (result.type == 2) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      Fluttertoast.showToast(msg: result.message.toString());
    } else if (result.type == 4) {
      if (context.mounted) {
        showCheckFailed(context, result.message, result.type);
      }
    } else {
      if (context.mounted) {
        final response = await ApiService.checkOut(context,
            id, result.position!.latitude, result.position!.longitude);

        if (response.runtimeType == DefaultResponse) {
          final resp = response as DefaultResponse;
          if (!resp.error) {
            if (context.mounted) {
              Navigator.pop(context);
              await _stopService();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                        (e) => false);
              }
            }
            Fluttertoast.showToast(msg: 'Check Out Absensi');
          } else {
            if (context.mounted) {
              Navigator.pop(context);
            }
            Fluttertoast.showToast(msg: resp.message);
          }
        } else {
          if (context.mounted) {
            Navigator.pop(context);
          }
          Fluttertoast.showToast(msg: response.toString());
        }
      }
    }
  }

  void showCheckFailed(BuildContext context, String message, int type) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/map.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        if (type == 1) {
                          AppSettings.openAppSettings(
                              type: AppSettingsType.location);
                        } else {
                          if (Platform.isAndroid) {
                            const AndroidIntent intent = AndroidIntent(
                              action:
                                  'action_application_details_settings',
                              data:
                                  'package:com.subagro.salesreport', // replace com.example.app with your applicationId
                            );
                            await intent.launch();
                          } else {
                            AppSettings.openAppSettings(
                                type: AppSettingsType.settings);
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(FontColor.yellow72),
                        shape:
                            WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                      ),
                      child: Text(
                        'Pengaturan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            color: FontColor.black),
                      ))
                ],
              ),
            ),
          );
        });
  }

  Future<void> checkLocation(BuildContext context) async {
    final result = await _determinePosition();
    if (context.mounted) {
      if (result.type == 1) {
        showCheckFailed(context, result.message, result.type);
      } else if (result.type == 2) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: result.message.toString());
      } else if (result.type == 4) {
        showCheckFailed(context, result.message, result.type);
      } else {

      }
    }
  }

  Future<LocationResult> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult(
          type: 1, message: 'Location services are disabled.', position: null);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult(
            type: 2,
            message: 'Location permissions are denied',
            position: null);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult(
          type: 4,
          message:
              'Location permissions are permanently denied, we cannot request permissions.',
          position: null);
    }

    final position = await Geolocator.getCurrentPosition();

    return LocationResult(type: 3, message: '', position: position);
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Service Lokasi Aktif',
        notificationText: 'Update Lokasi Setiap Saat',
        notificationIcon: null,
        callback: startCallback,
      );
    }
  }

  Future<ServiceRequestResult> _stopService() {
    return FlutterForegroundTask.stopService();
  }
}
