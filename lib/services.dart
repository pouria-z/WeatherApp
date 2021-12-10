import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets.dart';
import 'package:weather_app/home.dart';
import 'package:weather_app/key.dart';

class Weather with ChangeNotifier {
  Uri url;
  bool apiHasProblem = false;

  ///getLoc variables
  var lat;
  var lon;

  ///currentWeather variables
  var icon;
  var temp;
  var desc;
  var wind;
  var code;

  ///forecast variables
  var fCity;
  var fIcon;
  var fTemp;
  var fMinTemp;
  var fMaxTemp;
  var timestamp;
  var fDate;
  List fCityList = [];
  List fIconList = [];
  List fTempList = [];
  List fMinTempList = [];
  List fMaxTempList = [];
  List fDateList = [];
  bool gpsIsOn = false;

  Future getLocation() async {
    Position position;
    gpsIsOn = await Geolocator.isLocationServiceEnabled();
    try {
      gpsIsOn
          ? position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low)
          : Geolocator.openLocationSettings();
    } catch (e) {
      print(e);
    }

    if (position != null) {
      lat = position.latitude;
      lon = position.longitude;
    }
    notifyListeners();
  }

  Future locCurrentWeather() async {
    await getApiKey();
    apiHasProblem = false;
    url = Uri.parse(
        "https://api.weatherbit.io/v2.0/current?lat=$lat&lon=$lon&key=$apiKey");
    Response response = await get(url);
    if (response.statusCode == 403) {
      apiHasProblem = true;
      notifyListeners();
    } else {
      var json = jsonDecode(response.body);
      icon = json['data'][0]['weather']['icon'];
      temp = json['data'][0]['temp'].round();
      desc = json['data'][0]['weather']['description'];
      wind = json['data'][0]['wind_spd'].round();
      code = json['data'][0]['weather']['code'];
      refreshController.refreshCompleted();
    }
    notifyListeners();
  }

  Future locForecastWeather() async {
    apiHasProblem = false;
    url = Uri.parse(
        "https://api.weatherbit.io/v2.0/forecast/daily?lat=$lat&lon=$lon&key=$apiKey");
    Response response = await get(url);
    fCityList.clear();
    fIconList.clear();
    fTempList.clear();
    fMinTempList.clear();
    fMaxTempList.clear();
    fDateList.clear();
    if (response.statusCode == 403) {
      apiHasProblem = true;
      notifyListeners();
    } else {
      var json = jsonDecode(response.body);
      final DateFormat formatter = DateFormat('EEE, MMM d');
      for (var item in json['data']) {
        fCity = json['city_name'];
        fIcon = item['weather']['icon'];
        fTemp = item['temp'].round();
        fMinTemp = json['data'][0]['min_temp'].round() - 2;
        fMaxTemp = json['data'][0]['max_temp'].round().toInt() + 2;
        timestamp = item['ts'];
        var time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        fDate = formatter.format(time);
        fCityList.add(fCity);
        fIconList.add(fIcon);
        fTempList.add(fTemp);
        fMinTempList.add(fMinTemp);
        fMaxTempList.add(fMaxTemp);
        fDateList.add(fDate);
      }
      fDateList[0] = 'Today';
      fDateList[1] = 'Tomorrow';
      refreshController.refreshCompleted();
    }
    notifyListeners();
  }

  Future currentWeather() async {
    await getApiKey();
    apiHasProblem = false;
    Uri canadaCurrentUrl = Uri.parse(
        "https://api.weatherbit.io/v2.0/forecast/daily?city=${cityName.text}&country=CA&key=$apiKey");
    Uri currentUrl = Uri.parse(
        "https://api.weatherbit.io/v2.0/current?city=${cityName.text}&key=$apiKey");
    url = cityName.text == "Montreal" ||
            cityName.text == "Montréal" ||
            cityName.text == "Vancouver" ||
            cityName.text == "ونکوور" ||
            cityName.text == "Toronto"
        ? canadaCurrentUrl
        : currentUrl;
    Response response = await get(url);
    if (response.statusCode == 403) {
      apiHasProblem = true;
      notifyListeners();
    } else {
      var json = jsonDecode(response.body);
      icon = json['data'][0]['weather']['icon'];
      temp = json['data'][0]['temp'].round();
      desc = json['data'][0]['weather']['description'];
      wind = json['data'][0]['wind_spd'].round();
      code = json['data'][0]['weather']['code'];
      refreshController.refreshCompleted();
    }
    notifyListeners();
  }

  Future forecastWeather() async {
    apiHasProblem = false;
    Uri canadaForecastUrl = Uri.parse(
        "https://api.weatherbit.io/v2.0/forecast/daily?city=${cityName.text}&country=CA&key=$apiKey");
    Uri forecastUrl = Uri.parse(
        "https://api.weatherbit.io/v2.0/forecast/daily?city=${cityName.text}&key=$apiKey");
    url = cityName.text == "Montreal" ||
            cityName.text == "Montréal" ||
            cityName.text == "Vancouver" ||
            cityName.text == "ونکوور"
        ? canadaForecastUrl
        : forecastUrl;
    Response response = await get(url);
    fCityList.clear();
    fIconList.clear();
    fTempList.clear();
    fMinTempList.clear();
    fMaxTempList.clear();
    fDateList.clear();
    if (response.statusCode == 403) {
      apiHasProblem = true;
      notifyListeners();
    } else {
      var json = jsonDecode(response.body);
      final DateFormat formatter = DateFormat('EEE, MMM d');
      for (var item in json['data']) {
        fCity = json['city_name'];
        fIcon = item['weather']['icon'];
        fTemp = item['temp'].round();
        fMinTemp = json['data'][0]['min_temp'].round().toInt() - 2;
        fMaxTemp = json['data'][0]['max_temp'].round().toInt() + 2;
        timestamp = item['ts'];
        var time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        fDate = formatter.format(time);
        fCityList.add(fCity);
        fIconList.add(fIcon);
        fTempList.add(fTemp);
        fMinTempList.add(fMinTemp);
        fMaxTempList.add(fMaxTemp);
        fDateList.add(fDate);
      }
      fDateList[0] = 'Today';
      fDateList[1] = 'Tomorrow';
      refreshController.refreshCompleted();
    }
    notifyListeners();
  }

  String imageAsset() {
    if (code.toString() == "700" ||
        code.toString() == "711" ||
        code.toString() == "721" ||
        code.toString() == "731" ||
        code.toString() == "741" ||
        code.toString() == "751") {
      return 'assets/images/mist.jpg';
    } else if (code.toString() == "801" ||
        code.toString() == "802" ||
        code.toString() == "803" ||
        code.toString() == "804") {
      return 'assets/images/cloud.jpg';
    } else if (code.toString() == "600" ||
        code.toString() == "601" ||
        code.toString() == "602" ||
        code.toString() == "610" ||
        code.toString() == "611" ||
        code.toString() == "612" ||
        code.toString() == "621" ||
        code.toString() == "622") {
      return 'assets/images/snow.jpg';
    } else if (code.toString() == "500" ||
        code.toString() == "501" ||
        code.toString() == "502" ||
        code.toString() == "511" ||
        code.toString() == "520" ||
        code.toString() == "521" ||
        code.toString() == "522") {
      return 'assets/images/rain.jpg';
    } else if (code.toString() == "800" && icon.toString() == "c01d") {
      return 'assets/images/cleard.jpg';
    } else if (code.toString() == "800" && icon.toString() == "c01n") {
      return 'assets/images/clearn.jpg';
    } else if (code.toString() == "300" ||
        code.toString() == "301" ||
        code.toString() == "302") {
      return 'assets/images/drizzle.jpg';
    } else if (code.toString() == "200" ||
        code.toString() == "201" ||
        code.toString() == "202" ||
        code.toString() == "230" ||
        code.toString() == "231" ||
        code.toString() == "232" ||
        code.toString() == "233") {
      return 'assets/images/thunderstorm.jpg';
    } else {
      return null;
    }
  }
}
