import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/favorite_models/favorite_details_current.dart';
import 'package:weather_app/models/favorite_models/favorite_details_forecast.dart';
import 'package:weather_app/models/searched_models/current_weather.dart';
import 'package:weather_app/models/favorite_models/favorites_weather.dart';
import 'package:weather_app/models/searched_models/forecast_weather.dart';
import 'package:weather_app/models/location_models/loc_current_weather.dart';
import 'package:weather_app/models/location_models/loc_forecast_weather.dart';
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
    await Geolocator.requestPermission();
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print("could not get location");
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
    Response response = await get(url);
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
    Response response = await get(url);
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
    await setFavorite();
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

  Set<String>? favorites;
  bool isFavorite = false;

  Future getFavoritesList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    favorites = preferences.getKeys();
    notifyListeners();
  }

  Future setFavorite() async {
    if (url.toString().contains("city")) {
      if (favorites!.contains(currentModel!.data![0].cityName)) {
        isFavorite = true;
        notifyListeners();
      } else {
        isFavorite = false;
        favoritesModelList.remove(favoritesModel);
        notifyListeners();
      }
    }
  }

  Future setFavoriteInDetails() async {
    if (favorites!.contains(favoriteDetailsCurrentModel!.data![0].cityName)) {
      isFavorite = true;
      notifyListeners();
    } else {
      isFavorite = false;
      favoritesModelList.remove(favoritesModel);
      notifyListeners();
    }
  }

  Future<FavoritesWeatherModel>? favoritesWeatherModel;
  FavoritesWeatherModel? favoritesModel;
  List<FavoritesWeatherModel> favoritesModelList = [];

  Future<FavoritesWeatherModel> getAllFavoritesWeather(String city) async {
    Uri canadaCurrentUrl = Uri.parse("${apiUrl}current?city=$city&country=CA&key=$apiKey");
    Uri currentUrl = Uri.parse("${apiUrl}current?city=$city&key=$apiKey");
    var url = city == "Montreal" || city == "Montréal" || city == "Vancouver" || city == "Toronto"
        ? canadaCurrentUrl
        : currentUrl;
    var local = Uri.parse("http://192.168.1.8:1010/current");
    Response response = await get(url);
    var json = jsonDecode(response.body);
    print(json);
    favoritesModel = FavoritesWeatherModel.fromJson(json);
    favoritesModelList.add(favoritesModel!);
    notifyListeners();
    return favoritesModel!;
  }

  Future<FavoriteDetailsCurrentModel>? favoriteDetailsCurrentWeatherModel;
  FavoriteDetailsCurrentModel? favoriteDetailsCurrentModel;

  Future<FavoriteDetailsCurrentModel> favoriteDetailsCurrent(String city) async {
    Uri canadaCurrentUrl = Uri.parse("${apiUrl}current?city=$city&country=CA&key=$apiKey");
    Uri currentUrl = Uri.parse("${apiUrl}current?city=$city&key=$apiKey");
    var url = city == "Montreal" || city == "Montréal" || city == "Vancouver" || city == "Toronto"
        ? canadaCurrentUrl
        : currentUrl;
    Response response = await get(url);
    var json = jsonDecode(response.body);
    favoriteDetailsCurrentModel = FavoriteDetailsCurrentModel.fromJson(json);
    notifyListeners();
    return favoriteDetailsCurrentModel!;
  }

  Future<FavoriteDetailsForecastModel>? favoriteDetailsForecastWeatherModel;
  FavoriteDetailsForecastModel? favoriteDetailsForecastModel;
  List favoriteForecastDate = [];

  Future<FavoriteDetailsForecastModel> favoriteDetailsForecast(String city) async {
    final DateFormat formatter = DateFormat('EEE, MMM d');
    Uri canadaForecastUrl = Uri.parse("${apiUrl}forecast/daily?city=$city&country=CA&key=$apiKey");
    Uri forecastUrl = Uri.parse("${apiUrl}forecast/daily?city=$city&key=$apiKey");
    var url = city == "Montreal" || city == "Montréal" || city == "Vancouver" || city == "Toronto"
        ? canadaForecastUrl
        : forecastUrl;
    Response response = await get(url);
    var json = jsonDecode(response.body);
    favoriteDetailsForecastModel = FavoriteDetailsForecastModel.fromJson(json);
    for (var i = 0; i < favoriteDetailsForecastModel!.data!.length; i++) {
      favoriteForecastDate.add(formatter.format(favoriteDetailsForecastModel!.data![i].dateTime!));
    }
    favoriteForecastDate[0] = 'Today';
    favoriteForecastDate[1] = 'Tomorrow';
    notifyListeners();
    return favoriteDetailsForecastModel!;
  }

  List<bool> isSelected = List.generate(500, (index) => false);
  List<String> selectedCities = List.generate(500, (index) => "");
}
