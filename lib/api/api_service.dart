
import 'dart:convert';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/api/body/coordinate_body.dart';
import 'package:sales_app/api/body/report_body.dart';
import 'package:sales_app/api/response/absen_response.dart';
import 'package:sales_app/api/response/active_absen_response.dart';
import 'package:sales_app/api/response/check_status_response.dart';
import 'package:sales_app/api/response/customer_response.dart';
import 'package:sales_app/api/response/default_response.dart';
import 'package:sales_app/api/response/invoice_response.dart';
import 'package:sales_app/api/response/login_response.dart';
import 'package:sales_app/api/response/product_response.dart';
import 'package:sales_app/api/response/report_response.dart';
import 'package:sales_app/screen/login_screen/login_screen.dart';

import '../util/preferences.dart';


class ApiService {

  static const _baseUrl = 'https://weles.my.id/api/';

  static const imageUrl = 'https://weles.my.id/storage/images/absensi/';
  static const imageUrlPayment = 'https://weles.my.id/storage/images/payment/';

  static Map<String,String> _headers = {};

  static init() {
    _headers = {
      'Authorization': 'Bearer ${Preferences.token()}',
      'Accept':'application/json',
      'X-API-KEY':'Pz6dWj6XiZRTcgRYJlqmRZ'
    };
  }

  static Future<Object> login(String email, String password) async {
    try {

      final response = await http.post(
          Uri.parse('${_baseUrl}auth/login'), headers: {
            'X-API-KEY':'Pz6dWj6XiZRTcgRYJlqmRZ'
      }, body: {
        'email': email,
        'password': password
      });

      if (kDebugMode) {
        print('response login : ${response.body}');
      }
      return LoginResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> getAbsensi() async {
    try {

      final response = await http.get(
          Uri.parse('${_baseUrl}absensi'), headers: _headers);
      if (kDebugMode) {

        print('response absensi : ${response.body}');
      }
      return AbsenResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> getActiveAbsensi() async {

    try {
      final response = await http.get(
          Uri.parse('${_baseUrl}absensi/active'), headers: _headers);

      if (kDebugMode) {
        print('cc ${_headers.toString()}' );
        print('cc ${response.headers.toString()}' );
        print('response absensi active: ${response.body}');
      }
      return ActiveAbsenResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> getDetailAbsensi(String id) async {

    try {
      final response = await http.get(
          Uri.parse('${_baseUrl}absensi/detail/$id'), headers: _headers);
      if (kDebugMode) {
        print('response absensi detail: ${response.body}');
      }
      return ActiveAbsenResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> addAbsen(List<File> files, double latitude, double longitude, String kios) async {
    try {
      var request =  http.MultipartRequest("POST", Uri.parse('${_baseUrl}absensi/add'));
      request.headers.addAll(_headers);
      for(var i in files) {
        print(i.path);
        request.files.add(await http.MultipartFile.fromPath(
          'images[]',
          i.path,
        ));
      }
      request.fields['store_name'] = kios;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      final response = await request.send();
      if(response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        var jsonBody = jsonDecode(responseToString);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return DefaultResponse.fromJson(jsonBody as Map<String,dynamic>);
      } else if (response.statusCode == 422) {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        var jsonBody = jsonDecode(responseToString);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return DefaultResponse.fromJson(jsonBody as Map<String,dynamic>);
      } else {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return 'error';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> checkOut(String id, double latitude, double longitude) async {
    try {
      final response = await http.put(
          Uri.parse('${_baseUrl}absensi/update/$id'), headers: _headers, body: CoordinateBody(latitude, longitude).toJson());
      if (kDebugMode) {
        print('response absensi update : ${response.body}');
      }
      return DefaultResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> updateCoordinate(CoordinateBody body) async {

    try {
      final response = await http.post(
          Uri.parse('${_baseUrl}absensi/update-coordinate'), headers: _headers, body: body.toJson());
      if (kDebugMode) {
        print(_headers.toString());
        printWrapped('response absensi coordinate : ${response.body}');
      }
      return DefaultResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static Future<Object> reports() async {
    try {
      final response = await http.get(
          Uri.parse('${_baseUrl}report'), headers: _headers);
      if (kDebugMode) {
        print('response report : ${response.body}');
      }
      return ReportResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }



  static Future<Object> customers(int page) async {
    try {
      final response = await http.get(
          Uri.parse('${_baseUrl}report/customers?page=$page'), headers: _headers, );
      if (kDebugMode) {
        print('response customers : ${response.body}');
      }
      return CustomerResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> invoices(int page, String customerId ) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}report/invoices?page=$page&customer_id=$customerId'), headers: _headers, );
      if (kDebugMode) {
        print('response invoices : ${response.body}');
      }
      return InvoiceResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> products(int page) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}product?page=$page'), headers: _headers, );
      if (kDebugMode) {
        print('response product : ${response.body}');
      }
      return ProductResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> search(int page, String keywords) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}product/search?page=$page&keywords=$keywords'), headers: _headers, );
      if (kDebugMode) {
        print('response search : ${response.body}');
      }
      return ProductResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }



  static Future<Object> addReport(List<File> files, ReportBody body) async {
    try {
      var request =  http.MultipartRequest("POST", Uri.parse('${_baseUrl}report/add'));
      request.headers.addAll(_headers);
      if (files.isNotEmpty) {
        for (var e in files) {
          request.files.add(await http.MultipartFile.fromPath(
            'images[]',
            e.path,
          ));
        }
      }
      request.fields['store_name'] = body.storeName;
      request.fields['invoice'] = body.invoice;
      request.fields['payment_method'] = body.paymentMethod;
      request.fields['no_giro'] = body.noGiro;
      request.fields['giro_date'] = body.giroDate;
      request.fields['bank_name'] = body.bankName;
      request.fields['amount'] = body.amount.toString();
      request.fields['note'] = body.note;

      final response = await request.send();
      if(response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        var jsonBody = jsonDecode(responseToString);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return DefaultResponse.fromJson(jsonBody as Map<String,dynamic>);
      } else if (response.statusCode == 422) {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        var jsonBody = jsonDecode(responseToString);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return DefaultResponse.fromJson(jsonBody as Map<String,dynamic>);
      } else {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return 'error';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> checkStatus(BuildContext context) async {
    try {
      final response = await http.get(
          Uri.parse('${_baseUrl}auths/check'), headers: _headers);
      if (kDebugMode) {
        print('response check : ${response.body}');
      }
      final json = jsonDecode(response.body) as Map<String,dynamic>;
      if (json['message'] == 'Unauthenticated.') {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => LoginScreen()), (
              e) => false);
        }
      }
      return CheckStatusResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> changePw(String password) async {
    try {
      final response = await http.post(
          Uri.parse('${_baseUrl}auths/change-pw'), headers: _headers, body: {'password': password});
      if (kDebugMode) {
        print('response change pw : ${response.body}');
      }
      return DefaultResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> logout() async {
    try {
      final response = await http.post(
          Uri.parse('${_baseUrl}auths/logout'), headers: _headers);
      if (kDebugMode) {
        print('response logout : ${response.body}');
      }
      return DefaultResponse.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }
}