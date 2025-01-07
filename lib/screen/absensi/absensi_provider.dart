import 'dart:io' show File, Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task/models/service_request_result.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/api/model/location_result.dart';
import 'package:sales_app/api/response/absen_response.dart';
import 'package:sales_app/api/response/active_absen_response.dart';
import 'package:sales_app/api/response/default_response.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/screen/main/main_page.dart';
import 'package:sales_app/util/preferences.dart';

import '../../service/location_foreground_service.dart';

class AbsensiProvider extends ChangeNotifier {
  List<AbsenResult> absens = [];
  String selected = "Semua";
  String fromDate = "";
  String toDate = "";
  bool isLoading = false;

  AbsenResult? absenResult;
  bool isLoadingDetail = false;

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

  Future<void> getAbsensi() async {
    isLoading = true;
    notifyListeners();
    final response = await ApiService.getAbsensi();
    if (response.runtimeType == AbsenResponse) {
      final resp = response as AbsenResponse;
      if (!resp.error) {
        isLoading = false;
        absens = resp.result;
        notifyListeners();
      }
    }
  }

  Future<void> getDetailAbsensi(String id) async {
    isLoadingDetail = true;
    notifyListeners();
    final response = await ApiService.getDetailAbsensi(id);
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
      BuildContext context, List<File> files, String kios) async {
    if (files.isNotEmpty && kios != 'Pilih Kios') {
      showLoading(context);

      final result = await _determinePosition();

      if (result.type == 1) {
        showCheckFailed(context, result.message, result.type);
      } else if (result.type == 2) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: result.message.toString());
      } else if (result.type == 4) {
        showCheckFailed(context, result.message, result.type);
      } else {
        final response = await ApiService.addAbsen(
            files, result.position!.latitude, result.position!.longitude, kios);

        if (response.runtimeType == DefaultResponse) {
          final resp = response as DefaultResponse;
          if (!resp.error) {
            await Preferences.saveStatusCheckIn(1);
            if (context.mounted) {
              Navigator.pop(context);
              await _startService();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
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
    } else {
      Fluttertoast.showToast(msg: 'Data Belum Lengkap');
    }
  }

  Future<void> checkOut(BuildContext context, String id) async {
    showLoading(context);
    final result = await _determinePosition();

    if (result.type == 1) {
      showCheckFailed(context, result.message, result.type);
    } else if (result.type == 2) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: result.message.toString());
    } else if (result.type == 4) {
      showCheckFailed(context, result.message, result.type);
    } else {
      final response = await ApiService.checkOut(
          id, result.position!.latitude, result.position!.longitude);

      if (response.runtimeType == DefaultResponse) {
        final resp = response as DefaultResponse;
        if (!resp.error) {
          if (context.mounted) {
            Navigator.pop(context);
            await _stopService();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                    (e) => false);
          }
          Fluttertoast.showToast(msg: 'Check Out Absensi');
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: resp.message);
        }
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: response.toString());
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
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (type == 1) {
                                AppSettings.openAppSettings(
                                    type: AppSettingsType.location);
                              } else {
                                if (Platform.isAndroid) {
                                  const AndroidIntent intent = AndroidIntent(
                                    action:
                                        'action_application_details_settings',
                                    data:
                                        'package:com.example.sales_app', // replace com.example.app with your applicationId
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
                                  WidgetStatePropertyAll(FontColor.yellow72),
                              shape:
                                  WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                            child: Text(
                              'Pengaturan',
                              style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  color: FontColor.black),
                            )),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              shape:
                                  WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                            ),
                            child: Text(
                              'Tutup',
                              style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  color: FontColor.black),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> checkLocation(BuildContext context) async {
    final result = await _determinePosition();

    if (result.type == 1) {
      showCheckFailed(context, result.message, result.type);
    } else if (result.type == 2) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: result.message.toString());
    } else if (result.type == 4) {
      showCheckFailed(context, result.message, result.type);
    } else {
      print(result.position!.longitude);
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
