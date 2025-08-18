import 'dart:math';

class InvoiceResponse {
  bool error;
  String message;
  InvoiceResult? result;

  InvoiceResponse({
    required this.error,
    required this.message,
    required this.result,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      InvoiceResponse(
        error: json["error"],
        message: json["message"],
        result:
            json['result'] == null
                ? null
                : InvoiceResult.fromJson(json['result']),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result?.toJson(),
  };
}

class InvoiceResult {
  Sp? sp;
  List<InvoiceData> data;

  InvoiceResult({required this.sp, required this.data});

  factory InvoiceResult.fromJson(Map<String, dynamic> json) => InvoiceResult(
    sp: json['sp'] == null ? null : Sp.fromJson(json['sp']),
    data: List<InvoiceData>.from(
      json['data'].map((e) => InvoiceData.fromJson(e)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "sp": sp?.toJson(),
    "data": List<dynamic>.from(data.map((e) => e.toJson())),
  };
}

class Sp {
  int page;
  dynamic sort;
  int pageSize;
  int pageCount;
  int rowCount;
  int start;
  dynamic limit;

  Sp({
    required this.page,
    required this.sort,
    required this.pageSize,
    required this.pageCount,
    required this.rowCount,
    required this.start,
    required this.limit,
  });

  factory Sp.fromJson(Map<String, dynamic> json) => Sp(
    page: json["page"],
    sort: json["sort"],
    pageSize: json["pageSize"],
    pageCount: json["pageCount"],
    rowCount: json["rowCount"],
    start: json["start"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "sort": sort,
    "pageSize": pageSize,
    "pageCount": pageCount,
    "rowCount": rowCount,
    "start": start,
    "limit": limit,
  };
}

class InvoiceData {
  int id;
  int totalAmount;
  int piutang;
  String taxDateView;
  String number;
  bool checked;

  InvoiceData({
    required this.id,
    required this.totalAmount,
    required this.piutang,
    required this.taxDateView,
    required this.number,
    required this.checked,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
    id: json['id'],
    totalAmount: json['total_amount'] ?? 0,
    piutang:json['prime_owing'] ?? 0,
    taxDateView: json['tax_date_view'] ?? '',
    number: json['number'],
    checked: false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    'total_amount': totalAmount,
    'prime_owing': piutang,
    'tax_date_view': taxDateView,
    'number': number,
  };
}
