import 'package:arcs_agro/api/model/user.dart';

import '../../util.dart';

class ReceiptsResponse {
  bool error;
  String message;
  ReceiptsResult result;

  ReceiptsResponse({
    required this.error,
    required this.message,
    required this.result
  });

  factory ReceiptsResponse.fromJson(Map<String, dynamic> json) => ReceiptsResponse(
    error: json["error"],
    message: json["message"],
    result:ReceiptsResult.fromJson(json['result'])
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    'result': result.toJson()
  };
}

class ReceiptsResult {

  List<ReceiptsData> results;
  int currentPage;
  int total;
  int lastPage;

  ReceiptsResult({required this.results, required this.currentPage, required this.total, required this.lastPage});

  factory ReceiptsResult.fromJson(Map<String, dynamic> json) => ReceiptsResult(
      results:  List<ReceiptsData>.from(json['data'].map((e) => ReceiptsData.fromJson(e))),
      currentPage: json['current_page'],
      total: json['total'],
      lastPage: json['last_page']
  );

  Map<String,dynamic> toJson() => {
    'data':List<dynamic>.from(results.map((e) => e.toJson())),
    'current_page': currentPage,
    'total': total,
    'last_page': lastPage
  };


}

class ReceiptsData {
  String id;
  User user;
  String storeName;
  String? uniqueCode;
  String? no;
  List<ListProduct> listProducts;
  String dateAt;
  String timeAt;

  ReceiptsData({
    required this.id,
    required this.storeName,
    required this.user,
    required this.listProducts,
    required this.dateAt,
    required this.timeAt,
    required this.no, required this.uniqueCode});

  factory ReceiptsData.fromJson(Map<String, dynamic> json) => ReceiptsData(
    id: json["id"],
    storeName: json['store_name'],
    dateAt: json['date_at'] ?? '',
    timeAt: json['time_at'] ?? '',
    user: User.fromJson(json['user']),
    listProducts: json['products'] == null ? [] : List<ListProduct>.from(
      json['products'].map((e) => ListProduct.fromJson(e))), no: json['no'], uniqueCode: json['unique_code'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    'store_name': storeName,
    'no':no,
    'user': user.toJson(),
    'unique_code':uniqueCode,
    'time_at': timeAt,
    'date_at': dateAt,
    'products': List<dynamic>.from(listProducts.map((e) => e.toJson())),


  };
}

class ListProduct {
  String id;
  String productName;
  int subtotal;
  int productQuantity;
  String productPrice;
  int remainingQuantity;
  int qty;
  bool checked = false;

  ListProduct({required this.id,required this.subtotal,required this.qty,required this.remainingQuantity,required this.productName,required this.productQuantity,required this.productPrice,required this.checked
    });

  factory ListProduct.fromJson(Map<String, dynamic> json) => ListProduct(
      id: json["id"],
      productName: json['product_name'],
      productQuantity: json['product_quantity'] ?? 0,
      productPrice: json['product_price']?.toString() ?? '0', checked: false, remainingQuantity: json['remaining_quantity'] ?? 0, qty: json['qty'] ?? 0, subtotal: 0
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    'product_name': productName,
    'qty': qty.toString(),
    'product_price': int.parse(Util.toClearNumber(productPrice)),
  };

  void sumSubtotal() {
    subtotal = 0;
    subtotal += (int.parse(Util.toClearNumber(productPrice)) * qty);
  }
}
