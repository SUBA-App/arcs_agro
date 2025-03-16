import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/api/response/product_response.dart';
import 'package:sales_app/font_color.dart';

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


  Future<void> getProducts(BuildContext context,int page) async {
    products.clear();
    isMaxReached = false;
    searchLoading = true;
    notifyListeners();
    final response = await ApiService.products(context,page);
    if (response.runtimeType == ProductResponse) {
      final resp = response as ProductResponse;
      if (!resp.error) {
        products = resp.result?.data ?? [];
        searchLoading = false;
        notifyListeners();
      } else {
        if (resp.message == 'key_failed') {
          if (context.mounted) {
            showDialog(context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.white,

                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tidak Ada Token API', style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: FontColor.black
                          ),),
                          const SizedBox(height: 8,),
                          Text('Hubungi Administrator', style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black
                          ),),
                          const SizedBox(height: 8,),
                          ElevatedButton(onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }, style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  FontColor.black)
                          ), child: Text('OK', style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),))
                        ],
                      ),
                    ),
                  );
                });
          }
        }
      }
    }
  }


  Future<void> loadMoreCust(BuildContext context,int page) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.products(context,page);
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

  Future<void> search(BuildContext context,int page, String keywords) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.search(context,page, keywords);
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

  Future<void> searchFirst(BuildContext context,int page, String keywords) async {
    searchLoading = true;
    notifyListeners();
    final response = await ApiService.search(context,page,keywords);
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