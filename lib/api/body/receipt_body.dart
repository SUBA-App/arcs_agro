import 'dart:convert';

import 'package:sales_app/api/response/receipts_response.dart';

class ReceiptBody {
  String storeName;
  List<ListProduct> products;

  ReceiptBody({required this.storeName, required this.products});

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'products': jsonEncode(products.map((product) => product.toJson()).toList()),
    };
  }
}