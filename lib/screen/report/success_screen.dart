import 'package:arcs_agro/screen/print/print_preview.dart';
import 'package:flutter/material.dart';
import 'package:arcs_agro/screen/print/print_screen.dart';

import '../../api/response/receipts_response.dart';
import '../../api/response/report_response.dart';
import '../../font_color.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, this.receiptsData, this.reportData, });

  final ReceiptsData? receiptsData;
  final ReportData? reportData;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: Colors.white),

        title: Text(
          "Tambah Laporan",
          style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/accept.png', width: 120,height: 120,),
                const SizedBox(height: 16,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrintPreview(receiptsData: widget.receiptsData,reportData: widget.reportData,)));
                    },
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Colors.black),
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
          )
        ],
      )),
    );
  }
}
