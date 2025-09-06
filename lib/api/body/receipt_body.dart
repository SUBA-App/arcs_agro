import 'dart:convert';

import 'package:arcs_agro/api/response/receipts_response.dart';

class ReceiptBody {
  String id;
  String storeName;
  List<ListProduct> products;

  ReceiptBody({required this.id,required this.storeName, required this.products});

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'products': jsonEncode(products.map((product) => product.toJson()).toList()),
      'id' : id
    };
  }
}