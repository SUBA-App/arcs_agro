import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:arcs_agro/custom_camera.dart';
import 'package:arcs_agro/screen/absensi/next_absensi_screen.dart';

class TakePictureAbsensiScreen extends StatefulWidget {
  const TakePictureAbsensiScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakePictureAbsensiScreen> createState() =>
      _TakePictureAbsensiScreenState();
}

class _TakePictureAbsensiScreenState extends State<TakePictureAbsensiScreen> {

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
    return CustomCamera(onNext: (e) async{
      showLoading(context);
      try {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => NextAbsensiScreen(paths: e)));
        }
      } catch(_) {
        if (context.mounted) {
          Navigator.pop(context);
        }
      }

    }, camera: widget.camera,);
  }
}
