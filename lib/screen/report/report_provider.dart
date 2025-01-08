import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/api/body/report_body.dart';
import 'package:sales_app/api/model/method.dart';
import 'package:sales_app/api/response/customer_response.dart';
import 'package:sales_app/api/response/default_response.dart';
import 'package:sales_app/api/response/invoice_response.dart';
import 'package:sales_app/api/response/report_response.dart';
import 'package:sales_app/bank.dart';
import 'package:sales_app/util.dart';


class ReportProvider extends ChangeNotifier {

  bool isLoading = false;
  List<ReportResult> reports = [];
  List<ReportResult> reports2 = [];

  List<Bank> banks = [];
  List<Bank> banks2 = [];

  List<CustData> customers = [];
  List<CustData> customers2 = [];
  bool isCustLoading = false;

  List<InvoiceData> invoices = [];
  List<InvoiceData> invoices2 = [];
  bool isInvoiceLoading = false;

  EnhancedStatus enhancedStatus = EnhancedStatus.loaded;
  bool isMaxReached = false;

  String selectedKios = 'Pilih Kios';
  int selectedKiosId = 0;

  String selectedInvoice = 'Pilih Invoice';
  int selectedInvoiceId = 0;
  String invoice = '';

  late TextEditingController noGiro;
  late TextEditingController giroDate;
  late TextEditingController amount;
  late TextEditingController ket;
  Bank? selectedBank;
  Method? selectedMethod;
  String selectedGiroDate = '';
  int selectedGiroMillis = 0;
  String selectedPayDate = '';
  int selectedPayMillis = 0;
  List<File> selectedListImage = [];

  List<Method> methods = [
    Method('Tunai', 1),
    Method('Transfer', 2),
    Method('Cek/Giro', 3)
  ];

  void initController() {
    noGiro = TextEditingController();
    giroDate = TextEditingController();
    amount = TextEditingController();
    ket = TextEditingController();
  }

  Future<void> loadBanks(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/json/banks.json");
    final bankse = (jsonDecode(data) as List).map((e) => Bank.fromJson(e)).toList();
    banks.clear();
    banks2.clear();
    banks.addAll(bankse);
    banks2.addAll(bankse);
    notifyListeners();
  }

  void setMethod(Method method) {
    selectedMethod = method;
    if (method.id == 2) {
      selectedGiroDate = "";
      noGiro.text = "";
      selectedListImage.clear();
    } else if (method.id == 3) {
      selectedListImage.clear();
    } else {
      selectedGiroDate = "";
      noGiro.text = "";
      selectedBank == null;
      selectedListImage.clear();
    }
    notifyListeners();
  }

  void setGiroDate(String date, int millis) {
    selectedGiroDate = date;
    giroDate.text = date;
    selectedGiroMillis = millis;
    notifyListeners();
  }

  void setPayDate(String date, int millis) {
    selectedPayDate = date;
    selectedPayMillis = millis;
    notifyListeners();
  }

  void setBank(Bank bank) {
    selectedBank = bank;
    notifyListeners();
  }

  void searchBank(String value) {
    banks.clear();
    if (value.isNotEmpty) {
      for (var e in banks2) {
        if (e.name.toLowerCase().contains(value.toLowerCase())) {
          banks.add(e);

        }
      }
    } else {
      banks.addAll(banks2);
    }
    notifyListeners();
  }

  void setImage(List<XFile> files) {
    for(var i in files) {
      selectedListImage.add(File(i.path));
    }
    notifyListeners();
  }

  void removeImage(File file) {
    selectedListImage.remove(file);
    notifyListeners();
  }


  void setKios(String value, int id) {
    selectedKios = value;
    selectedKiosId = id;
    notifyListeners();
  }

  void setInvoice(int id) {
    selectedInvoiceId = id;
    notifyListeners();
  }

  void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: LottieBuilder.asset(
              'assets/lottie/loading.json',
              width: 70,
              height: 70,
            ),
          );
        });
  }
  
  Future<void> getReports() async {
    isLoading = true;
    notifyListeners();
    final response = await ApiService.reports();
    if (response.runtimeType == ReportResponse) {
      final resp = response as ReportResponse;
      if (!resp.error) {
        isLoading = false;
        reports = resp.result;
        reports2 = resp.result;
        print(reports2.length);
        notifyListeners();
      }
    }
  }

  Future<void> getCustomers(int page) async {
    isCustLoading = true;
    notifyListeners();
    final response = await ApiService.customers(page);
    if (response.runtimeType == CustomerResponse) {
      final resp = response as CustomerResponse;
      if (!resp.error) {
        isCustLoading = false;

        customers = resp.result?.data ?? [];
        customers2 = resp.result?.data ?? [];
        notifyListeners();
      }
    }
  }

  Future<void> loadMoreCust(int page) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.customers(page);
    if (response.runtimeType == CustomerResponse) {
      final resp = response as CustomerResponse;
      if (!resp.error) {
        customers.addAll(resp.result?.data ?? []);
        customers2.addAll(resp.result?.data ?? []);
        enhancedStatus = EnhancedStatus.loaded;
        if (customers.length >= resp.result!.sp!.rowCount) {
          isMaxReached = true;
          notifyListeners();
        }
        notifyListeners();
      }
    }
  }

  Future<void> getInvoices(int page, String customerId) async {
    isInvoiceLoading = true;
    invoices = [];
    invoices2 = [];
    notifyListeners();
    final response = await ApiService.invoices(page, customerId);
    if (response.runtimeType == InvoiceResponse) {
      final resp = response as InvoiceResponse;
      if (!resp.error) {
        isInvoiceLoading = false;

        invoices = resp.result?.data ?? [];
        invoices2 = resp.result?.data ?? [];
        notifyListeners();
      }
    }
  }

  Future<void> loadMoreInvoice(int page,String customerId) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.invoices(page, customerId);
    if (response.runtimeType == InvoiceResponse) {
      final resp = response as InvoiceResponse;
      if (!resp.error) {
        invoices.addAll(resp.result?.data ?? []);
        invoices2.addAll(resp.result?.data ?? []);
        enhancedStatus = EnhancedStatus.loaded;
        if (invoices.length >= resp.result!.sp!.rowCount) {
          isMaxReached = true;
          notifyListeners();
        }
        notifyListeners();
      }
    }
  }
  
  void filter(String value) {
    reports = [];
    if (value.isNotEmpty) {
      for (var e in reports2) {
        if (e.storeName.toLowerCase().contains(value.toLowerCase())) {
          reports.add(e);
        }
      }
    } else {

      reports.addAll(reports2);
    }
    notifyListeners();
  }

  void clearData() {
    selectedMethod = null;
    amount.clear();
    selectedKios = 'Pilih Kios';
    selectedInvoiceId = 0;
    selectedListImage = [];
    selectedBank = null;
    noGiro.clear();
    giroDate.clear();

    notifyListeners();
  }

  Future<void> addReport(BuildContext context) async {

    bool error = false;

    if (selectedMethod != null) {
      if (selectedMethod?.id == 1) {
        if (amount.text.isEmpty
            || selectedKios == 'Pilih Kios'
            || selectedInvoiceId == 0
            || selectedListImage.isEmpty
        ) {
          error = true;
        }
      } else if (selectedMethod?.id == 2) {
        if (amount.text.isEmpty
            || selectedKios == 'Pilih Kios'
            || selectedInvoiceId == 0
        || selectedListImage.isEmpty
        || selectedBank == null
        ) {
          error = true;
        }
      } else if (selectedMethod?.id == 3) {
        if (amount.text.isEmpty
            || selectedKios == 'Pilih Kios'
            || selectedInvoiceId == 0
        || noGiro.text.isEmpty
        || giroDate.text.isEmpty
        || selectedListImage.isEmpty

        ) {
          error = true;
        }
      }
    } else {
      error = true;
    }

    if (!error) {
      print(selectedPayDate);
      final body = ReportBody(selectedPayMillis,selectedKios, selectedInvoiceId.toString(), selectedMethod!.id.toString(), noGiro.text, selectedGiroMillis, selectedBank?.name ?? '', int.parse(Util.toClearNumber(amount.text)), ket.text);

      showLoading(context);
      final response = await ApiService.addReport(selectedListImage, body);
      if (response.runtimeType == DefaultResponse) {
        final resp = response as DefaultResponse;
        if (!resp.error) {
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pop(context, ['ss']);
          }
        } else {
          if (context.mounted) {
            Navigator.pop(context);
          }
          Fluttertoast.showToast(msg: resp.message);
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          }
        Fluttertoast.showToast(msg: response.toString());
      }
    } else {
      Fluttertoast.showToast(msg: 'Data Belum Lengkap');
    }


  }
}
