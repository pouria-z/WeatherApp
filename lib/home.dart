import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:weather_app/get_location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/widgets.dart';
import 'package:weather_app/api_key.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future currentWeather() async {
      var url = cityname.text == "Montreal" || cityname.text == "Montréal" || cityname.
      text == "Vancouver" || cityname.text == "ونکوور" || cityname.text == "Toronto"
          ? "https://api.weatherbit.io/v2.0/current?city=${cityname.text}&country=CA&key=$apiKey"
          : "https://api.weatherbit.io/v2.0/current?city=${cityname.text}&key=$apiKey";
      Response response = await get(url);
      var json = jsonDecode(response.body);
      setState(() {
        LocCurrentWeather(
          icon=json['data'][0]['weather']['icon'],
          temp=json['data'][0]['temp'].round(),
          desc=json['data'][0]['weather']['description'],
          wind=json['data'][0]['wind_spd'].round(),
          code=json['data'][0]['weather']['code'],
        );
      });
      _refreshController.refreshCompleted();
  }

  Future forecastWeather() async {
    var url = cityname.text == "Montreal" || cityname.text == "Montréal" || cityname.
    text == "Vancouver" || cityname.text == "ونکوور"
        ? "https://api.weatherbit.io/v2.0/forecast/daily?city=${cityname.text}&country=CA&key=$apiKey"
        : "https://api.weatherbit.io/v2.0/forecast/daily?city=${cityname.text}&key=$apiKey";
      Response response = await get(url);
      var json = jsonDecode(response.body);
      setState(() {
        for (var item in json['data']) {
          fCity = json['city_name'];
          fIcon = item['weather']['icon'];
          fTemp = item['temp'].round();
          fMinTemp = json['data'][0]['min_temp'].round().toInt() - 2;
          fMaxTemp = json['data'][0]['max_temp'].round().toInt() + 2;
          timestamp = item['ts'];
          var time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          final DateFormat formatter = DateFormat('EEEE');
          fDate = formatter.format(time);
          fCityList.add(fCity);
          fIconList.add(fIcon);
          fTempList.add(fTemp);
          fMinTempList.add(fMinTemp);
          fMaxTempList.add(fMaxTemp);
          fDateList.add(fDate);
        }
      });
      _refreshController.refreshCompleted();
  }

  String imageAsset() {
    if (code.toString() == "700" || code.toString() == "711" ||
        code.toString() == "721" || code.toString() == "731"
        || code.toString() == "741" || code.toString() == "751"){
      return 'assets/images/mist.jpg';
    }
    else if (code.toString() == "801" || code.toString() == "802" ||
        code.toString() == "803" || code.toString() == "804"){
      return 'assets/images/cloud.jpg';
    }
    else if (code.toString() == "600" || code.toString() == "601" ||
        code.toString() == "602" || code.toString() == "610" ||
        code.toString() == "611" || code.toString() == "612" ||
        code.toString() == "621" || code.toString() == "622"){
      return 'assets/images/snow.jpg';
    }
    else if (code.toString() == "500" || code.toString() == "501" ||
        code.toString() == "502" || code.toString() == "511" ||
        code.toString() == "520" || code.toString() == "521" ||
        code.toString() == "522"){
      return 'assets/images/rain.jpg';
    }
    else if (code.toString() == "800"){
      return 'assets/images/clear.png';
    }
    else if (code.toString() == "300" || code.toString() == "301" ||
        code.toString() == "302"){
      return 'assets/images/drizzle.jpg';
    }
    else if (code.toString() == "200" || code.toString() == "201" ||
        code.toString() == "202" || code.toString() == "230" ||
        code.toString() == "231" || code.toString() == "232" ||
        code.toString() == "233"){
      return 'assets/images/thunderstorm.jpg';
    }
    else {
      return null;
    }
  }

  // ignore: missing_return
  Future<bool> onWillPop() async {
    cityname.clear();
    Navigator.pushReplacement(context,
      CupertinoPageRoute(builder: (context) => GetLocationWidget()),
    );
  }

  @override
  void initState() {
    super.initState();
    forecastWeather().then((value) => currentWeather());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: SmartRefresher(
            onRefresh:() {
              currentWeather();
              forecastWeather();
            },
            controller: _refreshController,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchBox(
                    sizedBoxWidth: 0.0,
                    offset: -104.5,
                    locIcon: IconButton(
                        icon: Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          //size: MediaQuery.of(context).size.height/46,
                        ),
                        onPressed: () {
                          Navigator.push(context, CupertinoPageRoute(
                            builder: (context) => GetLocationWidget(),
                          ));
                          cityname.text = "";
                        },
                    ),
                    onSuggestionSelected: (suggestion) {
                      cityname.text = suggestion;
                      Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Home()),
                      );
                    },
                    onSubmitted: (value) {
                      if (cityname.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter city name"),
                          ),
                        );
                      }
                      else {
                        return Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => Home()),
                        );
                      }
                    },
                  ),
                  code == null ? LoaderWidget() : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      children: [
                        CurrentWeatherWidget(
                          imagePath: imageAsset(),
                          cityName: fCity,
                          temperature: temp,
                          iconPath: icon,
                          description: desc,
                        ),
                        ListTiles(
                          minTemp: fMinTemp != null ? fMinTemp.toString()+"°" : "",
                          maxTemp: fMaxTemp != null ? fMaxTemp.toString()+"°" : "",
                          wind: wind != null ? wind.toString()+" km/h" : "",
                        ),
                        ForecastCardList(
                          fCityList: fCityList,
                          fDateList: fDateList,
                          fTempList: fTempList,
                          fIconList: fIconList,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


