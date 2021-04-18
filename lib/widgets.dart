import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const myTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontFamily: 'Roboto',
);
const myTextStyleBold = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
);

class LocCurrentWeather {
  String icon;
  double temp;
  String desc;
  double wind;
  int code;
  LocCurrentWeather(this.icon, this.temp, this.desc, this.wind, this.code);
}

class LocForecastWeather {
  String city;
  String icon;
  double temp;
  double minTemp;
  double maxTemp;
  String desc;
  var date;
  LocForecastWeather(this.city, this.icon, this.temp, this.minTemp,
      this.maxTemp, this.desc, this.date);
}










