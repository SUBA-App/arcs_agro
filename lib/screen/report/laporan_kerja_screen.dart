
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/add_laporan_screen.dart';
import 'package:sales_app/screen/report/report_item.dart';
import 'package:sales_app/screen/report/report_provider.dart';


import '../../font_color.dart';

class LaporanKerjaScreen extends StatefulWidget {
  const LaporanKerjaScreen({super.key, required this.drawer});

  final bool drawer;

  @override
  State<LaporanKerjaScreen> createState() => _LaporanKerjaScreenState();
}

class _LaporanKerjaScreenState extends State<LaporanKerjaScreen> {

  String search = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).getReports(context, 1, '');
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
          Provider.of<ReportProvider>(context, listen: false).getReports(context, 1, '');
        }
      },backgroundColor: FontColor.yellow72, child: const Icon(Icons.add),),
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
                  contentPadding: const EdgeInsets.all(8)
                ),
                onChanged: (e) {
                  search = e;
                  Provider.of<ReportProvider>(context, listen: false).getReports(context,1,e);
                },
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
                      return ReportItem(report: provider.reports[index]);
                    },
                  );
                },
                itemsPerPage: 20,
                onLoadMore: (e) {
                  if(e > 1) {
                    Provider.of<ReportProvider>(context, listen: false)
                        .loadMoreReports(
                        context, e, search);
                  }
                },
                hasReachedMax: provider.isMaxReached,
                delegate: EnhancedDelegate(
                  listOfData: provider.reports,
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
