

import '../model/user.dart';

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
  User user;


  CheckResult({required this.user});

  factory CheckResult.fromJson(Map<String, dynamic> json) => CheckResult(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}