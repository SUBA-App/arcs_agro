import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'font_color.dart';

class CustomCamera extends StatefulWidget {
  const CustomCamera({super.key, required this.onNext, required this.camera});

  final Function(List<File> path) onNext;
  final CameraDescription camera;

  @override
  State<CustomCamera> createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera>
    with TickerProviderStateMixin {
  late CameraController _controller;

  List<File> paths = [];
  late AnimationController _controllerM;
  late Animation<double> _animation;

  late AnimationController _focusAnimationC;
  late Animation<double> _focusAnimation;

  late Future<void> _initC;

  double y = 0.0;
  double x = 0.0;
  bool showFocus = false;

  Future<void> onViewFinderTap(
      TapDownDetails details, BoxConstraints constraints) async {
    final CameraController cameraController = _controller;

    setState(() {
      y = details.localPosition.dy;
      x = details.localPosition.dx;
      showFocus = true;
    });

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);

    await _focusAnimationC.forward();
    await _focusAnimationC.reverse();

    setState(() {
      showFocus = false;
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
    );
    _initC = _controller.initialize();

    _controllerM = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 60, end: 50).animate(_controllerM)
      ..addListener(() {
        setState(() {});
      });

    _focusAnimationC = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusAnimation =
        Tween<double>(begin: 50, end: 40).animate(_focusAnimationC)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose();
    _controllerM.dispose();
    _focusAnimationC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: false,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: FutureBuilder<void>(
            future: _initC,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _controller.setFlashMode(FlashMode.off);
                return Stack(
                  children: [
                    Center(
                      child: CameraPreview(
                        _controller,
                        child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTapDown: (TapDownDetails details) =>
                                    onViewFinderTap(details, constraints),
                              );
                            }),
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      width: double.infinity,
                      height: 80,
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 18,
                                )),
                          )),
                    ),
                    showFocus
                        ? Positioned(
                            top: y - 20,
                            left: x - 20,
                            child: Container(
                              height: _focusAnimation.value,
                              width: _focusAnimation.value,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.yellow, width: 1)),
                            ),
                          )
                        : const SizedBox(),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.black12,
                        width: double.infinity,
                        height: 100,
                        child: GestureDetector(
                          onTap: () async {
                            await _controllerM.forward();
                            try {
                              await _initC;
                              if (_controller.value.isInitialized) {
                                final image = await _controller.takePicture();
                                if (!context.mounted) return;
                                
                                setState(() {
                                  paths.insert(0, File(image.path));
                                });
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print("ee32 $e");
                              }
                            }
                            await _controllerM.reverse();
                          },
                          child: Center(
                            child: Container(
                              width: _animation.value,
                              height: _animation.value,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    paths.isNotEmpty
                        ? Positioned(
                            bottom: 24,
                            right: 16,
                            child: Column(
                              children: [
                                Text(
                                  paths.length.toString(),
                                  style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                                IconButton(
                                    onPressed: () {
                                      widget.onNext.call(paths);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.green)),
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )),
                              ],
                            ))
                        : const SizedBox()
                  ],
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: FontColor.yellow72,
                ));
              }
            },
          ),
        ));
  }
}
