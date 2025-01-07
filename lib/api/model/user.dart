class User {
  String id;
  String name;
  String email;
  String companyName;
  bool hasPin;

  User({required this.id, required this.name, required this.email, required this.companyName, required this.hasPin});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      companyName: json['company_name'],
    hasPin: json['hasPin'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    'email': email,
    'company_name': companyName,
    'hasPin': hasPin,
  };
}