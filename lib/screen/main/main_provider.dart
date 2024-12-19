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
import 'package:sales_app/api/response/check_status_response.dart';
import 'package:sales_app/api/response/default_response.dart';
import 'package:sales_app/screen/login_screen/login_screen.dart';
import 'package:sales_app/screen/main/main_page.dart';
import 'package:sales_app/util/preferences.dart';

import '../../service/location_foreground_service.dart';

class MainProvider extends ChangeNotifier {

  bool isLoading = true;
  ActiveResult? result;

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

  Future<void> getActiveAbsensi() async {
    isLoading = true;
    notifyListeners();
    final response = await ApiService.getActiveAbsensi();
    if (response.runtimeType == ActiveAbsenResponse) {
      final resp = response as ActiveAbsenResponse;
      if (!resp.error) {
        isLoading = false;
        result = resp.result;
        notifyListeners();
        if (resp.result.status == 1) {
          _startService();
        }
      }
    }
  }

  Future<void> checkStatus(BuildContext context) async {
    final response = await ApiService.checkStatus(context);
    if (response.runtimeType == CheckStatusResponse) {
      final resp = response as CheckStatusResponse;
      if (!resp.error) {
        if (resp.result.status == 0) {
          Preferences.clear();
          if (context.mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          }
        }
      }
    }
  }

  Future<void> changePw(BuildContext context,String password) async {
    showLoading(context);
    final response = await ApiService.changePw(password);
    if (response.runtimeType == DefaultResponse) {
      final resp = response as DefaultResponse;
      if (!resp.error) {
        if(context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        if(context.mounted) {
          Navigator.pop(context);
        }
        Fluttertoast.showToast(msg: resp.message);
      }
    } else {
      if(context.mounted) {
        Navigator.pop(context);
      }
      Fluttertoast.showToast(msg: response.toString());
    }
  }

  Future<void> logout(BuildContext context) async {
    showLoading(context);
    final response = await ApiService.logout();
    if (response.runtimeType == DefaultResponse) {
      final resp = response as DefaultResponse;
      if (!resp.error) {
        Preferences.clear();
        if(context.mounted) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (e) => false);
        }
      } else {
        if(context.mounted) {
          Navigator.pop(context);
        }
        Fluttertoast.showToast(msg: resp.message);
      }
    } else {
      if(context.mounted) {
        Navigator.pop(context);
      }
      Fluttertoast.showToast(msg: response.toString());
    }
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Kamu Sedang Check In',
        notificationText: 'Lokasi akan di update setiap 10 menit',
        notificationIcon: null,
        callback: startCallback,
      );
    }
  }


}
