import 'package:camera/camera.dart';
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:sales_app/screen/absensi/absensi_item.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/absensi/take_picture_absensi_screen.dart';
import 'package:sales_app/show_camera_permission.dart';

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
      Provider.of<AbsensiProvider>(context, listen: false).getAbsensi(context, 1);
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
        iconTheme: const IconThemeData(
          color: FontColor.black
        ),
        title: Text("Absensi",style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: FontColor.black,
          fontSize: 16
        ),),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(onPressed: () async {
        const c = Permission.camera;
        if (await c.isGranted){
          Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureAbsensiScreen(camera: cameraDescription)));
        } else if(await c.isPermanentlyDenied) {
          showDialog(context: context, builder: (context) {
            return const ShowCameraPermission(message: 'Camera permissions are permanently denied, we cannot request permissions.');
          });
        } else {
          await Permission.camera.request();
        }
      },backgroundColor: FontColor.yellow72, child: Image.asset('assets/images/camera2.png', width: 24,height: 24,),),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            provider.isLoading
                ? const Expanded(
                child: Center(
                    child: CircularProgressIndicator(
                      color: FontColor.black,
                    )))
                : Expanded(
              child: EnhancedPaginatedView(
                builder: (items, physics, reverse, shrinkWrap) {
                  return ListView.builder(
                    physics: physics,
                    shrinkWrap: shrinkWrap,
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AbsensiItem(result: provider.absens[index]);
                    },
                  );
                },
                itemsPerPage: 20,
                onLoadMore: (e) {
                  if(e > 1) {
                    Provider.of<AbsensiProvider>(context, listen: false)
                        .loadMoreAbsensi(
                        context, e);
                  }
                },
                hasReachedMax: provider.isMaxReached,
                delegate: EnhancedDelegate(
                  listOfData: provider.absens,
                  status: provider.enhancedStatus,
                  header: Container(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
