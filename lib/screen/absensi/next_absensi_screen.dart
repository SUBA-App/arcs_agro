import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/absensi/next_absensi_provider.dart';
import 'package:sales_app/screen/absensi/take_picture_absensi_screen2.dart';

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
    availableCameras().then((e) {
      cameraDescription = e.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider =  Provider.of<NextAbsensiProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Check In Absensi",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins, color: FontColor.black, fontSize: 16),
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
                      final result =await  Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureAbsensiScreen2(camera: cameraDescription)));
                      if (result != null) {
                        setState(() {
                          widget.paths.addAll(result);
                          selectedPage = 0;
                          controller.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
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
                          color: Colors.black, fontFamily: FontColor.fontPoppins),
                    ))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PageView.builder(
                controller: controller,
                onPageChanged: (i) {
                  setState(() {
                    selectedPage = i;
                  });
                },

                itemCount: widget.paths.length,
                  itemBuilder: (context, index) {
                return Stack(
                  children: [
                    SizedBox(width:double.infinity,child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.file(File(widget.paths[index]), fit: BoxFit.fill,))),
                    Positioned(
                      top:16,
                      right: 16,
                      child: SizedBox(
                        width:30,
                        height:30,
                        child: IconButton(onPressed: () {
                          setState(() {
                            widget.paths.remove(widget.paths[index]);
                            selectedPage = 0;
                          });
                        }, style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red),
                          padding: WidgetStatePropertyAll(EdgeInsets.zero)
                        ),icon: const Icon(Icons.clear, color: Colors.white,size: 20,)),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
          widget.paths.isNotEmpty ?
          PageViewDotIndicator(
            currentItem: selectedPage,
            count: widget.paths.length,
            unselectedColor: Colors.black26,
            selectedColor: Colors.blue,
            size: const Size(6, 6),
          ):const SizedBox(),
          const SizedBox(height: 16,),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseCustomerScreen()));
              if (result != null) {
                Provider.of<NextAbsensiProvider>(context, listen: false).setKios(result['name'], result['id']);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(provider.selectedKios, style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontColor.fontPoppins,
                        fontWeight: FontWeight.w400,
                      ),),
                      const Icon(Icons.keyboard_arrow_right, color: Colors.black54,)
                    ],
                  ),
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
                      if (widget.paths.isNotEmpty || Provider.of<NextAbsensiProvider>(context, listen: false).selectedKios != "Pilih Kios") {
                        List<File> files = [];
                        for(var i in widget.paths) {
                          files.add(File(i));
                        }
                        await Provider.of<AbsensiProvider>(
                            context, listen: false).addAbsen(
                            context, files, Provider.of<NextAbsensiProvider>(context, listen: false).selectedKios);
                      } else {
                        Fluttertoast.showToast(msg: 'Data Belum Lengkap');
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(FontColor.yellow72),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    child: Text(
                      "Check In",
                      style: TextStyle(
                          color: Colors.black, fontFamily: FontColor.fontPoppins),
                    ))),
          )
        ],
      ),
    );
  }
}
