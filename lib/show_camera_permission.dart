import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:app_settings/app_settings.dart';

import 'package:flutter/material.dart';

import 'font_color.dart';

class ShowCameraPermission extends StatelessWidget {
  const ShowCameraPermission({super.key, required this.message});

  final String message;
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/camera_n.png',
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
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
                      )),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        const WidgetStatePropertyAll(Colors.white),
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
  }
}
