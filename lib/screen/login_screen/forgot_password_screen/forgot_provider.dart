import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_app/screen/main/otp_screen/otp_screen.dart';

import '../../../api/api_service.dart';
import '../../../api/response/default_response.dart';

class ForgotProvider extends ChangeNotifier {

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

  Future<void> checkEmail(BuildContext context,String email) async {
    if (email.isNotEmpty) {
      showLoading(context);
      final response = await ApiService.checkEmail(email);

      if (response.runtimeType == DefaultResponse) {
        final resp = response as DefaultResponse;
        if (!resp.error) {
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  OtpScreen(mode: 2, email: email,)),);
          }
        } else {
          if (context.mounted) {
            Navigator.pop(context);
          }
          Fluttertoast.showToast(msg: resp.message);
        }
      }
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Data belum lengkap');
    }
  }
}