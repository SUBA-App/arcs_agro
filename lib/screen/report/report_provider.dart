import 'dart:io';

import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task/models/service_request_result.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/api/body/report_body.dart';
import 'package:sales_app/api/model/method.dart';
import 'package:sales_app/api/response/absen_response.dart';
import 'package:sales_app/api/response/active_absen_response.dart';
import 'package:sales_app/api/response/customer_response.dart';
import 'package:sales_app/api/response/default_response.dart';
import 'package:sales_app/api/response/invoice_response.dart';
import 'package:sales_app/api/response/report_response.dart';
import 'package:sales_app/screen/main/main_page.dart';
import 'package:sales_app/util.dart';
import 'package:sales_app/util/preferences.dart';

import '../../service/location_foreground_service.dart';

class ReportProvider extends ChangeNotifier {

  bool isLoading = false;
  List<ReportResult> reports = [];
  List<ReportResult> reports2 = [];

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

  TextEditingController noGiro = TextEditingController();
  TextEditingController giroDate = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController bankName = TextEditingController();
  Method? selectedMethod;
  String selectedGiroDate = '';
  File? selectedImage;

  List<Method> methods = [
    Method('Tunai', 1),
    Method('Transfer', 2),
    Method('Cek/Giro', 3)
  ];

  void setMethod(Method method) {
    selectedMethod = method;
    notifyListeners();
  }

  void setGiroDate(String date) {
    selectedGiroDate = date;
    giroDate.text = date;
    notifyListeners();
  }

  void setImage(File? file) {
    selectedImage = file;
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
        if (e.storeName.contains(value)) {
          reports.add(e);
        }
      }
    } else {

      reports.addAll(reports2);
    }
    notifyListeners();
  }

  Future<void> addReport(BuildContext context) async {

    bool error = false;

    if (selectedMethod != null) {
      if (selectedMethod?.id == 1) {
        if (amount.text.isEmpty
            || selectedKios == 'Pilih Kios'
            || selectedInvoiceId == 0
        ) {
          error = true;
        }
      } else if (selectedMethod?.id == 2) {
        if (amount.text.isEmpty
            || selectedKios == 'Pilih Kios'
            || selectedInvoiceId == 0
        || selectedImage == null
        || bankName.text.isEmpty
        ) {
          error = true;
        }
      } else if (selectedMethod?.id == 3) {
        if (amount.text.isEmpty
            || selectedKios == 'Pilih Kios'
            || selectedInvoiceId == 0
        || noGiro.text.isEmpty
        || giroDate.text.isEmpty
        || selectedImage == null

        ) {
          error = true;
        }
      }
    } else {
      error = true;
    }

    if (!error) {

      final body = ReportBody(selectedKios, selectedInvoiceId.toString(), selectedMethod!.id.toString(), noGiro.text, giroDate.text, bankName.text, int.parse(Util.toClearNumber(amount.text)));

      showLoading(context);
      final response = await ApiService.addReport(selectedImage, body);
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
