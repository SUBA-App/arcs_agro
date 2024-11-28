import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/api/response/product_response.dart';

import '../../api/api_service.dart';

class ProductProvider extends ChangeNotifier {

  EnhancedStatus enhancedStatus = EnhancedStatus.loaded;
  bool isMaxReached = false;
  TextEditingController searchC = TextEditingController();

  List<ProductData> products = [];
  List<ProductData> products2 = [];

  bool inSearch = false;
  bool searchLoading = false;

  void setMode(bool inSearcha) {
    inSearch = inSearcha;
    notifyListeners();
  }


  Future<void> getProducts(int page) async {
    products.clear();
    notifyListeners();
    final response = await ApiService.products(page);
    if (response.runtimeType == ProductResponse) {
      final resp = response as ProductResponse;
      if (!resp.error) {

        products = resp.result?.data ?? [];
        notifyListeners();
      }
    }
  }


  Future<void> loadMoreCust(int page) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.products(page);
    if (response.runtimeType == ProductResponse) {
      final resp = response as ProductResponse;
      if (!resp.error) {
        products.addAll(resp.result?.data ?? []);
        enhancedStatus = EnhancedStatus.loaded;
        if (products.length >= resp.result!.sp!.rowCount) {
          isMaxReached = true;
          notifyListeners();
        }
        notifyListeners();
      }
    }
  }

  Future<void> search(int page, String keywords) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.search(page, keywords);
    if (response.runtimeType == ProductResponse) {
      final resp = response as ProductResponse;
      if (!resp.error) {
        products2.addAll(resp.result?.data ?? []);
        enhancedStatus = EnhancedStatus.loaded;
        if (products2.length >= resp.result!.sp!.rowCount) {
          isMaxReached = true;
          notifyListeners();
        }
        notifyListeners();
      }
    }
  }

  Future<void> searchFirst(int page, String keywords) async {
    searchLoading = true;
    notifyListeners();
    final response = await ApiService.search(page,keywords);
    if (response.runtimeType == ProductResponse) {
      final resp = response as ProductResponse;
      if (!resp.error) {
        searchLoading = false;
        products2.clear();
        products2 = resp.result?.data ?? [];
        notifyListeners();
      }
    }
  }
}