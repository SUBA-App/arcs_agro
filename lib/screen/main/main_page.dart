import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:arcs_agro/change_pw_screen.dart';
import 'package:arcs_agro/configuration.dart';
import 'package:arcs_agro/screen/absensi/absensi_provider.dart';
import 'package:arcs_agro/screen/absensi/absensi_screen.dart';
import 'package:arcs_agro/font_color.dart';
import 'package:arcs_agro/home_page.dart';
import 'package:arcs_agro/screen/item/drawer_item.dart';
import 'package:arcs_agro/screen/product/product_screen.dart';
import 'package:arcs_agro/screen/report/laporan_kerja_screen.dart';
import 'package:arcs_agro/screen/main/main_provider.dart';
import 'package:arcs_agro/screen/sales-canvasser/receipts_screen.dart';
import 'package:arcs_agro/service/location_foreground_service.dart';
import 'package:arcs_agro/util/preferences.dart';

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
        Provider.of<MainProvider>(context, listen: false).checkStatus(context);
      });
    }).catchError((e) {
      LocationForegroundService.initService();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<MainProvider>(context, listen: false).getActiveAbsensi(context);
        Provider.of<AbsensiProvider>(context, listen: false).checkPermiss(context);
        Provider.of<MainProvider>(context, listen: false).checkStatus(context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: Text(drawer == 0 ?"Home" : drawer == 1? "Absensi" : drawer == 2 ? "List Produk" : drawer == 4 ? 'Tanda Terima' : "Laporan Kerja", style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: Colors.white,
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
                        Text("${Preferences.getUser()?.role} - ${Preferences.getUser()?.companyName}", style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: FontColor.black.withValues(alpha: 0.7)
                        ),),
                        Text("Versi ${Configuration.version}-${Configuration.buildNumber}", style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: FontColor.black.withValues(alpha: 0.7)
                        ),),
                      ],
                    ),
                  ),
                ),
                DrawerItem(onTap: () {
                  setState(() {
                    drawer = 0;
                  });
                  Navigator.pop(context);
                }, text: 'Home', image: 'assets/images/home.png', isActive: true,),
                DrawerItem(onTap: () {
                  setState(() {
                    drawer = 1;
                  });
                  Navigator.pop(context);
                }, text: 'Absensi', image: 'assets/images/ballot-check.png', isActive: provider.isAbsenteeism == 1 || provider.isAbsenteeism == 2,),
                DrawerItem(onTap: () {
                  setState(() {
                    drawer = 2;
                  });
                  Navigator.pop(context);
                }, text: 'List Produk', image: 'assets/images/box-open.png', isActive: provider.isProduct == 1 || provider.isProduct == 2,),
                DrawerItem(onTap: () {
                  setState(() {
                    drawer = 3;
                  });
                  Navigator.pop(context);
                }, text: 'Laporan Kerja', image: 'assets/images/checklist-task-budget.png', isActive: provider.isReport == 1 || provider.isReport == 2,),
                DrawerItem(onTap: () {
                  setState(() {
                    drawer = 4;
                  });
                  Navigator.pop(context);
                }, text: 'Sales Canvasser', image: 'assets/images/calendar-lines-pen.png', isActive: provider.isCanvasser == 1 || provider.isCanvasser == 2,),
              ],
            ),
            DrawerItem(onTap: () async {
              await Provider.of<MainProvider>(context, listen: false).logout(context);
            }, text: 'Logout', image: 'assets/images/sign-out-alt.png', isActive: true,),

          ],
        ),
      ),
      body: drawer == 0 ? const HomePage() : drawer == 1 ? const AbsensiScreen(drawer: true) : drawer == 2 ? const ProductScreen(drawer: true): drawer == 4 ? const ReceiptsScreen(drawer: true) : const LaporanKerjaScreen(drawer: true),
    );
  }
}
