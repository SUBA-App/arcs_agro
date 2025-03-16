
import 'package:flutter/material.dart';
import 'package:sales_app/api/response/report_response.dart';
import 'package:sales_app/util.dart';

import '../../font_color.dart';
import 'laporan_kerja_detail.dart';

class ReportItem extends StatelessWidget {
  const ReportItem({super.key, required this.report});

  final ReportData report;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LaporanKerjaDetail(report: report,)));
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
                    Text(report.storeName, style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black
                    ),),
                    Text(Util.convertToIdr(report.payment.amount, 0), style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black
                    ),),
                    Text(report.createdAt, style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black.withValues(alpha: 0.5)
                    ),),
                  ],
                ),
              ),
              const SizedBox(width: 8,),
              Container(
                alignment: Alignment.center,
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: report.payment.method == 1 ? Colors.green : report.payment.method == 2 ? Colors.black54 : Colors.red
                ),
                child: Text(report.payment.method == 1 ? 'Tunai' : report.payment.method == 2 ? 'Transfer' : "Cek/Giro", style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
