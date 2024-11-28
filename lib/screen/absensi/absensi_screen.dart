import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/absensi/detail_absensi_screen.dart';
import 'package:sales_app/screen/absensi/absensi_item.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/absensi/take_picture_absensi_screen.dart';

import '../../font_color.dart';

class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key, required this.drawer});

  final bool drawer;

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  late CameraDescription cameraDescription;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<AbsensiProvider>(context, listen: false).getAbsensi();
    });

    availableCameras().then((e) {
      cameraDescription = e.first;
    });
    super.initState();
  }

  String selectedDropdown = 'Semua';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AbsensiProvider>(context);
    return Scaffold(
      appBar: widget.drawer ? null : AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: IconThemeData(
          color: FontColor.black
        ),
        title: Text("Absensi",style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: FontColor.black,
          fontSize: 16
        ),),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureAbsensiScreen(camera: cameraDescription)));
      }, child: Icon(Icons.camera),backgroundColor: FontColor.yellow72,),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            provider.isLoading ? Expanded(child: Center(child: CircularProgressIndicator(color: Colors.black,),),) : provider.absens.isEmpty ? Expanded(child: Center(child: Image.asset('assets/images/empty.png', width: 170,height: 170,),)) :
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                    itemCount: provider.absens.length,
                    itemBuilder: (context, index) {
                  return AbsensiItem(result: provider.absens[index],);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
