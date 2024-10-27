import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/next_absensi_screen.dart';

class TakePictureAbsensiScreen extends StatefulWidget {
  const TakePictureAbsensiScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakePictureAbsensiScreen> createState() => _TakePictureAbsensiScreenState();
}

class _TakePictureAbsensiScreenState extends State<TakePictureAbsensiScreen> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  SizedBox(height:double.infinity, child: CameraPreview(_controller)),
                  Align(alignment: Alignment.topLeft,child: IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back, color: Colors.white,))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          await _initializeControllerFuture;
                          final image = await _controller.takePicture();
                          if (!context.mounted) return;
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NextAbsensiScreen(
                                path: image.path,
                              ),
                            ),
                          );
                        } catch (e) {
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Image.asset('assets/images/camera.png', width: 60,height: 60,),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator(color: FontColor.yellow72,));
            }
          },
        ),
      ),
    );
  }
}
