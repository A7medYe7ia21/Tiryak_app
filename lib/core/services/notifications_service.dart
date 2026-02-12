import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static int _badgeCounter = 0;
  static bool _permissionGranted = false;
  static bool get permissionGranted => _permissionGranted;
  static int get badge => _badgeCounter;

  bool get isInitialized => _initialized;

  static Future<void> initNotifications() async {
    if (_initialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationPlugin.initialize(initializationSettings);

    // iOS: Check current permissions
    if (Platform.isIOS) {
      final iosPlugin =
          _notificationPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      final bool? granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      _permissionGranted = granted ?? false;
    }

    // Android 13+: Request runtime permission
    if (Platform.isAndroid) {
      final androidPlugin =
          _notificationPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidPlugin?.requestNotificationsPermission();
      _permissionGranted = granted ?? false;
    }

    _initialized = true;
  }

  static NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily notifications for the app',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        showWhen: true,
        enableLights: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: ++_badgeCounter,
      ),
    );
  }

  static Future<void> resetBadge() async {
    _badgeCounter = 0;
    if (Platform.isIOS) {
      await _notificationPlugin.show(
        0,
        null,
        null,
        NotificationDetails(
          iOS: DarwinNotificationDetails(
            badgeNumber: 0,
            presentAlert: false,
            presentSound: false,
            presentBadge: true,
          ),
        ),
      );
    }
    await _notificationPlugin.cancelAll();
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await _notificationPlugin.show(id, title, body, _notificationDetails());
  }
}
