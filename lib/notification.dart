import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("ic_stat_name"),
    );
    _notificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    final id = DateTime.now().millisecondsSinceEpoch / 1000;

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "WeatherApp",
        "WeatherApp channel",
        importance: Importance.max,
        priority: Priority.max,
        color: Color(0xFF1E1B49),
      ),
    );

    await _notificationsPlugin.show(
      id.toInt(),
      message.notification.title,
      message.notification.body,
      notificationDetails,
    );
  }
}
