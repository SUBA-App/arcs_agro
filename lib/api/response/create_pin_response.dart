
import 'package:sales_app/api/model/user.dart';

class CreatePinResponse {
  bool error;
  String message;
  User result;

  CreatePinResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory CreatePinResponse.fromJson(Map<String, dynamic> json) => CreatePinResponse(
    error: json["error"],
    message: json["message"],
    result:  User.fromJson(json['user'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result.toJson()
  };
}