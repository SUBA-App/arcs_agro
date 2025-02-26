import 'dart:io';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:watermark_unique/image_format.dart' as format;
import 'package:watermark_unique/watermark_unique.dart';

extension DateTimeFromTimeOfDay on DateTime {
  DateTime appliedFromTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
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



  static Future<File> watermarkImageF(File files) async {
    final current = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm:ss').format(current);
    final watermarkPlugin = WatermarkUnique();
      final image = await watermarkPlugin.addTextWatermark(
        filePath: files.path,
        text: dateFormat,
        x: 0,
        y: 40,
        textSize: 25,
        color: Colors.white,
        isNeedRotateToPortrait: true,
        backgroundTextColor: Colors.black.withValues(alpha: 0.3),
        quality: 100,
        backgroundTextPaddingLeft: 0,
        backgroundTextPaddingTop: 16,
        backgroundTextPaddingRight: 0,
        backgroundTextPaddingBottom: 0,
        imageFormat: format.ImageFormat.png,
      );
      if (image != null) {
        File file = File(image);
        return file;
      }
    return Future.error('null');
  }
}