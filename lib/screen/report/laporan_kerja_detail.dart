import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:sales_app/api/response/report_response.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/util.dart';
import 'package:sales_app/view_pic_screen.dart';

import '../../configuration.dart';

class LaporanKerjaDetail extends StatefulWidget {
  const LaporanKerjaDetail({super.key, required this.report});

  final ReportData report;

  @override
  State<LaporanKerjaDetail> createState() => _LaporanKerjaDetailState();
}

class _LaporanKerjaDetailState extends State<LaporanKerjaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FontColor.blackF9,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
          
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.report.storeName,
                          style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                              fontWeight: FontWeight.w500),
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
                    Text(
                      "Invoice",
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      widget.report.invoice,
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      "Tanggal Pembayaran",
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: Colors.black,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      widget.report.created_at,
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    widget.report.payment.method == 3 ||  widget.report.payment.method == 2
                        ? Text(
                      "Bank Penerima",
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                      ),
                    )
                        : const SizedBox(),
                    widget.report.payment.method == 3 ||  widget.report.payment.method == 2
                        ? Text(
                      widget.report.payment.bankName,
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),
                    )
                        : const SizedBox(),
                    widget.report.payment.method == 3
                        ? Text(
                      "Nomor",
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                      ),
                    )
                        : const SizedBox(),
                    widget.report.payment.method == 3
                        ? Text(
                            widget.report.payment.noGiro,
                            style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                            ),
                          )
                        : const SizedBox(),
                    widget.report.payment.method == 3
                        ? Text(
                      "Jatuh Tempo",
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                      ),
                    )
                        : const SizedBox(),
                    widget.report.payment.method == 3
                        ? Text(
                            widget.report.payment.giroDate,
                            style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 16,),
                    Text(
                      'Rp ${Util.convertToIdr(widget.report.payment.amount, 0)}',
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    widget.report.note.isNotEmpty ? const SizedBox(height: 8,) : const SizedBox(),
                    widget.report.note.isNotEmpty ?  Text(
                      "Keterangan",
                      style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          color: Colors.red,
                          fontWeight: FontWeight.w500
                      ),
                    ) : const SizedBox(),
                    widget.report.note.isNotEmpty ? Text(
                      widget.report.note,
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),
                    ) : const SizedBox(),
                    widget.report.note.isNotEmpty ? const SizedBox(height: 8,): const SizedBox(),
                    
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
          
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: widget.report.status == 0 ? Colors.red : Colors.green
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Text(widget.report.status == 0 ? 'Pengecekan' : 'Selesai Pengecekan', style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: FontColor.black,
                                fontSize: 14
                            ),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(widget.report.checkDate.checkDate.isNotEmpty ? widget.report.checkDate.checkDate : '-', style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                              fontSize: 12
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(widget.report.checkDate.note, style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                              fontSize: 12
                          ),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    widget.report.status == 1 || widget.report.status == 2  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: widget.report.status == 2 ? Colors.green : Colors.red
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Text(widget.report.status == 2 ? 'Selesai Penginputan' : 'Penginputan', style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: FontColor.black,
                                fontSize: 14
                            ),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(widget.report.inputDate.inputDate.isNotEmpty ? widget.report.inputDate.inputDate : '-', style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                              fontSize: 12
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(widget.report.inputDate.note, style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                              fontSize: 12
                          ),),
                        ),
                      ],
                    ) :const SizedBox()
          
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
          
                    borderRadius: BorderRadius.circular(15)
                ),
                child: widget.report.payment.pictures.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        itemCount: widget.report.payment.pictures.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPicScreen(
                                        url: '${Configuration.imageUrl}${widget.report.payment
                                            .pictures[index]}' ,
                                      )));
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.all(8),
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
                                          '${Configuration.imageUrlPayment}${widget.report.payment.pictures[index]}',
                                          placeholder: (_,__) => Image.asset('assets/images/placeholder.jpg',fit: BoxFit.fill,),
                                          errorWidget: (_,__,___) => Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fill,),
                                          height: 200,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )),
                                )),
                          );
                        }),
              ),
          
          
            ],
          ),
        ),
      ),
    );
  }
}
