import 'package:arcs_agro/api/model/user.dart';

class LoginResponse {
  bool error;
  String message;
  Result? result;

  LoginResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    error: json["error"],
    message: json["message"],
    result: json['result'] == null ? null : Result.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result?.toJson()
  };
}

class Result {
  String token;

  User user;


  Result({required this.token, required this.user});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}