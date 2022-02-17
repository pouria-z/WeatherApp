import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/forecast_weather.dart';
import 'package:weather_app/models/loc_current_weather.dart';
import 'package:weather_app/models/loc_forecast_weather.dart';
import 'package:weather_app/screens/location.dart';
import 'package:weather_app/widgets/widgets.dart';
import 'package:weather_app/screens/home.dart';
import 'package:weather_app/key.dart';

class Weather with ChangeNotifier {
  String apiUrl = "https://api.weatherbit.io/v2.0/";
  late Uri url = Uri.parse("");

  var lat;
  var lon;

  bool gpsIsOn = false;

  Future getLocation() async {
    Position? position;
    if (Platform.isIOS) {
      GeolocatorPlatform.instance.requestPermission();
    }
    // Geolocator.requestPermission();
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print(e);
    }

    if (position != null) {
      lat = position.latitude;
      lon = position.longitude;
    }
    notifyListeners();
  }

  Future<LocCurrentWeatherModel>? locCurrentWeatherModel;
  LocCurrentWeatherModel? locCurrentModel;

  Future<LocCurrentWeatherModel> locCurrentWeather() async {
    url = Uri.parse("${apiUrl}current?lat=$lat&lon=$lon&key=$apiKey");
    var local = Uri.parse("http://192.168.1.8:1010/current");
    Response response = await get(local);
    var json = jsonDecode(response.body);
    locCurrentModel = LocCurrentWeatherModel.fromJson(json);
    refreshController.refreshCompleted();
    notifyListeners();
    return locCurrentModel!;
  }

  List locForecastDate = [];
  Future<LocForecastWeatherModel>? locForecastWeatherModel;
  LocForecastWeatherModel? locForecastModel;

  Future<LocForecastWeatherModel> locForecastWeather() async {
    final DateFormat formatter = DateFormat('EEE, MMM d');
    url = Uri.parse("${apiUrl}forecast/daily?lat=$lat&lon=$lon&key=$apiKey");
    var local = Uri.parse("http://192.168.1.8:1010/forecast");
    Response response = await get(local);
    var json = jsonDecode(response.body);
    locForecastModel = LocForecastWeatherModel.fromJson(json);
    for (var i = 0; i < locForecastModel!.data.length; i++) {
      locForecastDate.add(formatter.format(locForecastModel!.data[i].dateTime!));
    }
    locForecastDate[0] = 'Today';
    locForecastDate[1] = 'Tomorrow';
    refreshController.refreshCompleted();
    notifyListeners();
    return locForecastModel!;
  }

  Future<CurrentWeatherModel>? currentWeatherModel;
  CurrentWeatherModel? currentModel;

  Future<CurrentWeatherModel> currentWeather() async {
    Uri canadaCurrentUrl =
        Uri.parse("${apiUrl}current?city=${textEditingController.text}&country=CA&key=$apiKey");
    Uri currentUrl = Uri.parse("${apiUrl}current?city=${textEditingController.text}&key=$apiKey");
    url = textEditingController.text == "Montreal" ||
            textEditingController.text == "Montréal" ||
            textEditingController.text == "Vancouver" ||
            textEditingController.text == "Toronto"
        ? canadaCurrentUrl
        : currentUrl;
    Response response = await get(url);
    var json = jsonDecode(response.body);
    currentModel = CurrentWeatherModel.fromJson(json);
    refreshController.refreshCompleted();
    notifyListeners();
    return currentModel!;
  }

  Future<ForecastWeatherModel>? forecastWeatherModel;
  ForecastWeatherModel? forecastModel;
  List forecastDate = [];

  Future<ForecastWeatherModel> forecastWeather() async {
    final DateFormat formatter = DateFormat('EEE, MMM d');
    Uri canadaForecastUrl = Uri.parse(
        "${apiUrl}forecast/daily?city=${textEditingController.text}&country=CA&key=$apiKey");
    Uri forecastUrl =
        Uri.parse("${apiUrl}forecast/daily?city=${textEditingController.text}&key=$apiKey");
    url = textEditingController.text == "Montreal" ||
            textEditingController.text == "Montréal" ||
            textEditingController.text == "Vancouver" ||
            textEditingController.text == "Toronto"
        ? canadaForecastUrl
        : forecastUrl;
    Response response = await get(url);
    var json = jsonDecode(response.body);
    forecastModel = ForecastWeatherModel.fromJson(json);
    for (var i = 0; i < forecastModel!.data!.length; i++) {
      forecastDate.add(formatter.format(forecastModel!.data![i].dateTime!));
    }
    forecastDate[0] = 'Today';
    forecastDate[1] = 'Tomorrow';
    refreshController.refreshCompleted();
    notifyListeners();
    return forecastModel!;
  }
}
