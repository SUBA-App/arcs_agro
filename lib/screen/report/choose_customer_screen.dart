import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/report_provider.dart';

import '../../font_color.dart';

class ChooseCustomerScreen extends StatefulWidget {
  const ChooseCustomerScreen({super.key});

  @override
  State<ChooseCustomerScreen> createState() => _ChooseCustomerScreenState();
}

class _ChooseCustomerScreenState extends State<ChooseCustomerScreen> {

  String currentSearch = '';



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).getCustomers(context, 1, '');
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
            TextField(
              cursorColor: FontColor.black,
              textInputAction: TextInputAction.search,
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
              onSubmitted: (e) {
                if (e.isNotEmpty) {
                  currentSearch = e;
                  Provider.of<ReportProvider>(context, listen: false).getCustomers(context, 1, e);
                }
              },
              onChanged: (e) {
                if (e.isEmpty) {
                  currentSearch = '';
                  Provider.of<ReportProvider>(context, listen: false).getCustomers(context, 1, currentSearch);
                }
              },
            ),
            const SizedBox(height: 16,),
            provider.isCustLoading
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context, {
                                      'name': provider.customers[index].name,
                                      'id': provider.customers[index].id
                                    });
                                  },
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 0.1,
                                              spreadRadius: 0.1,
                                              color: Color(0xffeaeaea))
                                        ],
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffeaeaea))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nama Pelanggan*',
                                          style: TextStyle(
                                              fontFamily: FontColor.fontPoppins,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: FontColor.black),
                                        ),
                                        Text(
                                          provider.customers[index].name,
                                          style: TextStyle(
                                              fontFamily: FontColor.fontPoppins,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: FontColor.black),
                                        ),
                                        Text(
                                          'Penjual : ${provider.customers[index].salesman}',
                                          style: TextStyle(
                                              fontFamily:
                                              FontColor.fontPoppins,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          },
                        );
                      },
                      itemsPerPage: 20,
                      onLoadMore: (e) {
                        if(e > 1) {
                          Provider.of<ReportProvider>(context, listen: false)
                              .loadMoreCust(context, e, currentSearch);
                        }
                      },
                      hasReachedMax: provider.isMaxReached,
                      delegate: EnhancedDelegate(
                        listOfData: provider.customers,
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
