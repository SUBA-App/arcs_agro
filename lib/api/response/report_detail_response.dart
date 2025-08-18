
import 'package:sales_app/api/response/report_response.dart';

class ReportDetailResponse {
  bool error;
  String message;
  ReportData result;

  ReportDetailResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory ReportDetailResponse.fromJson(Map<String, dynamic> json) => ReportDetailResponse(
    error: json["error"],
    message: json["message"],
    result:ReportData.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result.toJson()
  };
}
