
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:arcs_agro/api/body/coordinate_body.dart';
import 'package:arcs_agro/api/body/receipt_body.dart';
import 'package:arcs_agro/api/body/report_body.dart';
import 'package:arcs_agro/api/response/absen_response.dart';
import 'package:arcs_agro/api/response/active_absen_response.dart';
import 'package:arcs_agro/api/response/add_receipt_response.dart';
import 'package:arcs_agro/api/response/check_status_response.dart';
import 'package:arcs_agro/api/response/create_pin_response.dart';
import 'package:arcs_agro/api/response/customer_response.dart';
import 'package:arcs_agro/api/response/default_response.dart';
import 'package:arcs_agro/api/response/invoice_response.dart';
import 'package:arcs_agro/api/response/list_product_response.dart';
import 'package:arcs_agro/api/response/login_response.dart';
import 'package:arcs_agro/api/response/product_response.dart';
import 'package:arcs_agro/api/response/report_detail_response.dart';
import 'package:arcs_agro/api/response/report_response.dart';
import 'package:arcs_agro/api/response/receipts_response.dart';
import 'package:arcs_agro/configuration.dart';
import 'package:arcs_agro/location_model.dart';
import 'package:arcs_agro/screen/login_screen/login_screen.dart';

import '../util/preferences.dart';

class ApiService {
  static Map<String, String> _headers = {};

  static init() {
    _headers = {
      'Authorization': 'Bearer ${Preferences.token()}',
      'Accept': 'application/json',
      'X-API-KEY': 'Pz6dWj6XiZRTcgRYJlqmRZ'
    };
  }

  static Future<Object> login(String email, String password, String version) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}auth/login'),
          headers: {'X-API-KEY': 'Pz6dWj6XiZRTcgRYJlqmRZ'},
          body: {'email': email, 'password': password, 'version_app': version});

      if (kDebugMode) {
        print('response login : ${response.body}');
      }
      return LoginResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> getAbsensi(BuildContext context, int page, String search,String sort, String start, String end) async {
    try {
      final response = await http
          .get(Uri.parse('${Configuration.apiUrl}absensi?page=$page&search=$search&sort=$sort&start=$start&end=$end'), headers: _headers);
      if (kDebugMode) {
        print('response absensi : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }

      return AbsenResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> getActiveAbsensi(BuildContext context) async {
    try {
      final response = await http.get(
          Uri.parse('${Configuration.apiUrl}absensi/active'),
          headers: _headers);

      if (kDebugMode) {
        print('response absensi active: ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }
      return ActiveAbsenResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> getDetailAbsensi(
      BuildContext context, String id) async {
    try {
      final response = await http.get(
          Uri.parse('${Configuration.apiUrl}absensi/detail/$id'),
          headers: _headers);
      if (kDebugMode) {
        print('response absensi detail: ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }
      return ActiveAbsenResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> addAbsen(BuildContext context, List<File> files,
      double latitude, double longitude, String kios,String kiosId, String note) async {
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse('${Configuration.apiUrl}absensi/add'));
      request.headers.addAll(_headers);
      for (var i in files) {
        request.files.add(await http.MultipartFile.fromPath(
          'images[]',
          i.path,
        ));
      }
      request.fields['store_name'] = kios;
      request.fields['store_id'] = kiosId;
      request.fields['note'] = note;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      final response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        var jsonBody = jsonDecode(responseToString);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return DefaultResponse.fromJson(jsonBody as Map<String, dynamic>);
      } else if (response.statusCode == 422) {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        var jsonBody = jsonDecode(responseToString);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return DefaultResponse.fromJson(jsonBody as Map<String, dynamic>);
      } else if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
        return '';
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

  static Future<Object> checkOut(BuildContext context, String id,
      double latitude, double longitude) async {
    try {
      final response = await http.put(
          Uri.parse('${Configuration.apiUrl}absensi/update/$id'),
          headers: _headers,
          body: CoordinateBody(latitude, longitude).toJson());
      if (kDebugMode) {
        print('response absensi update : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> updateCoordinate(
      CoordinateBody body) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}absensi/update-coordinate'),
          headers: _headers,
          body: body.toJson());

      if (kDebugMode) {
        print('response absensi coordinate : ${response.body}');
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> updateCacheCoordinate(List<LocationModel> models) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}absensi/update-cache-coordinate'),
          headers: _headers,
          body: {
            'coordinates': jsonEncode(List<dynamic>.from(models.map((e) => e.toJson())))
          });

      if (kDebugMode) {
        print('response absensi coordinate : ${response.body}');
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> reports(BuildContext context, int page, String search,String sort, String start, String end) async {
    try {
      final response = await http
          .get(Uri.parse('${Configuration.apiUrl}report?page=$page&search=$search&sort=$sort&start=$start&end=$end'), headers: _headers);
      if (kDebugMode) {
        print('response report : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }
      return ReportResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> customers(BuildContext context, int page, String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('${Configuration.apiUrl}report/customers?page=$page&keyword=$keyword'),
        headers: _headers,
      );
      if (kDebugMode) {
        print('response customers : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }
      return CustomerResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> invoices(
      BuildContext context, int page, String customerId, String keyword) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.apiUrl}report/invoices?page=$page&customer_id=$customerId&keyword=$keyword'),
        headers: _headers,
      );
      if (kDebugMode) {
        print('response invoices : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }
      return InvoiceResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> products(BuildContext context, int page) async {
    try {
      final response = await http.get(
        Uri.parse('${Configuration.apiUrl}product?page=$page'),
        headers: _headers,
      );
      if (kDebugMode) {
        print('response product : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }
      return ProductResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e,s) {
      if (kDebugMode) {
        print(s);
      }
      return e.toString();
    }
  }

  static Future<Object> search(
      BuildContext context, int page, String keywords) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.apiUrl}product/search?page=$page&keywords=$keywords'),
        headers: _headers,
      );
      if (kDebugMode) {
        print('response search : ${response.body}');
      }
      return ProductResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> reportDetail(
      BuildContext context, String id) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Configuration.apiUrl}report/detail/$id'),
        headers: _headers,
      );
      if (kDebugMode) {
        print('response report-detail : ${response.body}');
      }
      return ReportDetailResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> addReport(
      BuildContext context, List<File> files, ReportBody body) async {
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse('${Configuration.apiUrl}report/add'));
      request.headers.addAll(_headers);
      if (files.isNotEmpty) {
        for (var e in files) {
         http.MultipartFile.fromPath(
            'images[]',
            e.path,
          ).then((e) {

         }).catchError((e) {

         });
          request.files.add(await http.MultipartFile.fromPath(
            'images[]',
            e.path,
          ));
        }
      }
      request.fields['pay_date'] = body.payDate.toString();
      request.fields['store_name'] = body.storeName;
      request.fields['invoice'] = jsonEncode(body.invoice.map((i) => i.toJson()).toList());
      request.fields['payment_method'] = body.paymentMethod;
      request.fields['no_giro'] = body.noGiro;
      request.fields['giro_date'] = body.giroDate.toString();
      request.fields['bank_name'] = body.bankName;
      request.fields['amount'] = body.amount.toString();
      request.fields['note'] = body.note;

      final response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        var jsonBody = jsonDecode(responseToString);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return ReportDetailResponse.fromJson(jsonBody as Map<String, dynamic>);
      } else if (response.statusCode == 422) {
        var responseData = await response.stream.toBytes();
        var responseToString = String.fromCharCodes(responseData);
        var jsonBody = jsonDecode(responseToString);
        if (kDebugMode) {
          print('response add : $responseToString');
        }
        return ReportDetailResponse.fromJson(jsonBody as Map<String, dynamic>);
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

  static Future<Object> checkStatus(BuildContext context, String versionCode) async {
    try {
      final response = await http.get(
          Uri.parse('${Configuration.apiUrl}auths/check?version_app=$versionCode'),
          headers: _headers);
      if (kDebugMode) {
        print('response check : ${response.body}');
      }

      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (e) => false);
        }
      }
      return CheckStatusResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> changePw(BuildContext context,String password) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}auths/change-pw'),
          headers: _headers,
          body: {'password': password});
      if (kDebugMode) {
        print('response change pw : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const LoginScreen()), (
              e) => false);
        }
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> changePw2(String password, String email) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}auth/change-pw'),
          headers: _headers,
          body: {'password': password, 'email': email});
      if (kDebugMode) {
        print('response change pw : ${response.body}');
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
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
          Uri.parse('${Configuration.apiUrl}auths/logout'),
          headers: _headers);
      if (kDebugMode) {
        print('response logout : ${response.body}');
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> verifyPin(BuildContext context,String pin) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}auths/verify-pin'),
          headers: _headers,
          body: {'pin': pin});
      if (kDebugMode) {
        print('response verify pin : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const LoginScreen()), (
              e) => false);
        }
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> createPin(BuildContext context,String pin) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}auths/create-pin'),
          headers: _headers,
          body: {'pin': pin});
      if (kDebugMode) {
        print('response create pin : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const LoginScreen()), (
              e) => false);
        }
      }
      return CreatePinResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> sendOtpEmail(String email) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}auth/send-otp-email'),
          headers: _headers,
          body: {'email': email});
      if (kDebugMode) {
        print('response send otp : ${response.body}');
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> verifyOTP(String otp, String email) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}auth/verify-otp'),
          headers: _headers,
          body: {'otp': otp, 'email': email});
      if (kDebugMode) {
        print('response verify otp : ${response.body}');
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> checkEmail(String email) async {
    try {
      final response = await http.post(
          Uri.parse('${Configuration.apiUrl}auth/check-email'),
          headers: _headers,
          body: {'email': email});
      if (kDebugMode) {
        print('response check email : ${response.body}');
      }
      return DefaultResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> receipts(BuildContext context, int page, String search,String sort, String start, String end) async {
    try {
      final response = await http
          .get(Uri.parse('${Configuration.apiUrl}sales-canvasser/receipt?page=$page&search=$search&sort=$sort&start=$start&end=$end'), headers: _headers);
      if (kDebugMode) {
        print('response tanda_terima : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (e) => false);
        }
      }
      return ReceiptsResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }
  static Future<Object> listProduct(BuildContext context, String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('${Configuration.apiUrl}sales-canvasser/list-product?keyword=$keyword'),
        headers: _headers,
      );
      if (kDebugMode) {
        print('response list barang : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (e) => false);
        }
      }
      return ListProductResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  static Future<Object> addReceipt(BuildContext context, ReceiptBody body) async {
    try {
      final response = await http.post(
        Uri.parse('${Configuration.apiUrl}sales-canvasser/receipt/add'),
        headers: _headers,
        body:body.toJson()
      );
      if (kDebugMode) {
        print('response add receipt : ${response.body}');
      }
      if (response.statusCode == 401) {
        Preferences.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (e) => false);
        }
      }
      return AddReceiptResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }
}
