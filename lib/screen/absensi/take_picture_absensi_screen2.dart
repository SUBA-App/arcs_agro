import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../custom_camera.dart';

class TakePictureAbsensiScreen2 extends StatefulWidget {
  const TakePictureAbsensiScreen2({super.key, required this.camera, required this.mode});

  final CameraDescription camera;
  final int mode;

  @override
  State<TakePictureAbsensiScreen2> createState() => _TakePictureAbsensiScreenState();
}

class _TakePictureAbsensiScreenState extends State<TakePictureAbsensiScreen2> {

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

  @override
  Widget build(BuildContext context) {
    return CustomCamera(onNext: (e) async {
      if (widget.mode == 1) {
        showLoading(context);
        try {
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pop(context, e);
          }
        } catch (_) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      } else {
        Navigator.pop(context, e);
      }

    }, camera: widget.camera,);
  }
}
