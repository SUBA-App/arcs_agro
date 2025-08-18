
import 'dart:async';

import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/report_provider.dart';
import 'package:sales_app/screen/sales-canvasser/add_receipt_screen.dart';
import 'package:sales_app/screen/sales-canvasser/receipt_item.dart';
import 'package:sales_app/screen/sales-canvasser/receipts_provider.dart';


import '../../font_color.dart';
import '../../refresh_controller.dart';
import '../dialog/filter_dialog.dart';
import '../main/main_provider.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key, required this.drawer});

  final bool drawer;

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {

  late final StreamSubscription _subscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MainProvider>(context, listen: false).checkStatus(context);
      Provider.of<ReceiptsProvider>(context, listen: false).clear();
      Provider.of<ReceiptsProvider>(context, listen: false).getReceipts(context, 1);
    });
    _subscription = RefreshController.stream.listen((_) {
      Provider.of<ReceiptsProvider>(context, listen: false).getReceipts(context, 1);
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
        (Provider.of<ReceiptsProvider>(context, listen: false).start.isEmpty ? null : DateTime.tryParse(Provider.of<ReceiptsProvider>(context, listen: false).start))
            :(Provider.of<ReceiptsProvider>(context, listen: false).end.isEmpty ? null : DateTime.tryParse(Provider.of<ReceiptsProvider>(context, listen: false).end)),
        locale: const Locale("id"),
        firstDate: DateTime(2000,1),
        lastDate: DateTime(2100, 1));
    if (picked != null) {
      setState(() {
        final format = DateFormat('yyyy-MM-dd').format(picked);
        if (mode == 1) {
          Provider.of<ReceiptsProvider>(context, listen: false).setStart(format);
        } else {
          Provider.of<ReceiptsProvider>(context, listen: false).setEnd(format);
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReceiptsProvider>(context);
    final mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: widget.drawer ? null :  AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(
          color: FontColor.black
        ),
        title: Text("Tanda Terima",style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: FontColor.black,
          fontSize: 16
        ),),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: mainProvider.isReport == 2 ? FloatingActionButton(onPressed: () async {

        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddReceiptScreen()));

      },backgroundColor: FontColor.yellow72, child: const Icon(Icons.add, color: FontColor.black,),) : null,
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
                        Provider.of<ReceiptsProvider>(context, listen: false).clear();
                        Provider.of<ReceiptsProvider>(context, listen: false).setSearch(e);
                        Provider.of<ReceiptsProvider>(context, listen: false).getReceipts(context,1);

                      },
                      onChanged: (e) {
                        if (e.isEmpty) {
                          Provider.of<ReceiptsProvider>(context, listen: false).clear();
                          Provider.of<ReceiptsProvider>(context, listen: false).setSearch(e);
                          Provider.of<ReceiptsProvider>(context, listen: false).getReceipts(context,1);

                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16,),
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
                      return ReceiptItem(data: provider.receipts[index]);
                    },
                  );
                },
                itemsPerPage: 20,
                onLoadMore: (e) {
                  if(e > 1) {
                    Provider.of<ReceiptsProvider>(context, listen: false)
                        .loadMoreReceipts(
                        context, e);
                  }
                },
                hasReachedMax: provider.isMaxReached,
                delegate: EnhancedDelegate(
                  listOfData: provider.receipts,
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
