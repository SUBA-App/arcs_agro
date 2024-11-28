import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task/models/service_request_result.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/api/response/absen_response.dart';
import 'package:sales_app/api/response/active_absen_response.dart';
import 'package:sales_app/api/response/default_response.dart';
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

  Future<void> addAbsen(BuildContext context, File file) async {
    showLoading(context);

    final position = await _determinePosition();
    final response = await ApiService.addAbsen(file, position.latitude, position.longitude);

    if (response.runtimeType == DefaultResponse) {
      final resp = response as DefaultResponse;
      if (!resp.error) {
        await Preferences.saveStatusCheckIn(1);
        if (context.mounted) {
          Navigator.pop(context);
          await _startService();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
        }
        Fluttertoast.showToast(msg: 'Absensi Berhasil');
      } else {
        Fluttertoast.showToast(msg: resp.message);
      }
    } else {
      Fluttertoast.showToast(msg: response.toString());
    }
  }

  Future<void> checkOut(BuildContext context,String id) async {
    showLoading(context);
    final position = await _determinePosition();
    final response = await ApiService.checkOut(id, position.latitude, position.longitude);

    if (response.runtimeType == DefaultResponse) {
      final resp = response as DefaultResponse;
      if (!resp.error) {
        if (context.mounted) {
          Navigator.pop(context);
          await _stopService();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (e) => false);
        }
        Fluttertoast.showToast(msg: 'Check Out Absensi');
      } else {
        Fluttertoast.showToast(msg: resp.message);
      }
    } else {
      Fluttertoast.showToast(msg: response.toString());
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
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
