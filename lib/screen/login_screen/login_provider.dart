import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/screen/main/pin_screen/pin_screen.dart';

import '../../api/response/login_response.dart';
import '../../util/preferences.dart';

class LoginProvider extends ChangeNotifier {

  void showLoading(BuildContext context) {
    showDialog(context: context,barrierDismissible: false, builder: (context)  {
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

  Future<void> login(
      BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Email Atau Password Belum Diisi');
    } else {
      showLoading(context);
      FocusManager.instance.primaryFocus?.unfocus();
      final response = await ApiService.login(email, password);

      if (response.runtimeType == LoginResponse) {
        final resp = response as LoginResponse;
        if (!resp.error) {
          await Preferences.saveSession(resp.result!.token, resp.result!.user);
          ApiService.init();
          if (context.mounted) {
            if (resp.result!.user.hasPin) {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => const PinScreen(mode: 3)), (e) => false);
            } else {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => const PinScreen(mode: 1)), (e) => false);
            }
            
          }
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
