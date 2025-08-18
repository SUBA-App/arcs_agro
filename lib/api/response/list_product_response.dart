import 'package:sales_app/api/response/receipts_response.dart';

class ListProductResponse {
  bool error;
  String message;
  List<ListProduct> result;

  ListProductResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory ListProductResponse.fromJson(Map<String, dynamic> json) => ListProductResponse(
    error: json["error"],
    message: json["message"],
    result:List<ListProduct>.from(json['result'].map((e) => ListProduct.fromJson(e))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result':List<dynamic>.from(result.map((e) => e.toJson()))
  };
}

