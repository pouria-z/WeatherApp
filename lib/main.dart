import 'package:flutter/material.dart';
import 'package:weather_app/home.dart';
import 'package:weather_app/key.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  await getApiKey();
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

