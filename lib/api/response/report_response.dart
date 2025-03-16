


class ReportResponse {
  bool error;
  String message;
  ReportResult result;

  ReportResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) => ReportResponse(
    error: json["error"],
    message: json["message"],
    result:ReportResult.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result.toJson()
  };
}

class ReportResult {

  List<ReportData> results;
  int currentPage;
  int total;
  int lastPage;

  ReportResult({required this.results, required this.currentPage, required this.total, required this.lastPage});

  factory ReportResult.fromJson(Map<String, dynamic> json) => ReportResult(
      results:  List<ReportData>.from(json['data'].map((e) => ReportData.fromJson(e))),
      currentPage: json['current_page'],
      total: json['total'],
      lastPage: json['last_page']
  );

  Map<String,dynamic> toJson() => {
    'data':List<dynamic>.from(results.map((e) => e.toJson())),
    'current_page': currentPage,
    'total': total,
    'last_page': lastPage
  };


}

class ReportData {
  String id;
  String salesName;
  String salesCompany;
  String storeName;
  String invoice;
  Payment payment;
  String createdAt;
  String note;
  int status;
  CheckDate checkDate;
  InputDate inputDate;


  ReportData({
    required this.id,
    required this.salesName,
    required this.salesCompany,
    required this.storeName,
    required this.invoice,
    required this.payment,
    required this.createdAt,
    required this.note,
    required this.status,
    required this.checkDate, required this.inputDate});

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
    id: json["id"],
    status: json['status'],
    salesName: json['sales_name'],
    salesCompany: json['sales_company'],
    storeName: json['store_name'],
    invoice: json['invoice'],
    note: json['note'] ?? '',
    payment: Payment.fromJson(json['payment']),
    createdAt: json['created_at'],
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
    'created_at': createdAt,
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