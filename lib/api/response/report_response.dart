

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
  String time_at;
  int status;
  String checkDate;


  ReportResult({
      required this.id,
    required this.salesName,
    required this.salesCompany,
    required this.storeName,
    required this.invoice,
    required this.payment,
    required this.created_at,
    required this.time_at,
    required this.status,
    required this.checkDate});

  factory ReportResult.fromJson(Map<String, dynamic> json) => ReportResult(
    id: json["id"],
    status: json['status'],
    salesName: json['sales_name'],
    salesCompany: json['sales_company'],
      storeName: json['store_name'],
      invoice: json['invoice'],
    payment: Payment.fromJson(json['payment']),
    created_at: json['created_at'],
    time_at: json['time_at'],
    checkDate: json['check_date']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    'sales_name': salesName,
    'sales_company': salesCompany,
    'store_name': storeName,
    'invoice': invoice,
    'payment':payment.toJson(),
    'created_at': created_at,
    'time_at': time_at,
    'check_date': checkDate,

  };
}

class Payment {
  int method;
  String methodName;
  String noGiro;
  String giroDate;
  String picture;
  String bankName;
  int amount;


  Payment({required this.method,required this.methodName,required this.noGiro,required this.giroDate,
    required this.picture,required this.bankName,required this.amount});

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
      method: json["method"]?? 0,
      methodName: json['method_name'] ?? '',
    noGiro: json['no_giro'] ?? '',
    giroDate: json['giro_date'] ?? '',
    picture: json['picture'] ?? '',
    bankName: json['bank_name'] ?? '',
    amount: json['amount'] ?? 0,

  );

  Map<String, dynamic> toJson() => {
    "method": method,
    "method_name": methodName,
    'no_giro': noGiro,
    'giro_date': giroDate,
    'picture': picture,
    'bank_name': bankName,
    'amount': amount
  };
}