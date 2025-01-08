import 'package:package_info_plus/package_info_plus.dart';

class Configuration {
  static String _baseUrl = '';
  static String apiUrl = '';

  static String imageUrl = '';
  static String imageUrlPayment = '';

  static Future<void> current() async {
    final packageInfo = await PackageInfo.fromPlatform();

    switch (packageInfo.packageName) {
      case "com.example.sales_app":
        _baseUrl =  'https://weles.my.id/';
       apiUrl = '${_baseUrl}api/';
        imageUrl = '${_baseUrl}storage/images/absensi/';
        imageUrlPayment = '${_baseUrl}storage/images/payment/';
        break;
      case "com.example.sales_app.debug":
        _baseUrl =  'http://10.0.2.2:8000/';
        apiUrl = '${_baseUrl}api/';
        imageUrl = '${_baseUrl}storage/images/absensi/';
        imageUrlPayment = '${_baseUrl}storage/images/payment/';
        break;

      default:
        break;
    }
  }
}
