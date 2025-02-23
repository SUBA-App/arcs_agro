import 'dart:io';

import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/absensi/next_absensi_provider.dart';
import 'package:sales_app/screen/absensi/take_picture_absensi_screen2.dart';
import 'package:sales_app/util.dart';

import '../../font_color.dart';
import '../report/choose_customer_screen.dart';

class NextAbsensiScreen extends StatefulWidget {
  const NextAbsensiScreen({super.key, required this.paths});

  final List<String> paths;

  @override
  State<NextAbsensiScreen> createState() => _NextAbsensiScreenState();
}

class _NextAbsensiScreenState extends State<NextAbsensiScreen> {
  int selectedPage = 0;

  late CameraDescription cameraDescription;
  final controller = PageController();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    WidgetsBinding.instance.addPostFrameCallback((e) {
      Provider.of<NextAbsensiProvider>(context, listen: false)
          .setKios('Pilih Kios', 0);
    });
    availableCameras().then((e) {
      cameraDescription = e.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
    final provider = Provider.of<NextAbsensiProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Check In Absensi",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              color: FontColor.black,
              fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TakePictureAbsensiScreen2(
                                  camera: cameraDescription)));
                      if (result != null) {
                        setState(() {
                          widget.paths.addAll(result);
                          selectedPage = 0;
                          controller.animateToPage(0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.bounceIn);
                        });
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(FontColor.yellow72),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    child: Text(
                      "Tambah Foto",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: FontColor.fontPoppins),
                    ))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
    aspectRatio: 9/16,
                child: PageView.builder(
                  itemCount: widget.paths.length,
                  onPageChanged: (i) {
                    setState(() {
                      selectedPage = i;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9/16,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(blurRadius: 1, color: Colors.black12)
                                ]),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(widget.paths[index]),
                                  fit: BoxFit.contain,
                                )),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    widget.paths.remove(widget.paths[index]);
                                    selectedPage = 0;
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                    WidgetStatePropertyAll(Colors.black87),
                                    visualDensity: VisualDensity(),
                                    padding:
                                    WidgetStatePropertyAll(EdgeInsets.zero),
                                    elevation: WidgetStatePropertyAll(0),
                                    minimumSize:
                                    WidgetStatePropertyAll(Size(40, 40)),
                                    tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft:
                                                Radius.circular(20))))),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )))
                      ],
                    );
                  },
                    ),
              ),
            ),
          ),
          widget.paths.isNotEmpty
              ? PageViewDotIndicator(
                  currentItem: selectedPage,
                  count: widget.paths.length,
                  unselectedColor: Colors.black26,
                  selectedColor: Colors.blue,
                  size: const Size(6, 6),
                )
              : const SizedBox(),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChooseCustomerScreen()));
              if (result != null) {
                Provider.of<NextAbsensiProvider>(context, listen: false)
                    .setKios(result['name'], result['id']);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 45,
                padding: const EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.5,
                      color: Colors.black26,
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        provider.selectedKios,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: FontColor.fontPoppins,
                          fontWeight: FontWeight.w400,
                          color: provider.selectedKios == "Pilih Kios" ? Colors.black45 : FontColor.black
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black54,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      List<File> files = [];
                      for (var i in widget.paths) {
                        files.add(File(i));
                      }
                        await Provider.of<AbsensiProvider>(
                            context, listen: false)
                            .addAbsen(
                            context,
                            files,
                            Provider
                                .of<NextAbsensiProvider>(context,
                                listen: false)
                                .selectedKios);

                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(FontColor.yellow72),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    child: Text(
                      "Check In",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: FontColor.fontPoppins),
                    ))),
          )
        ],
      ),
    );
  }
}
