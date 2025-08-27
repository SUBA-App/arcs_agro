

import 'package:arcs_agro/api/response/absen_response.dart';

class ActiveAbsenResponse {
  bool error;
  String message;
  ActiveResult result;

  ActiveAbsenResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory ActiveAbsenResponse.fromJson(Map<String, dynamic> json) => ActiveAbsenResponse(
    error: json["error"],
    message: json["message"],
    result: ActiveResult.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result.toJson()
  };
}

class ActiveResult {
  int status;
  AbsenData? absen;

  ActiveResult({required this.status, required this.absen});

  factory ActiveResult.fromJson(Map<String, dynamic> json) => ActiveResult(
      status: json['status'],
      absen: json['ab'] == null ? null : AbsenData.fromJson(json['ab'])
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    'ab': absen?.toJson(),
  };
}