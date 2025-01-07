

import 'dart:ui';

import 'absen_response.dart';

class ReportResponse {
  bool error;
  String message;
  List<ReportResult> result;

  ReportResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) => ReportResponse(
    error: json["error"],
    message: json["message"],
    result: List<ReportResult>.from(json['result'].map((e) => ReportResult.fromJson(e)))
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': List<dynamic>.from(result.map((e) => e.toJson()))
  };
}

class ReportResult {
  String id;
  String salesName;
  String salesCompany;
  String storeName;
  String invoice;
  Payment payment;
  String created_at;
  String note;
  int status;
  CheckDate checkDate;
  InputDate inputDate;


  ReportResult({
      required this.id,
    required this.salesName,
    required this.salesCompany,
    required this.storeName,
    required this.invoice,
    required this.payment,
    required this.created_at,
    required this.note,
    required this.status,
    required this.checkDate, required this.inputDate});

  factory ReportResult.fromJson(Map<String, dynamic> json) => ReportResult(
    id: json["id"],
    status: json['status'],
    salesName: json['sales_name'],
    salesCompany: json['sales_company'],
      storeName: json['store_name'],
      invoice: json['invoice'],
    note: json['note'] ?? '',
    payment: Payment.fromJson(json['payment']),
    created_at: json['created_at'],
    checkDate: CheckDate.fromJson(json['check']),
    inputDate: InputDate.fromJson(json['input']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    'sales_name': salesName,
    'sales_company': salesCompany,
    'store_name': storeName,
    'invoice': invoice,
    'note': note,
    'payment':payment.toJson(),
    'created_at': created_at,
    'check': checkDate.toJson(),
    'input': inputDate.toJson()

  };
}

class Payment {
  int method;
  String methodName;
  String noGiro;
  String giroDate;
  List<String> pictures;
  String bankName;
  int amount;


  Payment({required this.method,required this.methodName,required this.noGiro,required this.giroDate,
    required this.pictures,required this.bankName,required this.amount});

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
      method: json["method"]?? 0,
      methodName: json['method_name'] ?? '',
    noGiro: json['no_giro'] ?? '',
    giroDate: json['giro_date'] ?? '',
    pictures: List<String>.from(json['pictures'].map((e) => e)),
    bankName: json['bank_name'] ?? '',
    amount: json['amount'] ?? 0,

  );

  Map<String, dynamic> toJson() => {
    "method": method,
    "method_name": methodName,
    'no_giro': noGiro,
    'giro_date': giroDate,
    'pictures':List<dynamic>.from(pictures.map((e) => e)),
    'bank_name': bankName,
    'amount': amount
  };
}

class CheckDate {
  String note;
  String checkDate;


  CheckDate({required this.note, required this.checkDate});

  factory CheckDate.fromJson(Map<String, dynamic> json) => CheckDate(
    note: json["note"] ?? '',
    checkDate: json['check_date'] ?? '',

  );

  Map<String, dynamic> toJson() => {
    "note": note,
    "check_date": checkDate,
  };
}

class InputDate {
  String note;
  String inputDate;


  InputDate({required this.note, required this.inputDate});

  factory InputDate.fromJson(Map<String, dynamic> json) => InputDate(
    note: json["note"] ?? '',
    inputDate: json['input_date'] ?? '',

  );

  Map<String, dynamic> toJson() => {
    "note": note,
    "input_date": inputDate,
  };
}