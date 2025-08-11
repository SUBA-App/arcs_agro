import 'package:package_info_plus/package_info_plus.dart';

class Configuration {
  static String _baseUrl = '';
  static String apiUrl = '';
  static String buildNumber = '0';
  static String version = '';

  static Future<void> current() async {
    final packageInfo = await PackageInfo.fromPlatform();

    switch (packageInfo.packageName) {
      case "com.subagro.salesreport":
        _baseUrl =  'https://salesreport.subagro.com/';
       apiUrl = '${_baseUrl}api/';
       buildNumber = packageInfo.buildNumber;
       version = packageInfo.version;
        break;
      case "com.subagro.salesreport.debug":
        _baseUrl =  'https://salesreport-development.subagro.com/';
        apiUrl = '${_baseUrl}api/';
        buildNumber = packageInfo.buildNumber;
        version = packageInfo.version;
        break;

      default:
        break;
    }
  }
}
