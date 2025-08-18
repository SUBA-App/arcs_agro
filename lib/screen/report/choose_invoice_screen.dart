import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/item/invoice_item.dart';
import 'package:sales_app/screen/report/report_provider.dart';

import '../../api/response/invoice_response.dart';
import '../../font_color.dart';

class ChooseInvoiceScreen extends StatefulWidget {
  const ChooseInvoiceScreen({
    super.key,
    required this.customerId,
    required this.customerName,
  });

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
      Provider.of<ReportProvider>(
        context,
        listen: false,
      ).getInvoices(context, 1, widget.customerId, '');
    });
    super.initState();
  }

  bool onCheck(ReportProvider provider) {
    for (var i in provider.invoices) {
      if (i.checked) {
        return true;
      }
    }
    return false;
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
            fontSize: 16,
          ),
        ),
        actions: [
          onCheck(provider)
              ? IconButton(
                icon: const Icon(
                  Icons.check_circle_sharp,
                  size: 28,
                  color: FontColor.black,
                ),
                onPressed: () {
                  List<InvoiceData> selecteds = [];
                  for (var i in Provider.of<ReportProvider>(context, listen: false).invoices) {
                    if (i.checked) {
                      selecteds.add(i);
                    }
                  }
                  Navigator.pop(context,{'selecteds': selecteds});
                },
              )
              : const SizedBox(),
        ],
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
                fontSize: 14,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: "Pencarian",
                labelStyle: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black,
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: FontColor.yellow72),
                ),
                contentPadding: const EdgeInsets.all(8),
              ),
              onSubmitted: (e) {
                if (e.isNotEmpty) {
                  currentSearch = e;
                  Provider.of<ReportProvider>(
                    context,
                    listen: false,
                  ).getInvoices(context, 1, widget.customerId, e);
                }
              },
              onChanged: (e) {
                if (e.isEmpty) {
                  currentSearch = '';
                  Provider.of<ReportProvider>(
                    context,
                    listen: false,
                  ).getInvoices(context, 1, widget.customerId, currentSearch);
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Pelanggan',
              style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: FontColor.black,
              ),
            ),
            Text(
              widget.customerName,
              style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: FontColor.black,
              ),
            ),
            const SizedBox(height: 16),
            provider.isInvoiceLoading
                ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: FontColor.black),
                  ),
                )
                : Expanded(
                  child: EnhancedPaginatedView(
                    builder: (items, physics, reverse, shrinkWrap) {
                      return ListView.builder(
                        physics: physics,
                        shrinkWrap: shrinkWrap,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InvoiceItem(
                            invoiceData: provider.invoices[index],
                            onTap: () {
                              Provider.of<ReportProvider>(
                                context,
                                listen: false,
                              ).checkInvoice(index);
                            },
                          );
                        },
                      );
                    },
                    itemsPerPage: 20,
                    onLoadMore: (e) {
                      if (e > 1) {
                        Provider.of<ReportProvider>(
                          context,
                          listen: false,
                        ).loadMoreInvoice(
                          context,
                          e,
                          widget.customerId,
                          currentSearch,
                        );
                      }
                    },
                    hasReachedMax: provider.isMaxReached1,
                    delegate: EnhancedDelegate(
                      listOfData: provider.invoices,
                      status: provider.enhancedStatus1,
                      header: Container(),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
