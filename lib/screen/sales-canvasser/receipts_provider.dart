import 'dart:convert';

import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/api/body/receipt_body.dart';
import 'package:sales_app/api/response/add_receipt_response.dart';
import 'package:sales_app/api/response/customer_response.dart';
import 'package:sales_app/api/response/receipts_response.dart';
import 'package:sales_app/bank.dart';
import 'package:sales_app/screen/report/success_screen.dart';
import 'package:sales_app/util.dart';

import '../../api/response/list_product_response.dart';
import '../../font_color.dart';


class ReceiptsProvider extends ChangeNotifier {

  bool isLoading = false;
  List<ReceiptsData> receipts = [];

  bool isLoadingDetail = false;
  ReceiptsData? receiptData;

  List<Bank> banks = [];
  List<Bank> banks2 = [];

  List<CustData> customers = [];
  bool isCustLoading = false;

  List<ListProduct> listProduct = [];
  bool isListProductLoading = false;

  EnhancedStatus enhancedStatus = EnhancedStatus.loaded;
  bool isMaxReached = false;

  EnhancedStatus enhancedStatus1 = EnhancedStatus.loaded;
  bool isMaxReached1 = false;

  String selectedKios = 'Pilih Kios';
  int selectedKiosId = 0;

  List<ListProduct> selectedProduct = [];

  String search = '';
  String sort = 'DESC';
  String start = '';
  String end = '';

  void checkProduct(int index) {
    listProduct[index].checked = !listProduct[index].checked;
    if (listProduct[index].checked) {
      listProduct[index].qty = 1;
    } else {
      listProduct[index].qty = 0;
    }

    notifyListeners();
  }

  void qtyPlus(int index) {
    if (selectedProduct[index].qty < selectedProduct[index].remainingQuantity) {
      selectedProduct[index].qty++;
      notifyListeners();
    }
  }

  void qtyMin(int index) {
    if (selectedProduct[index].qty <= 1) {
      selectedProduct.removeAt(index);
      notifyListeners();
    } else {
      selectedProduct[index].qty--;
      notifyListeners();
    }
  }

  void setPrice(int index, String price) {

    selectedProduct[index].productPrice = price;
      notifyListeners();

  }

  void setSearch(String value) {
    search = value;
    notifyListeners();
  }
  void setSort(String value) {
    sort = value;
    notifyListeners();
  }

  void setStart(String value) {
    start = value;
    notifyListeners();
  }

  void setEnd(String value) {
    end = value;
    notifyListeners();
  }

  void setListProducts(List<ListProduct> list) {
    selectedProduct = list;
    notifyListeners();
  }


  void clear() {
    sort = 'DESC';
    start = '';
    end = '';
    notifyListeners();
  }

  static TextEditingController storeName = TextEditingController();

  static void initController() {
    storeName = TextEditingController();
  }

  Future<void> loadBanks(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/json/banks.json");
    final bankse = (jsonDecode(data) as List).map((e) => Bank.fromJson(e)).toList();
    banks.clear();
    banks2.clear();
    banks.addAll(bankse);
    banks2.addAll(bankse);
    notifyListeners();
  }

  void setKios(String value, int id) {
    selectedKios = value;
    selectedKiosId = id;

    notifyListeners();
  }

  void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: LottieBuilder.asset(
              'assets/lottie/loading.json',
              width: 70,
              height: 70,
            ),
          );
        });
  }

  Future<void> listBarang(BuildContext context,String keyword) async {
    isListProductLoading = true;
    notifyListeners();
    final response = await ApiService.listProduct(context, keyword);
    if (response is ListProductResponse) {
      if (!response.error) {
        isListProductLoading = false;
        listProduct = response.result;
        notifyListeners();
      }
    }
  }

  Future<void> getReceipts(BuildContext context,int page) async {
    isLoading = true;
    receipts = [];
    notifyListeners();
    isMaxReached = false;
    final response = await ApiService.receipts(context,page, search,sort,start,end);
    if (response is ReceiptsResponse) {
      if (!response.error) {
        isLoading = false;
        receipts = response.result.results;
        notifyListeners();
      }
    }
  }

  Future<void> loadMoreReceipts(BuildContext context,int page) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.reports(context,page,search,sort,start,end);
    if (response is ReceiptsResponse) {
      if (!response.error) {
        receipts.addAll(response.result.results);
        enhancedStatus = EnhancedStatus.loaded;
        if (receipts.length >= response.result.total) {
          isMaxReached = true;
          notifyListeners();
        }
        notifyListeners();
      }
    }
  }

  Future<void> getCustomers(BuildContext context,int page, String keyword) async {
    isCustLoading = true;
    notifyListeners();
    isMaxReached = true;
    final response = await ApiService.customers(context,page, keyword);
    if (response.runtimeType == CustomerResponse) {
      final resp = response as CustomerResponse;
      if (!resp.error) {
        isCustLoading = false;
        customers = resp.result?.data ?? [];
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

  Future<void> loadMoreCust(BuildContext context,int page, String keyword) async {
    enhancedStatus = EnhancedStatus.loading;
    notifyListeners();
    final response = await ApiService.customers(context,page, keyword);
    if (response.runtimeType == CustomerResponse) {
      final resp = response as CustomerResponse;
      if (!resp.error) {
        customers.addAll(resp.result?.data ?? []);
        enhancedStatus = EnhancedStatus.loaded;
        if (customers.length >= resp.result!.sp!.rowCount) {
          isMaxReached = true;
          notifyListeners();
        }
        notifyListeners();
      }
    }
  }

  void clearData() {
    selectedKios = 'Pilih Kios';
    selectedKiosId = 0;
    selectedProduct.clear();

    notifyListeners();
  }

  Future<void> addReceipt(BuildContext context) async {

    bool error = false;

    for (var i in selectedProduct) {
      if (i.productPrice == '0') {
        error = true;
        break;
      }
    }

    if (selectedKios == 'Pilih Kios' || selectedProduct.isEmpty) {
      error = true;
    }

    if (!error) {
      final body = ReceiptBody(storeName: selectedKios, products: selectedProduct);

      showLoading(context);
      final response = await ApiService.addReceipt(context,body);
      if (response is AddReceiptResponse) {

        if (!response.error) {
          if (context.mounted) {
            List<int> template = await Util.templateReceipt(response.result);

            if (!context.mounted) return;
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SuccessScreen(template: template,count:2)));
          }
        } else {
          if (context.mounted) {
            Navigator.pop(context);
          }
          Fluttertoast.showToast(msg: response.message);
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          }
        Fluttertoast.showToast(msg: response.toString());
      }
    } else {
      Fluttertoast.showToast(msg: 'Data Belum Lengkap');
    }


  }
}
