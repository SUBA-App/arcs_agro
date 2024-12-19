import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sales_app/api/body/coordinate_body.dart';
import 'package:sales_app/util/preferences.dart';

import '../api/api_service.dart';

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
        eventAction: ForegroundTaskEventAction.repeat(10*60000),
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
    await Preferences.init();
    ApiService.init();
    final position = await _determinePosition();

    CoordinateBody body = CoordinateBody(position.latitude, position.longitude);

    await ApiService.updateCoordinate(body);
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }


  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {

  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    await updateCoordinate();
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