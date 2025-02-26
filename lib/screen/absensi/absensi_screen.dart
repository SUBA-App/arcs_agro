import 'package:camera/camera.dart';
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:sales_app/screen/absensi/absensi_item.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/absensi/take_picture_absensi_screen.dart';
import 'package:sales_app/screen/dialog/filter_dialog.dart';
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
      Provider.of<AbsensiProvider>(context, listen: false).clear();
      Provider.of<AbsensiProvider>(context, listen: false).getAbsensi(context, 1);
    });

    availableCameras().then((e) {
      cameraDescription = e.first;
    });
    super.initState();
  }

  String selectedDropdown = 'Semua';

  Future<void> startDate(BuildContext context, int mode) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: FontColor.yellow72, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: FontColor.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: FontColor.black, // button text color
              ),
            ),
          ), child: child!);
        },
        context: context,
        initialDate: mode == 1 ?
        (Provider.of<AbsensiProvider>(context, listen: false).start.isEmpty ? null : DateTime.tryParse(Provider.of<AbsensiProvider>(context, listen: false).start))
        :(Provider.of<AbsensiProvider>(context, listen: false).end.isEmpty ? null : DateTime.tryParse(Provider.of<AbsensiProvider>(context, listen: false).end)),
        locale: const Locale("id"),
        firstDate: DateTime(2000,1),
        lastDate: DateTime(2100, 1));
    if (picked != null) {
      setState(() {
        final format = DateFormat('yyyy-MM-dd').format(picked);
        if (mode == 1) {
          Provider.of<AbsensiProvider>(context, listen: false).setStart(format);
        } else {
          Provider.of<AbsensiProvider>(context, listen: false).setEnd(format);
        }
      });
    }
  }

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: FontColor.black,
                      style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontWeight: FontWeight.w400,
                          color: FontColor.black,
                          fontSize: 14
                      ),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          labelText: "Pencarian",
                          labelStyle: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black,
                              fontSize: 14
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: FontColor.yellow72,
                              )
                          ),
                          contentPadding: const EdgeInsets.all(8)
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (e) {
                        Provider.of<AbsensiProvider>(context, listen: false).clear();
                        Provider.of<AbsensiProvider>(context, listen: false).setSearch(e);
                        Provider.of<AbsensiProvider>(context, listen: false).getAbsensi(context,1);
                      },
                      onChanged: (e) {
                        if (e.isEmpty) {
                          Provider.of<AbsensiProvider>(context, listen: false).clear();
                          Provider.of<AbsensiProvider>(context, listen: false).setSearch(e);
                          Provider.of<AbsensiProvider>(context, listen: false).getAbsensi(context,1);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16,),
                  IconButton(
                    icon: Image.asset('assets/images/filter-list.png', width: 20,height: 20,),
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(10)
                      ))
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,isDismissible: false, builder: (context) {
                        final provider1 = Provider.of<AbsensiProvider>(context);
                        return FilterDialog(applyTap: () {
                          Navigator.pop(context);
                          Provider.of<AbsensiProvider>(context, listen: false).getAbsensi(context,1);
                        }, start: provider1.start, end: provider1.end, startTap: () {
                          startDate(context, 1);
                        }, endTap: () {startDate(context, 2);  }, sort: provider1.sort, sortChange: (String e) {
                          Provider.of<AbsensiProvider>(context, listen: false).setSort(e);
                        }, clear: () { Provider.of<AbsensiProvider>(context, listen: false).clear(); },);
                      });
                    },
                  ),
                ],
              ),
            ),
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
