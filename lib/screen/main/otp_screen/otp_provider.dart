


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_app/api/response/default_response.dart';
import 'package:sales_app/screen/forgot_password/change_pw2_screen.dart';
import 'package:sales_app/screen/main/pin_screen/pin_screen.dart';

import '../../../api/api_service.dart';

class OtpProvider extends ChangeNotifier {

   late Timer timer;

   int otpTime = 0;

  void startTimer() {
    otpTime = 2 * 60000;
    notifyListeners();
    const oneSec = Duration(milliseconds: 1000);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (otpTime == 0) {
          timer.cancel();
        } else {
          otpTime -= 1000;
        }
        notifyListeners();
      },
    );
  }

  void stopTimer() {
    otpTime = 0;
    timer.cancel();
  }

  Future<void> sendOtpEmail(BuildContext context, String email) async {
    final response = await ApiService.sendOtpEmail(email);

    if (response.runtimeType == DefaultResponse) {
      final resp = response as DefaultResponse;
      if (!resp.error) {
        startTimer();
      } else {
        Fluttertoast.showToast(msg: resp.message);
      }
    }
  }

  Future<void> verifyOtp(BuildContext context, String otp, String email, int mode) async {
    final response = await ApiService.verifyOTP(otp, email);

    if (response.runtimeType == DefaultResponse) {
      final resp = response as DefaultResponse;
      if (!resp.error) {
        if (context.mounted) {
          if (mode == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePw2Screen(email: email,)));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PinScreen(mode: 1)));
          }
        }
      } else {
        Fluttertoast.showToast(msg: resp.message);
      }
    }
  }
}
