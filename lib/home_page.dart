import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/absensi/absensi_item.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/main/main_page.dart';
import 'package:sales_app/screen/main/main_provider.dart';
import 'package:sales_app/screen/product/product_screen.dart';
import 'package:sales_app/shimmer_n.dart';
import 'package:sales_app/util/preferences.dart';

import 'screen/absensi/absensi_screen.dart';
import 'screen/absensi/detail_absensi_screen.dart';
import 'font_color.dart';
import 'screen/report/laporan_kerja_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                          child: Image.asset('assets/images/businessman.png', width: 80,height: 80,),
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${Preferences.getUser()?.name}", style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: FontColor.black
                          ),),
                          Text("Sales - ${Preferences.getUser()?.companyName}", style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: FontColor.black.withOpacity(0.5)
                          ),),
                          const SizedBox(height: 8,),
                          provider.isLoading ? ShimmerN(enabled: provider.isLoading) :
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: provider.result == null ? Colors.green : provider.result!.status == 1 ?  Colors.green : Colors.black54
                            ),
                            child: Text(provider.result == null ? '' : provider.result!.status == 1? "Sedang Check In" : 'Ready', style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              provider.isLoading || provider.result?.status == 0 ? const SizedBox() :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text('Aktif Absensi',textAlign: TextAlign.center, style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: FontColor.black
                        ),),
                      ),
                      const SizedBox(width: 8,),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green
                        ),
                      )
                    ],
                  ),
          
                  AbsensiItem(result: provider.result?.absen)
                ],
              ),
          
              const SizedBox(height: 50,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AbsensiScreen(drawer: false,)));
                        },
                        child: Container(
                          width: 130,
                          height: 130,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: FontColor.yellow72,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/ballot-check.png', width: 30, height: 30,),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductScreen(drawer: false,)));
                        },
                        child: Container(
                          width: 130,
                          height: 130,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: FontColor.yellow72,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/box-open.png', width: 30, height: 30,),
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
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LaporanKerjaScreen(drawer: false,)));
                        },
                        child: Container(
                          width: 130,
                          height: 130,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: FontColor.yellow72,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/checklist-task-budget.png', width: 30, height: 30,),
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
      ),
    );
  }
}
