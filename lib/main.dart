import 'package:flutter/material.dart';
import 'package:weather_app/home.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Weather(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: ThemeData.dark(),
      ),
    ),
  );
}

