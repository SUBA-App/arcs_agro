import 'package:flutter/material.dart';
import 'package:sales_app/api/response/receipts_response.dart';

import 'package:sales_app/font_color.dart';
import 'package:sales_app/screen/sales-canvasser/list_detail_product_item.dart';
import 'package:sales_app/util.dart';

import '../print/print_screen.dart';

class ReceiptDetail extends StatefulWidget {
  const ReceiptDetail({super.key, required this.data});

  final ReceiptsData data;

  @override
  State<ReceiptDetail> createState() => _ReceiptDetailState();
}

class _ReceiptDetailState extends State<ReceiptDetail> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    int total = 0;

    for(var i in widget.data.listProducts) {
      total += int.parse(i.productPrice) * i.productQuantity;
    }

    return Scaffold(
      backgroundColor: FontColor.blackF9,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Detail Tanda Terima",
          style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: FontColor.black,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.data.storeName ?? '',
                                      style: TextStyle(
                                        fontFamily: FontColor.fontPoppins,
                                        color: FontColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      widget.data.no ?? '',
                                      style: TextStyle(
                                        fontFamily: FontColor.fontPoppins,
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8,),
                            Text(
                              "List Barang",
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8,),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [

                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                    widget.data.listProducts.length,
                                    itemBuilder: (context, index) {
                                      return ListDetailProductItem(listProduct: widget.data.listProducts[index]);
                                    },
                                  ),
                                  const SizedBox(height: 8,),
                                  Text(
                                    "Total Harga Barang",
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Rp. ${Util.convertToIdr(total, 0)}',
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: FontColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              "Tanggal & Waktu",
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${widget.data.dateAt} ${widget.data.timeAt}',
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: FontColor.black,
                              ),
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {

                            final template = await Util.templateReceipt(
                              widget.data,
                            );
                            if (!context.mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        PrintScreen(template: template, count: 1,),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: const WidgetStatePropertyAll(
                              Colors.black,
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(
                            "Print Tanda Terima",
                            style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
