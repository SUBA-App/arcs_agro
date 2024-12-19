import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/api/response/report_response.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/util.dart';
import 'package:sales_app/view_pic_screen.dart';

class LaporanKerjaDetail extends StatefulWidget {
  const LaporanKerjaDetail({super.key, required this.report});

  final ReportResult report;

  @override
  State<LaporanKerjaDetail> createState() => _LaporanKerjaDetailState();
}

class _LaporanKerjaDetailState extends State<LaporanKerjaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Detail Laporan Kerja",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              color: FontColor.black,
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.report.storeName}",
                        style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            color: FontColor.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Invoice : ${widget.report.invoice}",
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          color: FontColor.black,
                        ),
                      ),
                      Text(
                        "Tanggal : ${widget.report.created_at}",
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          color: FontColor.black,
                        ),
                      ),
                      Text(
                        "Jam : ${widget.report.time_at}",
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          color: FontColor.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Metode Pembayaran : ",
                            style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: widget.report.payment.method == 1
                                    ? Colors.green
                                    : widget.report.payment.method == 2
                                        ? Colors.black54
                                        : Colors.red),
                            child: Text(
                              widget.report.payment.method == 1
                                  ? 'Tunai'
                                  : widget.report.payment.method == 2
                                      ? 'Transfer'
                                      : "Cek/Giro",
                              style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      widget.report.payment.method == 3 ||  widget.report.payment.method == 2
                          ? Text(
                        "Bank : ${widget.report.payment.bankName}",
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          color: FontColor.black,
                        ),
                      )
                          : const SizedBox(),
                      widget.report.payment.method == 3
                          ? Text(
                              "Nomor : ${widget.report.payment.noGiro}",
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: FontColor.black,
                              ),
                            )
                          : const SizedBox(),
                      widget.report.payment.method == 3
                          ? Text(
                              "Jatuh Tempo : ${widget.report.payment.giroDate}",
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: FontColor.black,
                              ),
                            )
                          : const SizedBox(),
                      Text(
                        "Nominal : ${Util.convertToIdr(widget.report.payment.amount, 0)}",
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          color: FontColor.black,
                        ),
                      ),
                      widget.report.note.isNotEmpty ? SizedBox(height: 8,) : SizedBox(),
                      widget.report.note.isNotEmpty ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black12)
                        ),
                        child: Text(
                        widget.report.note,
                          style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            color: FontColor.black,
                          ),
                        ),
                      ): SizedBox(),
                      widget.report.note.isNotEmpty ? SizedBox(height: 8,): SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange),
                            child: Text(
                              widget.report.status == 0
                                  ? "Sedang Pengecekan"
                                  : "Laporan Diterima",
                              style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widget.report.payment.method == 1
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.report.payment.method == 2
                          ? "Bukti Transfer"
                          : "Foto Cek/Giro",
                      style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          color: FontColor.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
            widget.report.payment.method == 1
                ? const SizedBox()
                : Expanded(
                  child: ListView.builder(
                      itemCount: widget.report.payment.pictures.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewPicScreen(
                                          url: widget.report.payment
                                              .pictures[index].image,
                                        )));
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black12,
                                    )),
                                child: Center(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${ApiService.imageUrlPayment}${widget.report.payment.pictures[index].image}',
                                    height: 200,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),
                              )),
                        );
                      }),
                )
          ],
        ),
      ),
    );
  }
}
