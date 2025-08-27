import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:arcs_agro/api/api_service.dart';
import 'package:arcs_agro/api/response/default_response.dart';
import 'package:arcs_agro/local_db.dart';
import 'package:arcs_agro/screen/absensi/absensi_item.dart';
import 'package:arcs_agro/screen/item/home_menu.dart';

import 'package:arcs_agro/screen/main/main_provider.dart';
import 'package:arcs_agro/screen/product/product_screen.dart';
import 'package:arcs_agro/screen/sales-canvasser/receipts_screen.dart';
import 'package:arcs_agro/shimmer_n.dart';
import 'package:arcs_agro/util/preferences.dart';

import 'screen/absensi/absensi_screen.dart';

import 'font_color.dart';
import 'screen/report/laporan_kerja_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<InternetConnectionStatus> subscription;

  late AppDatabase? _database;

  @override
  void initState() {
    final connectionChecker = InternetConnectionChecker.instance;

    $FloorAppDatabase.databaseBuilder('app_database.db').build().then((e) {
      _database = e;
      connectionChecker.hasConnection.then((e) {
        if (e) {
          if (_database != null) {
            _database?.locationDao.getCacheLocation().then((e) {
              if (e.isNotEmpty) {
                ApiService.updateCacheCoordinate(e).then((i) {
                  if (i.runtimeType == DefaultResponse) {
                    _database?.locationDao.clearCache();
                  }
                });
              }
            });
          }
        }
      });
    });

    subscription = connectionChecker.onStatusChange.listen((
      InternetConnectionStatus status,
    ) {
      if (status == InternetConnectionStatus.connected) {
        if (_database != null) {
          _database?.locationDao.getCacheLocation().then((e) {
            if (e.isNotEmpty) {
              ApiService.updateCacheCoordinate(e).then((i) {
                if (i.runtimeType == DefaultResponse) {
                  _database?.locationDao.clearCache();
                }
              });
            }
          });
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((e) {
      Provider.of<MainProvider>(context, listen: false).checkStatus(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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
                          child: Image.asset(
                            'assets/images/businessman.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${Preferences.getUser()?.name}",
                            style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: FontColor.black,
                            ),
                          ),
                          Text(
                            "${Preferences.getUser()?.role} - ${Preferences.getUser()?.companyName}",
                            style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: FontColor.black.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          provider.isLoading
                              ? ShimmerN(enabled: provider.isLoading)
                              : Container(
                                alignment: Alignment.center,
                                height: 30,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      provider.result == null
                                          ? Colors.green
                                          : provider.result!.status == 1
                                          ? Colors.green
                                          : Colors.black54,
                                ),
                                child: Text(
                                  provider.result == null
                                      ? ''
                                      : provider.result!.status == 1
                                      ? "Sedang Check In"
                                      : 'Ready',
                                  style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              provider.isLoading || provider.result?.status == 0
                  ? const SizedBox()
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'Aktif Absensi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: FontColor.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                      AbsensiItem(result: provider.result?.absen),
                    ],
                  ),

              const SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeMenu(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const AbsensiScreen(drawer: false),
                            ),
                          );
                        },
                        text: "Absensi",
                        isActive: provider.isAbsenteeism == 2 || provider.isAbsenteeism == 1,
                        image: 'assets/images/ballot-check.svg',
                      ),
                      HomeMenu(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const ProductScreen(drawer: false),
                            ),
                          );
                        },
                        text: "List Produk",
                        isActive: provider.isProduct == 2 || provider.isProduct == 1,
                        image: 'assets/images/box-open.svg',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeMenu(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const LaporanKerjaScreen(drawer: false),
                            ),
                          );
                        },
                        text: "Laporan Kerja",
                        isActive: provider.isReport == 2 || provider.isReport == 1,
                        image: 'assets/images/checklist-task-budget.svg',
                      ),
                      HomeMenu(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                              const ReceiptsScreen(drawer: false),
                            ),
                          );
                        },
                        text: "Sales Canvasser",
                        isActive: provider.isReport == 2 || provider.isReport == 1,
                        image: 'assets/images/calendar-lines-pen.svg',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
