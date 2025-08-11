class User {
  String id;
  String name;
  String email;
  String companyName;
  bool hasPin;
  int isAbsenteeism;
  int isReport;
  int isProduct;
  int versionApp;
  String role;

  User({required this.role,required this.versionApp,required this.id, required this.name, required this.email, required this.companyName, required this.hasPin, required this.isAbsenteeism, required this.isReport, required this.isProduct});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      companyName: json['company_name'],
    hasPin: json['hasPin'] ?? false,
    isAbsenteeism: json['is_absenteeism'] ?? 0,
    isReport: json['is_report'] ?? 0,
    isProduct: json['is_product'] ?? 0,
    versionApp: json['version_app'] ?? 0,
    role: json['role'] ?? ''
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    'email': email,
    'company_name': companyName,
    'hasPin': hasPin,
    'is_absenteeism': isAbsenteeism,
    'is_report': isReport,
    'is_product': isProduct,
    'version_app': versionApp,
    'role': role
  };
}