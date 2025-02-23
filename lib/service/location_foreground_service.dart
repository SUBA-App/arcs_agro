import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sales_app/api/body/coordinate_body.dart';
import 'package:sales_app/configuration.dart';
import 'package:sales_app/util/preferences.dart';

import '../api/api_service.dart';
import '../api/model/location_result.dart';

class LocationForegroundService {
  static void initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.once(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {

  late Timer _timer;

  Future<void> updateCoordinate() async {
    try {
      final result = await _determinePosition();

      if (result.type == 1) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              actionType: ActionType.KeepOnTop,
              //category: NotificationCategory.Alarm,
              title: 'Location Denied',
              body: 'Please Refer to sales app',
            )
        );
      } else if (result.type == 2) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              actionType: ActionType.KeepOnTop,
              //category: NotificationCategory.Alarm,
              title: 'Location Denied',
              body: 'Please Refer to sales app',
            )
        );
      } else if (result.type == 4) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              actionType: ActionType.KeepOnTop,
              //category: NotificationCategory.Alarm,
              title: 'Location Denied',
              body: 'Please Refer to sales app',
            )
        );
      } else {
        CoordinateBody body = CoordinateBody(
            result.position!.latitude, result.position!.longitude);
        await ApiService.updateCoordinate(body);
      }
    } catch(e) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            actionType: ActionType.KeepOnTop,
            //category: NotificationCategory.Alarm,
            title: 'Location Denied',
            body: 'Please Refer to sales app',
          )
      );
    }
  }

  Future<LocationResult> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult(
          type: 1, message: 'Location services are disabled.', position: null);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult(
            type: 2,
            message: 'Location permissions are denied',
            position: null);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult(
          type: 4,
          message:
          'Location permissions are permanently denied, we cannot request permissions.',
          position: null);
    }

    final position = await Geolocator.getCurrentPosition();

    return LocationResult(type: 3, message: '', position: position);
  }


  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await Preferences.init();
    await Configuration.current();
    ApiService.init();
    _timer = Timer.periodic(Duration(minutes: 10), (e) async {
      await updateCoordinate();
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    print('cc');

    FlutterForegroundTask.sendDataToMain({});
  }


  @override
  Future<void> onDestroy(DateTime timestamp) async {
    _timer.cancel();
  }

  @override
  void onReceiveData(Object data) {

  }


  @override
  void onNotificationButtonPressed(String id) {

  }
}