import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
}