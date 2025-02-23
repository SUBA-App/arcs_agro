import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

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

  static Future<List<File>> watermarkImage(List<File> files) async {
    List<File> s = [];
    final current = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm:ss').format(current);

    for(var e in files) {
      final watermarkedImg =
      await ImageWatermark.addTextWatermark(
        imgBytes: e.readAsBytesSync(),
        dstX: 20,
        dstY: 20,
        color: Colors.black, watermarkText: dateFormat,
      );
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png').create();
      file.writeAsBytesSync(watermarkedImg);
      s.add(file);
    }

    return s;
  }
}