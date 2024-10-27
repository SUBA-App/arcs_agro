import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'absensi_screen.dart';
import 'detail_absensi_screen.dart';
import 'font_color.dart';
import 'laporan_kerja_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset('assets/images/profile_placeholder.jpg'),
                      ),
                    ),
                    SizedBox(width: 16,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Antoni", style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: FontColor.black
                        ),),
                        Text("Sales Koordinator", style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: FontColor.black.withOpacity(0.5)
                        ),),
                        SizedBox(height: 8,),
                        Container(
                          alignment: Alignment.center,
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green
                          ),
                          child: Text("Check In", style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 24,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text("Absensi Sekarang",textAlign: TextAlign.center, style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: FontColor.black
                  ),),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailAbsensiScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        height: 70,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Absensi", style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: FontColor.black
                                ),),
                                Text("22 Desember 2023", style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: FontColor.black.withOpacity(0.5)
                                ),),
                                Text("18:19", style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: FontColor.black.withOpacity(0.5)
                                ),),
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green
                              ),
                              child: Text("Check In", style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 50,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AbsensiScreen(drawer: false,)));
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: FontColor.yellow72,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/ballot-check.png', width: 40, height: 40,),
                            Text("Absensi",textAlign: TextAlign.center, style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: FontColor.black
                            ),),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: FontColor.yellow72,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/box-open.png', width: 40, height: 40,),
                            Text("List Produk",textAlign: TextAlign.center, style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: FontColor.black
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LaporanKerjaScreen(drawer: false,)));
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: FontColor.yellow72,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/checklist-task-budget.png', width: 40, height: 40,),
                            Text("Laporan Kerja",textAlign: TextAlign.center, style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: FontColor.black
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
