import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/configuration.dart';
import 'package:sales_app/font_color.dart';

import 'package:sales_app/screen/absensi/absensi_provider.dart';
import 'package:sales_app/screen/absensi/next_absensi_provider.dart';
import 'package:sales_app/screen/login_screen/forgot_password_screen/forgot_provider.dart';
import 'package:sales_app/screen/login_screen/login_provider.dart';
import 'package:sales_app/screen/login_screen/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sales_app/screen/main/main_provider.dart';
import 'package:sales_app/screen/main/otp_screen/otp_provider.dart';
import 'package:sales_app/screen/main/pin_screen/pin_provider.dart';
import 'package:sales_app/screen/main/pin_screen/pin_screen.dart';
import 'package:sales_app/screen/product/product_provider.dart';
import 'package:sales_app/screen/report/report_provider.dart';
import 'package:sales_app/util/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic alert',
            defaultColor: FontColor.yellow72,
            ledColor: Colors.white, importance: NotificationImportance.High)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: false
  );

  FlutterForegroundTask.initCommunicationPort();
  await Preferences.init();
  await Configuration.current();

  ApiService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => AbsensiProvider()),
      ChangeNotifierProvider(create: (_) => MainProvider()),
      ChangeNotifierProvider(create: (_) => ReportProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => NextAbsensiProvider()),
      ChangeNotifierProvider(create: (_) => OtpProvider()),
      ChangeNotifierProvider(create: (_) => PinProvider()),
      ChangeNotifierProvider(create: (_) => ForgotProvider()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: Preferences.token().isEmpty ? const LoginScreen() : (Preferences.getUser()?.hasPin ?? false) == true ? const PinScreen(mode: 3) :  const PinScreen(mode: 1),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
    );
  }
}

