import 'package:sales_app/api/response/receipts_response.dart';

class AddReceiptResponse {
  bool error;
  String message;
  ReceiptsData result;

  AddReceiptResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory AddReceiptResponse.fromJson(Map<String, dynamic> json) => AddReceiptResponse(
    error: json["error"],
    message: json["message"],
    result:ReceiptsData.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result.toJson()
  };
}

