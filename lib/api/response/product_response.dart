import 'customer_response.dart';

class ProductResponse {
  bool error;
  String message;
  ProductResult? result;

  ProductResponse(
      {required this.error, required this.message, required this.result});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
          error: json["error"],
          message: json["message"],
          result: json['result'] == null
              ? null
              : ProductResult.fromJson(json['result']));

  Map<String, dynamic> toJson() =>
      {"error": error, "message": message, 'result': result?.toJson()};
}

class ProductResult {
  Sp? sp;
  List<ProductData> data;

  ProductResult({required this.sp, required this.data});

  factory ProductResult.fromJson(Map<String, dynamic> json) => ProductResult(
        sp: json['sp'] == null ? null : Sp.fromJson(json['sp']),
        data: List<ProductData>.from(
            json['products'].map((e) => ProductData.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        "sp": sp?.toJson(),
        "products": List<dynamic>.from(data.map((e) => e.toJson())),
      };
}

class ProductData {
  int id;
  String productName;
  String productNo;
  int price;
  int size;
  int show;
  String qty;
  String composition;

  ProductData(
      {required this.id,
      required this.productName,
      required this.productNo,
      required this.price,
      required this.size,
        required this.show,
      required this.qty,
      required this.composition});

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      productNo: json['product_no'] ?? '',
      price: json['price'] ?? 0,
      size: json['size'] ?? 0,
      show: json['show'] ?? 1,
      qty: json['qty'] ?? '',
      composition: json['composition'] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_no": productNo,
        "price": price,
        "size": size,
    'show': show,
        "qty": qty,
        "composition": composition
      };
}
