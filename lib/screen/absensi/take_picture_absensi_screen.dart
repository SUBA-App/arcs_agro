import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/custom_camera.dart';
import 'package:sales_app/screen/absensi/next_absensi_screen.dart';
import 'package:sales_app/util.dart';

class TakePictureAbsensiScreen extends StatefulWidget {
  const TakePictureAbsensiScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakePictureAbsensiScreen> createState() =>
      _TakePictureAbsensiScreenState();
}

class _TakePictureAbsensiScreenState extends State<TakePictureAbsensiScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomCamera(onNext: (e) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => NextAbsensiScreen(paths: e)));
    }, camera: widget.camera,);
  }
}
