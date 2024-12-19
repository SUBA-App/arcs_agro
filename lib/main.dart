import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/api/api_service.dart';

import 'package:sales_app/list_product_screen.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/absensi/next_absensi_provider.dart';
import 'package:sales_app/screen/login_screen/login_provider.dart';
import 'package:sales_app/screen/login_screen/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sales_app/screen/main/main_page.dart';
import 'package:sales_app/screen/main/main_provider.dart';
import 'package:sales_app/screen/product/product_provider.dart';
import 'package:sales_app/screen/report/report_provider.dart';
import 'package:sales_app/util/preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  await Preferences.init();
  ApiService.init();


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => AbsensiProvider()),
      ChangeNotifierProvider(create: (_) => MainProvider()),
      ChangeNotifierProvider(create: (_) => ReportProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => NextAbsensiProvider()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        canvasColor: Colors.white,
        useMaterial3: true,
      ),
      home: Preferences
          .token()
          .isEmpty ? LoginScreen() : MainPage(),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
    );
  }
}

