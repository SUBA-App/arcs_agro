import 'package:package_info_plus/package_info_plus.dart';

class Configuration {
  static String _baseUrl = '';
  static String apiUrl = '';

  static Future<void> current() async {
    final packageInfo = await PackageInfo.fromPlatform();

    switch (packageInfo.packageName) {
      case "com.subagro.salesreport":
        _baseUrl =  'https://salesreport.subagro.com/';
       apiUrl = '${_baseUrl}api/';
        break;
      case "com.subagro.salesreport.debug":
        _baseUrl =  'http://10.0.2.2:8000/';
        apiUrl = '${_baseUrl}api/';
        break;

      default:
        break;
    }
  }
}
