
class Bank {
  String name;
  String code;

  Bank({
    required this.name,
    required this.code,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
  };
}