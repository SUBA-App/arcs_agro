import 'package:cached_network_image/cached_network_image.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sales_app/api/response/report_response.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/screen/report/report_provider.dart';
import 'package:sales_app/util.dart';
import 'package:sales_app/view_pic_screen.dart';

import '../print/print_screen.dart';

class LaporanKerjaDetail extends StatefulWidget {
  const LaporanKerjaDetail({super.key, required this.report});

  final ReportData report;

  @override
  State<LaporanKerjaDetail> createState() => _LaporanKerjaDetailState();
}

class _LaporanKerjaDetailState extends State<LaporanKerjaDetail> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(
        context,
        listen: false,
      ).reportDetail(context, widget.report.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportProvider>(context);
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
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            provider.isLoadingDetail
                ? Center(
                  child: CircularProgressIndicator(color: FontColor.black),
                )
                : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
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
                                            provider.reportData?.storeName ?? '',
                                            style: TextStyle(
                                              fontFamily: FontColor.fontPoppins,
                                              color: FontColor.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            provider.reportData?.no ?? '',
                                            style: TextStyle(
                                              fontFamily: FontColor.fontPoppins,
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color:
                                              provider.reportData?.payment.method == 1
                                                  ? Colors.green
                                                  : provider
                                                          .reportData
                                                          ?.payment
                                                          .method ==
                                                      2
                                                  ? Colors.black54
                                                  : Colors.red,
                                        ),
                                        child: Text(
                                          provider.reportData?.payment.method == 1
                                              ? 'Tunai'
                                              : provider.reportData?.payment.method ==
                                                  2
                                              ? 'Transfer'
                                              : "Cek/Giro",
                                          style: TextStyle(
                                            fontFamily: FontColor.fontPoppins,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16,),
                                  Text(
                                    "Invoice",
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  provider.reportData?.invoice.isNotEmpty ?? false
                                      ? Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: FontColor.blackF9,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              provider.reportData?.invoice ?? '',
                                              style: TextStyle(
                                                fontFamily: FontColor.fontPoppins,
                                                color: FontColor.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            provider.reportData?.invoices.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(4),
                                            margin: EdgeInsets.symmetric(vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.black12,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  provider
                                                          .reportData
                                                          ?.invoices[index]
                                                          .number ??
                                                      '',
                                                  style: TextStyle(
                                                    fontFamily: FontColor.fontPoppins,
                                                    color: FontColor.black,
                                                  ),
                                                ),
                                                Text(
                                                  'Total',
                                                  style: TextStyle(
                                                    fontFamily: FontColor.fontPoppins,
                                                    color: Colors.black45,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  'Rp ${Util.convertToIdr(provider.reportData?.invoices[index].totalAmount, 0)}',
                                                  style: TextStyle(
                                                    fontFamily: FontColor.fontPoppins,
                                                    color: FontColor.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  'Piutang',
                                                  style: TextStyle(
                                                    fontFamily: FontColor.fontPoppins,
                                                    color: Colors.black45,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  'Rp ${Util.convertToIdr(provider.reportData?.invoices[index].piutang, 0)}',
                                                  style: TextStyle(
                                                    fontFamily: FontColor.fontPoppins,
                                                    color: FontColor.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tanggal Pembayaran",
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    provider.reportData?.createdAt ?? '',
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: FontColor.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  provider.reportData?.payment.method == 3 ||
                                          provider.reportData?.payment.method == 2
                                      ? Text(
                                        "Bank Penerima",
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                      : const SizedBox(),
                                  provider.reportData?.payment.method == 3 ||
                                          provider.reportData?.payment.method == 2
                                      ? Text(
                                        provider.reportData?.payment.bankName ?? '',
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          color: FontColor.black,
                                        ),
                                      )
                                      : const SizedBox(),
                                  provider.reportData?.payment.method == 3
                                      ? Text(
                                        "Nomor",
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                      : const SizedBox(),
                                  provider.reportData?.payment.method == 3
                                      ? Text(
                                        provider.reportData?.payment.noGiro ?? '',
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          color: FontColor.black,
                                        ),
                                      )
                                      : const SizedBox(),
                                  provider.reportData?.payment.method == 3
                                      ? Text(
                                        "Jatuh Tempo",
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                      : const SizedBox(),
                                  provider.reportData?.payment.method == 3
                                      ? Text(
                                        provider.reportData?.payment.giroDate ?? '',
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          color: FontColor.black,
                                        ),
                                      )
                                      : const SizedBox(),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Rp ${Util.convertToIdr(provider.reportData?.payment.amount, 0)}',
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: FontColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  provider.reportData?.note.isNotEmpty ?? false
                                      ? const SizedBox(height: 8)
                                      : const SizedBox(),
                                  provider.reportData?.note.isNotEmpty ?? false
                                      ? Text(
                                        "Keterangan",
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                      : const SizedBox(),
                                  provider.reportData?.note.isNotEmpty ?? false
                                      ? Text(
                                        provider.reportData?.note ?? '',
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          color: FontColor.black,
                                        ),
                                      )
                                      : const SizedBox(),
                                  provider.reportData?.note.isNotEmpty ?? false
                                      ? const SizedBox(height: 8)
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                              color:
                                                  provider.reportData?.status == 3
                                                      ? Colors.red
                                                      : provider.reportData?.status ==
                                                          0
                                                      ? Colors.orange
                                                      : Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            provider.reportData?.status == 3
                                                ? 'Dibatalkan'
                                                : provider.reportData?.status == 0
                                                ? 'Pengecekan'
                                                : 'Selesai Pengecekan',
                                            style: TextStyle(
                                              fontFamily: FontColor.fontPoppins,
                                              color: FontColor.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: Text(
                                          provider
                                                      .reportData
                                                      ?.checkDate
                                                      .checkDate
                                                      .isNotEmpty ??
                                                  false
                                              ? provider
                                                      .reportData
                                                      ?.checkDate
                                                      .checkDate ??
                                                  ''
                                              : '-',
                                          style: TextStyle(
                                            fontFamily: FontColor.fontPoppins,
                                            color: FontColor.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: Text(
                                          provider.reportData?.checkDate.note ?? '',
                                          style: TextStyle(
                                            fontFamily: FontColor.fontPoppins,
                                            color: FontColor.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  provider.reportData?.status == 1 ||
                                          provider.reportData?.status == 2
                                      ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(
                                                    15,
                                                  ),
                                                  color:
                                                      provider.reportData?.status == 2
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                provider.reportData?.status == 2
                                                    ? 'Selesai Penginputan'
                                                    : 'Penginputan',
                                                style: TextStyle(
                                                  fontFamily: FontColor.fontPoppins,
                                                  color: FontColor.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16),
                                            child: Text(
                                              provider
                                                          .reportData
                                                          ?.inputDate
                                                          .inputDate
                                                          .isNotEmpty ??
                                                      false
                                                  ? provider
                                                          .reportData
                                                          ?.inputDate
                                                          .inputDate ??
                                                      ''
                                                  : '-',
                                              style: TextStyle(
                                                fontFamily: FontColor.fontPoppins,
                                                color: FontColor.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16),
                                            child: Text(
                                              provider.reportData?.inputDate.note ??
                                                  '',
                                              style: TextStyle(
                                                fontFamily: FontColor.fontPoppins,
                                                color: FontColor.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(15),
                              ),
                              child:
                                  provider.reportData?.payment.pictures.isEmpty ??
                                          false
                                      ? const SizedBox()
                                      : ListView.builder(
                                        itemCount:
                                            provider
                                                .reportData
                                                ?.payment
                                                .pictures
                                                .length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => ViewPicScreen(
                                                        url:
                                                            provider
                                                                .reportData
                                                                ?.payment
                                                                .pictures[index] ??
                                                            '',
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 200,
                                                margin: const EdgeInsets.only(top: 8),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(
                                                    10,
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          provider
                                                              .reportData
                                                              ?.payment
                                                              .pictures[index] ??
                                                          '',
                                                      placeholder:
                                                          (_, __) => Image.asset(
                                                            'assets/images/placeholder.jpg',
                                                            fit: BoxFit.fill,
                                                          ),
                                                      errorWidget:
                                                          (_, __, ___) => Image.asset(
                                                            'assets/images/placeholder.jpg',
                                                            fit: BoxFit.fill,
                                                          ),
                                                      height: 200,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                            ),
                            const SizedBox(height: 8),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (Provider.of<ReportProvider>(
                            context,
                            listen: false,
                          ).reportData ==
                              null) {
                            return;
                          }
                          final template = await Util.templatePrintReport(
                            Provider.of<ReportProvider>(
                              context,
                              listen: false,
                            ).reportData!,
                            PaperSize.mm80,
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
    );
  }
}
