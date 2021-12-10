import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/services.dart';
import 'package:weather_app/widgets.dart';
import 'package:provider/provider.dart';

RefreshController refreshController = RefreshController(initialRefresh: false);

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    var weather = Provider.of<Weather>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await weather.getLocation();
      await weather.locCurrentWeather();
      await weather.locForecastWeather();
    });
  }

  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    var weather = Provider.of<Weather>(context, listen: false);
    var size = MediaQuery.of(context).size;
    var area = (size.height) * (size.width);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Exit App",
                style: myTextStyleBold,
              ),
              content: Text(
                "Are you sure you want to exit from app?",
                style: myTextStyle.copyWith(color: Colors.white54),
              ),
              actions: [
                TextButton(
                  child: Text("No", style: myTextStyle),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    "Yes",
                    style: myTextStyle.copyWith(color: Colors.red),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<Weather>(
            builder: (context, value, child) {
              return SmartRefresher(
                onRefresh: () async {
                  setState(() {
                    hasError = false;
                  });
                  if (weather.url.toString().contains('city')) {
                    await sendRequest(
                      weather,
                      weather.currentWeather(),
                    );
                    await sendRequest(
                      weather,
                      weather.forecastWeather(),
                    );
                  } else {
                    await sendRequest(
                      weather,
                      weather.getLocation(),
                    );
                    await sendRequest(
                      weather,
                      weather.locCurrentWeather(),
                    );
                    await sendRequest(
                      weather,
                      weather.locForecastWeather(),
                    );
                  }
                },
                controller: refreshController,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SearchBox(
                        locIcon: weather.url.toString().contains('city')
                            ? IconButton(
                                icon: Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    hasError = false;
                                    showClear = false;
                                    cityName.text = "";
                                  });
                                  weather.timestamp = null;
                                  weather.fCityList.clear();
                                  weather.fDateList.clear();
                                  weather.fTempList.clear();
                                  weather.fIconList.clear();
                                  await sendRequest(
                                    weather,
                                    weather.getLocation(),
                                  );
                                  await sendRequest(
                                    weather,
                                    weather.locCurrentWeather(),
                                  );
                                  await sendRequest(
                                    weather,
                                    weather.locForecastWeather(),
                                  );
                                },
                                splashRadius: 20,
                              )
                            : Container(),
                        sizedBoxWidth:
                            weather.url.toString().contains('city') ? 7.0 : 0.0,
                        offset: weather.url.toString().contains('city')
                            ? -113.0
                            : -58.0,

                        ///SuggestionSelected
                        onSuggestionSelected: (suggestion) async {
                          setState(() {
                            hasError = false;
                          });
                          weather.timestamp = null;
                          weather.fCityList.clear();
                          weather.fDateList.clear();
                          weather.fTempList.clear();
                          weather.fIconList.clear();
                          cityName.text = suggestion;
                          await sendRequest(
                            weather,
                            weather.currentWeather(),
                          );
                          await sendRequest(
                            weather,
                            weather.forecastWeather(),
                          );
                        },

                        ///onSubmitted
                        onSubmitted: (value) async {
                          if (cityName.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please enter city name"),
                              ),
                            );
                          } else {
                            setState(() {
                              hasError = false;
                            });
                            weather.timestamp = null;
                            weather.fCityList.clear();
                            weather.fDateList.clear();
                            weather.fTempList.clear();
                            weather.fIconList.clear();
                            await sendRequest(
                              weather,
                              weather.currentWeather(),
                            );
                            await sendRequest(
                              weather,
                              weather.forecastWeather(),
                            );
                          }
                        },
                      ),
                      weather.timestamp == null && hasError == false
                          ? LoaderWidget()
                          : hasError == true || weather.apiHasProblem == true
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height /
                                                  2) -
                                              AppBar().preferredSize.height,
                                    ),
                                    Text(
                                        "Something went wrong! Please try again later."),
                                    IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          hasError = false;
                                        });
                                        if (weather.url
                                            .toString()
                                            .contains('city')) {
                                          await sendRequest(
                                            weather,
                                            weather.currentWeather(),
                                          );
                                          await sendRequest(
                                            weather,
                                            weather.forecastWeather(),
                                          );
                                        } else {
                                          await sendRequest(
                                            weather,
                                            weather.getLocation(),
                                          );
                                          await sendRequest(
                                            weather,
                                            weather.locCurrentWeather(),
                                          );
                                          await sendRequest(
                                            weather,
                                            weather.locForecastWeather(),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.white54,
                                      ),
                                      splashRadius: 20,
                                    )
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Column(
                                    children: [
                                      CurrentWeatherWidget(
                                        imagePath: weather.imageAsset(),
                                        cityName: weather.fCity,
                                        locIcon: weather.url
                                                .toString()
                                                .contains('city')
                                            ? Container()
                                            : Icon(
                                                FontAwesomeIcons.mapPin,
                                                size: area < 310000 && area > 250000
                                                    ? 35
                                                    : area >= 310000
                                                    ? 40
                                                    : 23,
                                                color: weather.imageAsset() ==
                                                            'assets/images/snow.jpg' ||
                                                        weather.imageAsset() ==
                                                            'assets/images/mist.jpg'
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                        temperature: weather.temp,
                                        iconPath: weather.icon,
                                        description: weather.desc,
                                      ),
                                      ListTiles(
                                        minTemp: weather.fMinTemp != null
                                            ? weather.fMinTemp.toString() + "°"
                                            : "",
                                        maxTemp: weather.fMaxTemp != null
                                            ? weather.fMaxTemp.toString() + "°"
                                            : "",
                                        wind: weather.wind != null
                                            ? weather.wind.toString() + " km/h"
                                            : "",
                                      ),
                                      ForecastCardList(
                                        fCityList: weather.fCityList,
                                        fDateList: weather.fDateList,
                                        fTempList: weather.fTempList,
                                        fIconList: weather.fIconList,
                                      ),
                                    ],
                                  ),
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
        hasError = true;
      });
      refreshController.refreshCompleted();
      throw e;
    } on SocketException catch (e) {
      setState(() {
        hasError = true;
      });
      refreshController.refreshCompleted();
      throw e;
    }
  }
}
