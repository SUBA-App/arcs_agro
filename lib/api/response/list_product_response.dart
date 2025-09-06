import 'package:arcs_agro/api/response/receipts_response.dart';

class ListProductResponse {
  bool error;
  String message;
  String listProductId;
  List<ListProduct> result;

  ListProductResponse({
    required this.error,
    required this.message,
    required this.listProductId,
    required this.result
  });

  factory ListProductResponse.fromJson(Map<String, dynamic> json) => ListProductResponse(
    error: json["error"],
    message: json["message"],
    result:List<ListProduct>.from(json['result'].map((e) => ListProduct.fromJson(e))), listProductId: json['list_product_id'],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result':List<dynamic>.from(result.map((e) => e.toJson()))
  };
}

