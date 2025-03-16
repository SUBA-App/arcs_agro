import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/change_pw_screen.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/absensi/absensi_screen.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/home_page.dart';
import 'package:sales_app/screen/product/product_screen.dart';
import 'package:sales_app/screen/report/laporan_kerja_screen.dart';
import 'package:sales_app/screen/main/main_provider.dart';
import 'package:sales_app/service/location_foreground_service.dart';
import 'package:sales_app/util/preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int drawer = 0;

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      await Permission.camera.request();
      await Permission.location.request();
      if (sdkInt >= 33) {
        await Permission.photos.request();
        await Permission.notification.request();
      } else {
        await Permission.storage.request();
      }
    } else {
      await Permission.camera.request();
      await Permission.location.request();
      await Permission.photos.request();
      await Permission.storage.request();
    }
  }

  @override
  void initState() {
    requestPermission().whenComplete(() {
      LocationForegroundService.initService();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<MainProvider>(context, listen: false).getActiveAbsensi(context);
        Provider.of<AbsensiProvider>(context, listen: false).checkPermiss(context);
      });
    }).catchError((e) {
      LocationForegroundService.initService();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<MainProvider>(context, listen: false).getActiveAbsensi(context);
        Provider.of<AbsensiProvider>(context, listen: false).checkPermiss(context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(
            color: FontColor.black
        ),
        title: Text(drawer == 0 ?"Home" : drawer == 1? "Absensi" : drawer == 2 ? "List Produk" :  "Laporan Kerja", style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: FontColor.black,
          fontSize: 16
        ),),
        actions: [
          PopupMenuButton<String>(
            surfaceTintColor: Colors.white,
            color: Colors.white,
            onSelected: (e) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePwScreen()));
            },
            itemBuilder: (BuildContext context) {
              return {'Ganti Sandi'}.map((String choice) {
                return PopupMenuItem<String>(

                  value: choice,
                  child: Text(choice, style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontColor.fontPoppins,
                    fontWeight: FontWeight.w400
                  ),),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          // Important: Remove any padding from the ListView.
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: FontColor.yellow72,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset('assets/images/businessman.png', width: 80,height: 80,),
                          ),
                        ),
                        Text(Preferences.getUser()?.name ?? '', style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontWeight: FontWeight.w500,
                            color: FontColor.black,
                            fontSize: 14
                        ),),
                        Text("Sales - ${Preferences.getUser()?.companyName}", style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: FontColor.black.withValues(alpha: 0.7)
                        ),),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Image.asset('assets/images/home.png', width: 20, height: 20,),
                  title:  Text('Home', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black,
                    fontSize: 14
                  ),),
                  onTap: () {
                    setState(() {
                      drawer = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/images/ballot-check.png', width: 20, height: 20,),
                  title:  Text('Absensi', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black,
                      fontSize: 14
                  ),),
                  onTap: () {
                    setState(() {
                      drawer = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/images/box-open.png', width: 20, height: 20,),
                  title:  Text('List Produk', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black,
                      fontSize: 14
                  ),),
                  onTap: () {
                    setState(() {
                      drawer = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/images/checklist-task-budget.png', width: 20, height: 20,),
                  title:  Text('Laporan Kerja', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black,
                      fontSize: 14
                  ),),
                  onTap: () {
                    setState(() {
                      drawer = 3;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ListTile(
              leading: Image.asset('assets/images/sign-out-alt.png', width: 20, height: 20,),
              title:  Text('Logout', style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black,
                fontSize: 14
              ),),
              onTap: () async {
                await Provider.of<MainProvider>(context, listen: false).logout(context);
              },
            ),
          ],
        ),
      ),
      body: drawer == 0 ? const HomePage() : drawer == 1 ? const AbsensiScreen(drawer: true) : drawer == 2 ? const ProductScreen(drawer: true): const LaporanKerjaScreen(drawer: true),
    );
  }
}
