import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/absensi_screen.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/home_page.dart';
import 'package:sales_app/laporan_kerja_screen.dart';
import 'package:sales_app/login_screen.dart';

import 'detail_absensi_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int drawer = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: IconThemeData(
            color: FontColor.black
        ),
        title: Text(drawer == 0 ?"Home" : drawer == 1? "Absensi" : drawer == 2 ? "List Produk" :  "Laporan Kerja", style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: FontColor.black,
        ),),
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
                  child: const DrawerHeader(
                    decoration: BoxDecoration(
                      color: FontColor.yellow72,
                    ),
                    child: Text('Main Logo'),
                  ),
                ),
                ListTile(
                  leading: Image.asset('assets/images/home.png', width: 24, height: 24,),
                  title:  Text('Home', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black
                  ),),
                  onTap: () {
                    setState(() {
                      drawer = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/images/ballot-check.png', width: 24, height: 24,),
                  title:  Text('Absensi', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black
                  ),),
                  onTap: () {
                    setState(() {
                      drawer = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/images/box-open.png', width: 24, height: 24,),
                  title:  Text('List Produk', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black
                  ),),
                  onTap: () {
                    setState(() {
                      drawer = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/images/checklist-task-budget.png', width: 24, height: 24,),
                  title:  Text('Laporan Kerja', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black
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
              leading: Image.asset('assets/images/sign-out-alt.png', width: 24, height: 24,),
              title:  Text('Logout', style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black
              ),),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: drawer == 0 ? HomePage() : drawer == 1 ? AbsensiScreen(drawer: true) : drawer == 3 ? LaporanKerjaScreen(drawer: true) : Container(),
    );
  }
}
