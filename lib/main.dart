import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/home.dart';
import 'package:weather_app/key.dart';
import 'package:weather_app/services/notification.dart';
import 'package:weather_app/services/services.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print(
      "notification on background received! title: '${message.notification!.body}',"
      " body: '${message.notification!.body}'.");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    NotificationService.initialize();
    await NotificationService.createNotificationChannel();
  }
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    liveQueryUrl: serverUrl,
  );
  await getApiKey();
  await updateApiKey();
  FirebaseAnalytics.instance.logAppOpen();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Weather(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Weather App",
        home: HomePage(),
        theme: ThemeData.dark(),
      ),
    ),
  );
}
