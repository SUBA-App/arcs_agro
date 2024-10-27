import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_app/add_laporan_screen.dart';
import 'package:sales_app/laporan_kerja_detail.dart';
import 'package:sales_app/util.dart';

import 'font_color.dart';

class LaporanKerjaScreen extends StatefulWidget {
  const LaporanKerjaScreen({super.key, required this.drawer});

  final bool drawer;

  @override
  State<LaporanKerjaScreen> createState() => _LaporanKerjaScreenState();
}

class _LaporanKerjaScreenState extends State<LaporanKerjaScreen> {

  DateTime sDate = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(hour: 00, minute: 00));
  DateTime eDate =
  DateTime.now().appliedFromTimeOfDay(const TimeOfDay(hour: 22, minute: 58));

  int startMillis = 0;
  int endMillis = 0;

  Future<void> startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("id"),
        initialDate: sDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        startMillis = picked.millisecondsSinceEpoch;
        print(startMillis.toString());
        sDate = picked;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.drawer ? null :  AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: IconThemeData(
          color: FontColor.black
        ),
        title: Text("Laporan Kerja",style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: FontColor.black
        ),),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddLaporanScreen()));
      }, child: Icon(Icons.add),backgroundColor: FontColor.yellow72,),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: FontColor.black,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                    labelText: "Pencarian",
                    labelStyle: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontWeight: FontWeight.w400,
                        color: FontColor.black
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black26,
                      ),

                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: FontColor.yellow72,
                        )
                    )
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LaporanKerjaDetail()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                  Text("Warung Ayu", style: TextStyle(
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
                                    color: Colors.red
                                ),
                                child: Text("Cek/Giro", style: TextStyle(
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
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

}
