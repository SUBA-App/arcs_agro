class CustomerResponse {
  bool error;
  String message;
  CustomerResult? result;

  CustomerResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) => CustomerResponse(
    error: json["error"],
    message: json["message"],
    result: json['result'] == null ? null : CustomerResult.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result?.toJson()
  };
}

class CustomerResult {

  Sp? sp;
  List<CustData> data;

  CustomerResult({required this.sp, required this.data});

  factory CustomerResult.fromJson(Map<String, dynamic> json) => CustomerResult(
    sp: json['sp'] == null ? null : Sp.fromJson(json['sp']),
    data: List<CustData>.from(json['data'].map((e) => CustData.fromJson(e))),
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

class CustData {
  String name;
  int id;

  CustData({required this.name, required this.id});

  factory CustData.fromJson(Map<String, dynamic> json) => CustData(
      name: json['name'],
    id: json['id']
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}