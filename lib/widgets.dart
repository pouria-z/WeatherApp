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
  final icon;
  final temp;
  final desc;
  final wind;
  final code;
  LocCurrentWeather(this.icon, this.temp, this.desc, this.wind, this.code);

  // factory LocCurrentWeather.fromJson(Map<String, dynamic> json) {
  //   return LocCurrentWeather(
  //     json['data'][0]['weather']['icon'],
  //     json['data'][0]['temp'],
  //     json['data'][0]['weather']['description'],
  //     json['data'][0]['wind_spd'],
  //     json['data'][0]['weather']['code'],
  //   );
  // }

}

class ForecastItems {
  var city;
  var icon;
  var temp;
  var minTemp;
  var maxTemp;
  var date;

  ForecastItems(this.city, this.icon, this.temp, this.minTemp, this.maxTemp,
      this.date);
}

class LocForecastWeather {
  final List list;
  LocForecastWeather(this.list);

  factory LocForecastWeather.fromJson(Map<String, dynamic> json){
    List list = [];
    for (dynamic e in json['data']){
      ForecastItems forecastItems = ForecastItems(
        json['city_name'],
        e['weather']['icon'],
        e['temp'],
        json['data'][0]['min_temp'],
        json['data'][0]['max_temp'],
        e['datetime'],
      );
      list.add(forecastItems);
    }
    return LocForecastWeather(list);
  }

}










