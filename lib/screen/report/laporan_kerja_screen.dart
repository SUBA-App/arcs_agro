
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/add_laporan_screen.dart';
import 'package:sales_app/screen/report/report_item.dart';
import 'package:sales_app/screen/report/report_provider.dart';


import '../../font_color.dart';
import '../dialog/filter_dialog.dart';

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
      Provider.of<ReportProvider>(context, listen: false).clear();
      Provider.of<ReportProvider>(context, listen: false).getReports(context, 1);
    });
    super.initState();
  }

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
        (Provider.of<ReportProvider>(context, listen: false).start.isEmpty ? null : DateTime.tryParse(Provider.of<ReportProvider>(context, listen: false).start))
            :(Provider.of<ReportProvider>(context, listen: false).end.isEmpty ? null : DateTime.tryParse(Provider.of<ReportProvider>(context, listen: false).end)),
        locale: const Locale("id"),
        firstDate: DateTime(2000,1),
        lastDate: DateTime(2100, 1));
    if (picked != null) {
      setState(() {
        final format = DateFormat('yyyy-MM-dd').format(picked);
        if (mode == 1) {
          Provider.of<ReportProvider>(context, listen: false).setStart(format);
        } else {
          Provider.of<ReportProvider>(context, listen: false).setEnd(format);
        }
      });
    }
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
          Provider.of<ReportProvider>(context, listen: false).getReports(context, 1);
        }
      },backgroundColor: FontColor.yellow72, child: const Icon(Icons.add, color: FontColor.black,),),
      body: SafeArea(
        child: Column(
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
                        Provider.of<ReportProvider>(context, listen: false).clear();
                        Provider.of<ReportProvider>(context, listen: false).setSearch(e);
                        Provider.of<ReportProvider>(context, listen: false).getReports(context,1);

                      },
                      onChanged: (e) {
                        if (e.isEmpty) {
                          Provider.of<ReportProvider>(context, listen: false).clear();
                          Provider.of<ReportProvider>(context, listen: false).setSearch(e);
                          Provider.of<ReportProvider>(context, listen: false).getReports(context,1);

                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16,),
                  IconButton(
                    icon: Image.asset('assets/images/filter-list.png', width: 20,height: 20,),
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(10)
                        ))
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,isDismissible: false, builder: (context) {
                        final provider1 = Provider.of<ReportProvider>(context);
                        return FilterDialog(applyTap: () {
                          Navigator.pop(context);
                          Provider.of<ReportProvider>(context, listen: false).getReports(context,1);
                        }, start: provider1.start, end: provider1.end, startTap: () {
                          startDate(context, 1);
                        }, endTap: () {startDate(context, 2);  }, sort: provider1.sort, sortChange: (String e) {
                          Provider.of<ReportProvider>(context, listen: false).setSort(e);
                        }, clear: () { Provider.of<ReportProvider>(context, listen: false).clear(); },);
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
                      return ReportItem(report: provider.reports[index]);
                    },
                  );
                },
                itemsPerPage: 20,
                onLoadMore: (e) {
                  if(e > 1) {
                    Provider.of<ReportProvider>(context, listen: false)
                        .loadMoreReports(
                        context, e);
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
