import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/forecast_weather.dart';
import 'package:weather_app/models/loc_current_weather.dart';
import 'package:weather_app/models/loc_forecast_weather.dart';
import 'package:weather_app/services/notification.dart';
import 'package:weather_app/services/services.dart';
import 'package:weather_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

RefreshController refreshController = RefreshController(initialRefresh: false);

class LocationPage extends StatefulWidget {
  @override
  _LocationPage createState() => _LocationPage();
}

class _LocationPage extends State<LocationPage> with AutomaticKeepAliveClientMixin {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  String imageAsset() {
    var weather = Provider.of<Weather>(context, listen: false);
    if (weather.url.toString().contains("city")) {
      return weather.currentModel!.data![0].weatherModel!.imageAsset();
    } else {
      return weather.locCurrentModel!.data[0].weatherModel!.imageAsset();
    }
  }

  @override
  void initState() {
    super.initState();
    var weather = Provider.of<Weather>(context, listen: false);
    FirebaseMessaging.onMessage.listen((message) {
      NotificationService.display(message);
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await analytics.setCurrentScreen(screenName: "location_screen");
      // await weather.getLocation();
      await weather.favoritesList();
      weather.locCurrentWeatherModel = weather.locCurrentWeather().whenComplete(() async {
        print("calling api");
        await weather.getFavorites();
      });
      weather.locForecastWeatherModel = weather.locForecastWeather();
      print(weather.isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var weather = Provider.of<Weather>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                "Exit App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Are you sure you want to exit from app?",
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      color: Color(0xFFEF233C),
                    ),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          },
        ).then((value) => value as bool);
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<Weather>(
            builder: (context, value, child) {
              return SmartRefresher(
                physics: BouncingScrollPhysics(),
                onRefresh: () async {
                  if (weather.url.toString().contains('city')) {
                    weather.currentWeatherModel = weather.currentWeather();
                    weather.forecastWeatherModel = weather.forecastWeather();
                  } else {
                    await sendRequest(
                      weather,
                      weather.getLocation(),
                    );
                    weather.locCurrentWeatherModel = weather.locCurrentWeather();
                    weather.locForecastWeatherModel = weather.locForecastWeather();
                  }
                },
                controller: refreshController,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SearchBox(
                        locIcon: weather.url.toString().contains('city')
                            ? IconButton(
                                icon: Icon(
                                  Iconsax.location,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    showClear = false;
                                    textEditingController.text = "";
                                  });
                                  await sendRequest(
                                    weather,
                                    weather.getLocation(),
                                  );
                                  weather.locCurrentWeatherModel = weather.locCurrentWeather();
                                  weather.locForecastWeatherModel = weather.locForecastWeather();
                                },
                                splashRadius: 20,
                              )
                            : Container(),
                        sizedBoxWidth: weather.url.toString().contains('city') ? 7.0 : 0.0,
                        offset: weather.url.toString().contains('city') ? -113.0 : -58.0,

                        ///SuggestionSelected
                        onSuggestionSelected: (suggestion) async {
                          analytics.logEvent(
                              name: "clicked_on_suggestion", parameters: {'city': '$suggestion'});
                          textEditingController.text = suggestion;
                          weather.currentWeatherModel = weather.currentWeather();
                          weather.forecastWeatherModel = weather.forecastWeather();
                        },

                        ///onSubmitted
                        onSubmitted: (value) async {
                          if (textEditingController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please enter city name"),
                              ),
                            );
                          } else {
                            analytics.logEvent(
                                name: "searched_by_keyboard",
                                parameters: {'city': '${textEditingController.text}'});
                            weather.currentWeatherModel = weather.currentWeather();
                            weather.forecastWeatherModel = weather.forecastWeather();
                          }
                        },
                        favoriteWidget: weather.url.toString().contains("city")
                            ? IconButton(
                                onPressed: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  var city = weather.currentModel!.data![0].cityName;
                                  if (!weather.isFavorite) {
                                    print("not in faves");
                                    await preferences.setString("$city", "$city");
                                    print("$city saved successfully!");
                                    await weather.getFavorites();
                                  } else {
                                    print("already in faves");
                                    preferences.remove("$city");
                                    print("$city removed successfully!");
                                    await weather.getFavorites();
                                  }
                                },
                                icon: Icon(
                                  weather.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                                  color: weather.isFavorite
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white,
                                ),
                              )
                            : Container(),
                      ),
                      weather.url.toString().contains('city')
                          ? FutureBuilder<CurrentWeatherModel>(
                              future: weather.currentWeatherModel,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: (MediaQuery.of(context).size.height / 2) -
                                            AppBar().preferredSize.height,
                                      ),
                                      Text("Something went wrong! Please try again later."),
                                      IconButton(
                                        onPressed: () async {
                                          weather.currentWeatherModel = weather.currentWeather();
                                          weather.forecastWeatherModel = weather.forecastWeather();
                                        },
                                        icon: Icon(
                                          Icons.refresh_rounded,
                                          color: Colors.white54,
                                        ),
                                        splashRadius: 20,
                                      )
                                    ],
                                  );
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return TopLoading();
                                } else if (snapshot.hasData) {
                                  var currentData = snapshot.data!.data![0];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    child: Column(
                                      children: [
                                        CurrentWeatherWidget(
                                          imagePath: imageAsset(),
                                          cityName: currentData.cityName,
                                          url: weather.url,
                                          temperature: currentData.temp,
                                          iconPath: currentData.weatherModel!.icon,
                                          description: currentData.weatherModel!.description,
                                        ),
                                        FutureBuilder<ForecastWeatherModel>(
                                          future: weather.forecastWeatherModel,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return BottomLoading();
                                            } else if (snapshot.hasData) {
                                              var forecastData = snapshot.data!.data![0];
                                              return Column(
                                                children: [
                                                  ListTiles(
                                                    minTemp: forecastData.minTemp != null
                                                        ? forecastData.minTemp.toString() + "°"
                                                        : "",
                                                    maxTemp: forecastData.maxTemp != null
                                                        ? forecastData.maxTemp.toString() + "°"
                                                        : "",
                                                    wind: currentData.windSpd != null
                                                        ? currentData.windSpd.toString() + " km/h"
                                                        : "",
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context).size.height / 4.5,
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      physics: BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data!.data!.length,
                                                      itemBuilder: (context, index) {
                                                        var item = snapshot.data!.data![index];
                                                        return ForecastCard(
                                                          date: weather.forecastDate[index],
                                                          temp: item.temp,
                                                          icon: item.weatherModel!.icon,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          : FutureBuilder<LocCurrentWeatherModel>(
                              future: weather.locCurrentWeatherModel,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.stackTrace);
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: (MediaQuery.of(context).size.height / 2) -
                                            AppBar().preferredSize.height,
                                      ),
                                      Text("Something went wrong! Please try again later."),
                                      IconButton(
                                        onPressed: () async {
                                          weather.locCurrentWeatherModel =
                                              weather.locCurrentWeather();
                                          weather.locForecastWeatherModel =
                                              weather.locForecastWeather();
                                        },
                                        icon: Icon(
                                          Icons.refresh_rounded,
                                          color: Colors.white54,
                                        ),
                                        splashRadius: 20,
                                      )
                                    ],
                                  );
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return TopLoading();
                                } else if (snapshot.hasData) {
                                  var currentData = snapshot.data!.data[0];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    child: Column(
                                      children: [
                                        CurrentWeatherWidget(
                                          imagePath: imageAsset(),
                                          cityName: currentData.cityName,
                                          url: weather.url,
                                          temperature: currentData.temp,
                                          iconPath: currentData.weatherModel!.icon,
                                          description: currentData.weatherModel!.description,
                                        ),
                                        FutureBuilder<LocForecastWeatherModel>(
                                          future: weather.locForecastWeatherModel,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return BottomLoading();
                                            } else if (snapshot.hasData) {
                                              var forecastData = snapshot.data!.data[0];
                                              return Column(
                                                children: [
                                                  ListTiles(
                                                    minTemp: forecastData.minTemp != null
                                                        ? forecastData.minTemp.toString() + "°"
                                                        : "",
                                                    maxTemp: forecastData.maxTemp != null
                                                        ? forecastData.maxTemp.toString() + "°"
                                                        : "",
                                                    wind: currentData.windSpd != null
                                                        ? currentData.windSpd.toString() + " km/h"
                                                        : "",
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context).size.height / 4.5,
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      physics: BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data!.data.length,
                                                      itemBuilder: (context, index) {
                                                        var item = snapshot.data!.data[index];
                                                        return ForecastCard(
                                                          date: weather.locForecastDate[index],
                                                          temp: item.temp,
                                                          icon: item.weatherModel!.icon,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                      SizedBox(
                        height: kBottomNavigationBarHeight,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> sendRequest(Weather weather, Future future) async {
    try {
      await future.timeout(Duration(seconds: 15));
    } on TimeoutException catch (e) {
      setState(() {
        refreshController.refreshFailed();
      });
      throw e;
    } on SocketException catch (e) {
      setState(() {
        refreshController.refreshFailed();
      });
      throw e;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
