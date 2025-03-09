

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/api/response/active_absen_response.dart';
import 'package:sales_app/api/response/default_response.dart';
import 'package:sales_app/screen/login_screen/login_screen.dart';
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

  Future<void> getActiveAbsensi(BuildContext context) async {
    print('25');
    isLoading = true;
    notifyListeners();
    final response = await ApiService.getActiveAbsensi(context);
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



  Future<void> changePw(BuildContext context,String password) async {
    showLoading(context);
    final response = await ApiService.changePw(context,password);
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

  Future<void> changePw2(BuildContext context,String password, String email) async {
    showLoading(context);
    final response = await ApiService.changePw2(password, email);
    if (response.runtimeType == DefaultResponse) {
      final resp = response as DefaultResponse;
      if (!resp.error) {
        if(context.mounted) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (e) => false);
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
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (e) => false);
        }
      } else {
        if(context.mounted) {
          Navigator.pop(context);
        }
        Fluttertoast.showToast(msg: resp.message);
      }
    } else {
      Preferences.clear();
      if(context.mounted) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (e) => false);
      }
      Fluttertoast.showToast(msg: response.toString());
    }
  }

  Future<void> _startService() async {
    if (!await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Kamu Sedang Check In',
        notificationText: 'Lokasi akan di update setiap 10 menit',
        notificationIcon: null,
        callback: startCallback,
      );
    }
  }


}
