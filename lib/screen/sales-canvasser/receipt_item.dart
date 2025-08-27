
import 'package:flutter/material.dart';
import 'package:arcs_agro/api/response/receipts_response.dart';
import 'package:arcs_agro/screen/sales-canvasser/receipt_detail.dart';
import 'package:arcs_agro/util.dart';

import '../../font_color.dart';

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({super.key, required this.data});

  final ReceiptsData data;

  @override
  Widget build(BuildContext context) {

    int total = 0;

    for(var i in data.listProducts) {
      total += int.parse(i.productPrice) * i.productQuantity;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptDetail(data: data,)));
        },
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
            ),
            padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 8)
            )
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.no ?? '',
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(data.storeName, style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black
                    ),),
                    Text(Util.convertToIdr(total, 0), style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black
                    ),),
                    Text('${data.dateAt} ${data.timeAt}', style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black.withValues(alpha: 0.5)
                    ),),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
