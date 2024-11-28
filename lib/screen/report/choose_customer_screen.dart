import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/report_provider.dart';

import '../../font_color.dart';

class ChooseCustomerScreen extends StatefulWidget {
  const ChooseCustomerScreen({super.key});

  @override
  State<ChooseCustomerScreen> createState() => _ChooseCustomerScreenState();
}

class _ChooseCustomerScreenState extends State<ChooseCustomerScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).getCustomers(1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Pilih Kios",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              color: FontColor.black,
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: EnhancedPaginatedView(
                builder: (items,physics,reverse, shrinkWrap) {
                  return ListView.builder(
                    physics: physics,
                    shrinkWrap: shrinkWrap,
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, {'name': items[index].name, 'id': items[index].id});
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(items[index].name, style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                            ),),
                          ),
                        ),
                      );
                    },
                  );
                },itemsPerPage: 20, onLoadMore: (e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).loadMoreCust(e);
    });
              }, hasReachedMax: provider.isMaxReached, delegate: EnhancedDelegate(
                listOfData: provider.customers,
                status: provider.enhancedStatus,
                header:Container(),
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
