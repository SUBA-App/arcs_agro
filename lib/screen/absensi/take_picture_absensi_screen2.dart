import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/font_color.dart';

import '../../custom_camera.dart';

class TakePictureAbsensiScreen2 extends StatefulWidget {
  const TakePictureAbsensiScreen2({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakePictureAbsensiScreen2> createState() => _TakePictureAbsensiScreenState();
}

class _TakePictureAbsensiScreenState extends State<TakePictureAbsensiScreen2> {
  @override
  Widget build(BuildContext context) {
    return CustomCamera(onNext: (e) {
      Navigator.pop(context, e);
    }, camera: widget.camera,);
  }
}
