import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/report_provider.dart';
import 'package:sales_app/util.dart';

import '../../font_color.dart';

class ChooseInvoiceScreen extends StatefulWidget {
  const ChooseInvoiceScreen(
      {super.key, required this.customerId, required this.customerName});

  final String customerId;
  final String customerName;

  @override
  State<ChooseInvoiceScreen> createState() => _ChooseCustomerScreenState();
}

class _ChooseCustomerScreenState extends State<ChooseInvoiceScreen> {
  String currentSearch = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false)
          .getInvoices(context, 1, widget.customerId, '');
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
          "Pilih Invoice",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              color: FontColor.black,
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor: FontColor.black,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black,
                  fontSize: 14),
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: "Pencarian",
                  labelStyle: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black,
                      fontSize: 14),
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
                      )),
                  contentPadding: const EdgeInsets.all(8)),
              onSubmitted: (e) {
                if (e.isNotEmpty) {
                  currentSearch = e;
                  Provider.of<ReportProvider>(context, listen: false)
                      .getInvoices(context, 1, widget.customerId, e);
                }
              },
              onChanged: (e) {
                if (e.isEmpty) {
                  currentSearch = '';
                  Provider.of<ReportProvider>(context, listen: false)
                      .getInvoices(
                          context, 1, widget.customerId, currentSearch);
                }
              },
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Pelanggan',
              style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: FontColor.black),
            ),
            Text(
              widget.customerName,
              style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black),
            ),
            SizedBox(
              height: 16,
            ),
            provider.isInvoiceLoading
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
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context, {
                                  'id': provider.invoices[index].id,
                                  'number': provider.invoices[index].number,
                                  'nominal': provider.invoices[index].totalAmount
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(16),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Nomor #',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontColor.fontPoppins,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: FontColor.black),
                                              ),
                                              Text(
                                                provider.invoices[index].number,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontColor.fontPoppins,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: FontColor.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          provider.invoices[index].taxDateView,
                                          style: TextStyle(
                                              fontFamily: FontColor.fontPoppins,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: FontColor.black),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      Util.convertToIdr(
                                          provider.invoices[index].totalAmount,
                                          0),
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: FontColor.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      itemsPerPage: 20,
                      onLoadMore: (e) {
                        if(e > 1) {
                          Provider.of<ReportProvider>(context, listen: false)
                              .loadMoreInvoice(
                              context, e, widget.customerId, currentSearch);
                        }
                      },
                      hasReachedMax: provider.isMaxReached1,
                      delegate: EnhancedDelegate(
                        listOfData: provider.invoices,
                        status: provider.enhancedStatus1,
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
