import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:arcs_agro/api/response/receipts_response.dart';
import 'package:arcs_agro/api/response/report_response.dart';
import 'package:arcs_agro/font_color.dart';
import 'package:watermark_unique/image_format.dart' as format;
import 'package:watermark_unique/watermark_unique.dart';

extension DateTimeFromTimeOfDay on DateTime {
  DateTime appliedFromTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
  }

  String format(String format) {
    return DateFormat(format).format(this);
  }
}

class Util {
  static Future<List<int>> templateReceipt(ReceiptsData data, PaperSize paperSize, String text) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);

    List<int> bytes = [];

    // Header
    bytes += generator.text(
      data.user.companyLetter,
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
      'Distributor Pestisida & Alat Pertanian',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      data.user.companyTelephone,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.hr();

    // Info transaksi
    bytes += generator.row([
      PosColumn(text: data.no ?? "", width: 6),
      PosColumn(text: 'Salesman:  ${data.user.name}', width: 6),
    ]);
    bytes += generator.text(data.dateAt, styles: const PosStyles());
    bytes += generator.text(data.timeAt, styles: const PosStyles());
    bytes += generator.text('Nama Kios :  ${data.storeName}');
    bytes += generator.hr();


    bytes += generator.emptyLines(1);

    int total = 0;
    // Detail produk
    for(var i in data.listProducts) {
      bytes += generator.text(i.productName, styles: const PosStyles(bold: true));
      bytes += generator.row([
        PosColumn(text: '${i.productQuantity} x Rp. ${Util.convertToIdr(int.parse(i.productPrice), 0)}', width: 6),
        PosColumn(text: 'Rp. ${Util.convertToIdr(int.parse(i.productPrice) * i.productQuantity, 0)}', width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
      total += int.parse(i.productPrice) * i.productQuantity;
    }

    bytes += generator.emptyLines(1);

    // Total
    bytes += generator.row([
      PosColumn(text: 'TOTAL', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
        text: 'Rp. ${Util.convertToIdr(total, 0)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.hr();

    bytes += generator.emptyLines(5);

    bytes += generator.row([
      PosColumn(
        text: '----------',
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '----------',
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Nama & Stempel Kios',
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: 'Salesman',
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
    ]);
    bytes += generator.emptyLines(3);

    bytes += generator.text(
      'BUKTI INI HANYA TANDA TERIMA,\nBUKAN INVOICE!',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.emptyLines(1);

    bytes += generator.text('Kode Unik', styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text(
      data.uniqueCode ?? '',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.emptyLines(3);

    bytes += generator.text(
      text,
      styles: const PosStyles(
        align: PosAlign.right,
        bold: false,
      ),
    );

    bytes += generator.emptyLines(3);

    return bytes;
  }
  static Future<List<int>> templatePrintReport(ReportData data, PaperSize paperSize, String text) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);

    List<int> bytes = [];

    bytes += generator.text(data.salesCompanyLetter,
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.text('Distributor Pestisida & Alat Pertanian',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(data.salesCompanyTelephone, styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: 'No', width: 3),
      PosColumn(text: ': ${data.no}', width: 9),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Salesman', width: 3),
      PosColumn(text: ': ${data.salesName}', width: 9),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Nama Kios', width: 3),
      PosColumn(text: ': ${data.storeName}', width: 9),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Tgl & Jam', width: 3),
      PosColumn(text: ': ${data.createdAt}', width: 9),
    ]);
    bytes += generator.emptyLines(1);

    bytes += generator.row([
      PosColumn(text: 'Nominal Pembayaran', width: 6),
      PosColumn(text: ': Rp. ${convertToIdr(data.payment.amount, 0)}', width: 6),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Metode Pembayaran', width: 6),
      PosColumn(text: ': ${data.payment.method == 1 ? 'TUNAI' :data.payment.method == 2 ? 'TRANSFER' : 'CEK/GIRO'}', width: 6),
    ]);
    data.payment.method == 2 || data.payment.method == 3 ?
    bytes += generator.row([
      PosColumn(text: 'Bank', width: 6),
      PosColumn(text: ': ${data.payment.bankName}', width: 6),
    ]) : '';
    data.payment.method == 3 ?
    bytes += generator.row([
      PosColumn(text: 'Nomor Giro', width: 6),
      PosColumn(text: ': ${data.payment.noGiro}', width: 6),
    ]) : '';
    bytes += generator.row([
      PosColumn(text: 'Keterangan', width: 6),
      PosColumn(text: ': ${data.note.isEmpty ? '-' : data.note}', width: 6),
    ]);
    bytes += generator.emptyLines(1);
    bytes += generator.hr();
    if (data.invoice.isEmpty) {
      // Header tabel
      bytes += generator.text('No Inv       Tanggal       Jumlah');

      for (var i in data.invoices) {
        final no = i.number.padRight(12); // sesuaikan lebar kolom
        final date = i.taxDateView.padRight(12);
        final amount = 'Rp. ${convertToIdr(i.totalAmount, 0)}'.padLeft(12);

        bytes += generator.text('$no$date$amount');
      }
    } else {
      bytes += generator.text(data.invoice);
    }

    bytes += generator.hr();

    bytes += generator.emptyLines(5);
    bytes += generator.row([
      PosColumn(
        text: '--------------------', // garis kios
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: '--------------------', // garis salesman
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Nama & Stempel Kios',
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: 'Salesman',
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
    ]);
    bytes += generator.emptyLines(3);

    bytes += generator.text('Kode Unik', styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text(
      '${data.uniqueCode}',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.emptyLines(3);

    bytes += generator.text(
      text,
      styles: const PosStyles(
        align: PosAlign.right,
        bold: false,
      ),
    );

    bytes += generator.emptyLines(1);

    return bytes;
  }

  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: FontColor.black,),
                Text('Tunggu sebentar ...', style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 12,
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                ),)
              ],
            ),
          ),
        );
      },
    );
  }

  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  static String toClearNumber(String value) {
    return value.replaceAll('.', '');
  }

  static String formatMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }



  static Future<List<File>> watermarkImageF(List<File> files, String coordinate) async {
    List<File> filesM = [];
    final current = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm:ss').format(current);

    final text = "$dateFormat - $coordinate";

    final watermarkPlugin = WatermarkUnique();
    for(var i in files) {
      final image = await watermarkPlugin.addTextWatermark(
        filePath: i.path,
        text: text,
        x: 8,
        y: 40,
        textSize: 25,
        color: Colors.white,
        isNeedRotateToPortrait: true,
        backgroundTextColor: Colors.black.withValues(alpha: 0.3),
        quality: 80,
        backgroundTextPaddingLeft: 0,
        backgroundTextPaddingTop: 16,
        backgroundTextPaddingRight: 0,
        backgroundTextPaddingBottom: 0,
        imageFormat: format.ImageFormat.jpeg,
      );
      if (image != null) {
        File file = File(image);
        filesM.add(file);
      }
    }

    if (filesM.length == files.length) {
      return filesM;
    } else {
      Fluttertoast.showToast(msg: 'Terjadi Kesalahan');
      return Future.error('null');
    }
  }
}