import 'package:flutter/cupertino.dart';

class NextAbsensiProvider extends ChangeNotifier {
  String selectedKios = 'Pilih Kios';
  int selectedKiosId = 0;

  void setKios(String value, int id) {
    selectedKios = value;
    selectedKiosId = id;
    notifyListeners();
  }
}