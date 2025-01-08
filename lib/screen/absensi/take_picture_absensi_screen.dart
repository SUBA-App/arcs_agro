import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/screen/absensi/next_absensi_screen.dart';

class TakePictureAbsensiScreen extends StatefulWidget {
  const TakePictureAbsensiScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<TakePictureAbsensiScreen> createState() => _TakePictureAbsensiScreenState();
}

class _TakePictureAbsensiScreenState extends State<TakePictureAbsensiScreen> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  List<String> paths = [];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  SizedBox(height:double.infinity, child: CameraPreview(_controller)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(alignment: Alignment.topLeft,child: IconButton(onPressed: () {
                      Navigator.pop(context);
                    }, style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ), icon: Icon(Icons.arrow_back, color: Colors.black, size: 18,))),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          await _initializeControllerFuture;
                          final image = await _controller.takePicture();
                          if (!context.mounted) return;
                          setState(() {
                            paths.add(image.path);
                          });
                        } catch (e) {
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Image.asset('assets/images/camera.png', width: 60,height: 60,),
                      ),
                    ),
                  ),
                  paths.isNotEmpty ?
                  Positioned(
                    bottom: 24,
                    right: 16,
                    child: Column(
                      children: [Text(paths.length.toString(), style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: Colors.white,
                        fontSize: 16
                      ),),

                        IconButton(onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NextAbsensiScreen(
                                paths: paths,
                              ),
                            ),
                          );
                        },style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.green)
                        ), icon: Icon(Icons.check, color: Colors.white,)),
                      ],
                    )
                  ) : SizedBox()
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
