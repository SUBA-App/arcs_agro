import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/add_laporan_screen.dart';
import 'package:sales_app/screen/report/laporan_kerja_detail.dart';
import 'package:sales_app/screen/report/report_item.dart';
import 'package:sales_app/screen/report/report_provider.dart';
import 'package:sales_app/util.dart';

import '../../font_color.dart';

class LaporanKerjaScreen extends StatefulWidget {
  const LaporanKerjaScreen({super.key, required this.drawer});

  final bool drawer;

  @override
  State<LaporanKerjaScreen> createState() => _LaporanKerjaScreenState();
}

class _LaporanKerjaScreenState extends State<LaporanKerjaScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).getReports();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportProvider>(context);
    return Scaffold(
      appBar: widget.drawer ? null :  AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(
          color: FontColor.black
        ),
        title: Text("Laporan Kerja",style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: FontColor.black,
          fontSize: 16
        ),),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(onPressed: () async {

        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddLaporanScreen()));
        if (result != null) {
          Provider.of<ReportProvider>(context, listen: false).getReports();
        }
      }, child: const Icon(Icons.add),backgroundColor: FontColor.yellow72,),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  contentPadding: EdgeInsets.all(8)
                ),
                onChanged: (e) {
                  Provider.of<ReportProvider>(context, listen: false).filter(e);
                },
              ),
            ),
            provider.isLoading ? const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.black,),)): provider.reports.isEmpty ? Expanded(child: Center(child: Image.asset('assets/images/empty.png', width: 170,height: 170,),)) :
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                    itemCount: provider.reports.length,
                    itemBuilder: (context, index) {
                  return ReportItem(report: provider.reports[index]);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

}
