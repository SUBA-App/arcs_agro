

class CheckStatusResponse {
  bool error;
  String message;
  CheckResult result;

  CheckStatusResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory CheckStatusResponse.fromJson(Map<String, dynamic> json) => CheckStatusResponse(
    error: json["error"],
    message: json["message"],
    result: CheckResult.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result.toJson()
  };
}

class CheckResult {
  int status;

  CheckResult({
      required this.status,
  });

  factory CheckResult.fromJson(Map<String, dynamic> json) => CheckResult(
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}