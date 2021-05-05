import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/services.dart';
import 'package:weather_app/widgets.dart';
import 'package:provider/provider.dart';

RefreshController refreshController =
RefreshController(initialRefresh: false);

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Weather>(context, listen: false).getLocation()
          .then((value) => Provider.of<Weather>(context, listen: false).locCurrentWeather()
          .then((value) => Provider.of<Weather>(context, listen: false).locForecastWeather()
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var weather = Provider.of<Weather>(context,listen: false);
    return WillPopScope(
      onWillPop: () {
        return showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text("Exit App", style: myTextStyleBold,),
            content: Text("Are you sure you want to exit from app?", style: myTextStyle.copyWith(color: Colors.white54),),
            actions: [
              TextButton(
                child: Text("No", style: myTextStyle),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Yes", style: myTextStyle.copyWith(color: Colors.red),),
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
                onRefresh:() {
                  weather.url.toString().contains('city') ? weather.currentWeather()
                      .then((value) => weather.forecastWeather())
                      : weather.getLocation()
                      .then((value) => weather.locCurrentWeather()
                      .then((value) => weather.locForecastWeather()
                  ));
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
                          onPressed: () {
                            setState(() {
                              showClear = false;
                            });
                            weather.timestamp = null;
                            weather.fCityList.clear();
                            weather.fDateList.clear();
                            weather.fTempList.clear();
                            weather.fIconList.clear();
                            weather.getLocation()
                                .then((value) => weather.locCurrentWeather()
                                .then((value) => weather.locForecastWeather()
                            ));
                            cityName.text = "";
                          },
                        ) : Container(),
                        sizedBoxWidth: weather.url.toString().contains('city') ? 7.0 : 0.0,
                        offset: weather.url.toString().contains('city') ? -113.0 : -58.0,
                        ///SuggestionSelected
                        onSuggestionSelected: (suggestion){
                          weather.timestamp = null;
                          weather.fCityList.clear();
                          weather.fDateList.clear();
                          weather.fTempList.clear();
                          weather.fIconList.clear();
                          cityName.text = suggestion;
                          weather.currentWeather()
                              .then((value) => weather.forecastWeather());
                        },
                        ///onSubmitted
                        onSubmitted: (value) {
                          if (cityName.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please enter city name"),
                              ),
                            );
                          }
                          else {
                            weather.timestamp = null;
                            weather.fCityList.clear();
                            weather.fDateList.clear();
                            weather.fTempList.clear();
                            weather.fIconList.clear();
                            return weather.currentWeather()
                                .then((value) => weather.forecastWeather());
                          }
                        },
                      ),
                      weather.timestamp == null ? LoaderWidget() : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Column(
                          children: [
                            CurrentWeatherWidget(
                              imagePath: weather.imageAsset(),
                              cityName: weather.fCity,
                              locIcon: weather.url.toString().contains('city')
                                  ? Container()
                                  : Icon(
                                FontAwesomeIcons.mapPin,
                                size: MediaQuery.of(context).size.height/26.5,
                                color: weather.imageAsset()=='assets/images/snow.jpg'
                                    || weather.imageAsset()=='assets/images/mist.jpg'
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              temperature: weather.temp,
                              iconPath: weather.icon,
                              description: weather.desc,
                            ),
                            ListTiles(
                              minTemp: weather.fMinTemp != null ? weather.fMinTemp.toString()+"°" : "",
                              maxTemp: weather.fMaxTemp != null ? weather.fMaxTemp.toString()+"°" : "",
                              wind: weather.wind != null ? weather.wind.toString()+" km/h" : "",
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
}
