import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
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



  static Future<List<File>> watermarkImageF(List<File> files) async {
    List<File> filesM = [];
    final current = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm:ss').format(current);
    final watermarkPlugin = WatermarkUnique();
    for(var i in files) {
      final image = await watermarkPlugin.addTextWatermark(
        filePath: i.path,
        text: dateFormat,
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