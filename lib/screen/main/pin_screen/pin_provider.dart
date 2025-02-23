import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_app/api/response/default_response.dart';
import 'package:sales_app/screen/main/main_page.dart';
import 'package:sales_app/screen/main/pin_screen/pin_screen.dart';

import '../../../api/api_service.dart';
import '../../../api/response/create_pin_response.dart';
import '../../../util/preferences.dart';

class PinProvider extends ChangeNotifier {
  Future<void> createPin(BuildContext context, String pin) async {
    final response = await ApiService.createPin(context,pin);

    if (response.runtimeType == CreatePinResponse) {
      final resp = response as CreatePinResponse;
      if (!resp.error) {
        await Preferences.saveUser(resp.result);
        print('running');
        if (context.mounted) {
          print('running2');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PinScreen(mode: 3)),
              (e) => false);
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
        Fluttertoast.showToast(msg: resp.message);
      }
    }
  }

  Future<void> verifyPin(BuildContext context, String pin) async {
    final response = await ApiService.verifyPin(context,pin);

    if (response.runtimeType == DefaultResponse) {
      final resp = response as DefaultResponse;
      if (!resp.error) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
                  (e) => false);
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
        Fluttertoast.showToast(msg: resp.message);
      }
    }
  }
}
