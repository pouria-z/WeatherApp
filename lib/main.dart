import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/get_location.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GetLocationWidget(),
        theme: ThemeData.dark().copyWith(

        ),
      ),
  );
}

