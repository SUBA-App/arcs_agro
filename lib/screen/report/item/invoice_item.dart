import 'package:flutter/material.dart';
import 'package:sales_app/api/response/invoice_response.dart';

import '../../../font_color.dart';
import '../../../util.dart';

class InvoiceItem extends StatelessWidget {
  const InvoiceItem({super.key, required this.invoiceData, required this.onTap});

  final InvoiceData invoiceData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 0.1,
              spreadRadius: 0.1,
              color: Color(0xffeaeaea),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(color: const Color(0xffeaeaea)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nomor #',
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: FontColor.black,
                        ),
                      ),
                      Text(
                        invoiceData.number,
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: FontColor.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  invoiceData.taxDateView,
                  style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: FontColor.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    Util.convertToIdr(invoiceData.piutang, 0),
                    style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: FontColor.black,
                    ),
                  ),
                ),
                invoiceData.checked ?
                const Icon(Icons.check, color: Colors.green,) : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
