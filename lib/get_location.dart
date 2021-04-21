import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:weather_app/home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/widgets.dart';

class GetLocationWidget extends StatefulWidget {
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocationWidget> {

  RefreshController refreshController =
  RefreshController(initialRefresh: false);

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
  var fDate;
  List fCityList = [];
  List fIconList = [];
  List fTempList = [];
  List fMinTempList = [];
  List fMaxTempList = [];
  List fDateList = [];

  Future getLocation() async {
    Position position;
    try {
      position =
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    }
    catch (e) {
      print(e);
    }

    if (position != null) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });
    }
  }

  Future currentWeather() async {

    var url = "https://api.weatherbit.io/v2.0/current?lat=$lat&lon=$lon&key=bbdea9bfe56d427f9a8e2a35eea23d73";
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
    refreshController.refreshCompleted();

  }

  Future forecastWeather() async {

    var url = "https://api.weatherbit.io/v2.0/forecast/daily?lat=$lat&lon=$lon&key=bbdea9bfe56d427f9a8e2a35eea23d73";
    Response response = await get(url);
    var json = jsonDecode(response.body);

    setState(() {
      for (var item in json['data']){
          fCity=json['city_name'];
          fIcon=item['weather']['icon'];
          fTemp=item['temp'].round();
          fMinTemp=json['data'][0]['min_temp'].round();
          fMaxTemp=json['data'][0]['max_temp'].round().toInt()+1;
          fDate=item['datetime'];
          fCityList.add(fCity);
          fIconList.add(fIcon);
          fTempList.add(fTemp);
          fMinTempList.add(fMinTemp);
          fMaxTempList.add(fMaxTemp);
          fDateList.add(fDate);
      }
    });
    refreshController.refreshCompleted();

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

  Future<bool> exitApp() {
    return SystemNavigator.pop();
  }

@override
  void initState() {
    super.initState();
    getLocation()
        .then((value) => currentWeather()
        .then((value) => forecastWeather(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        body: SafeArea(
          child: SmartRefresher(
            onRefresh:() {
              getLocation();
              currentWeather();
              forecastWeather();
            },
            controller: refreshController,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchBox(
                    sizedBoxWidth: 0.0,
                    offset: -57.5,
                    locIcon: Container(),
                    onSuggestionSelected: (suggestion){
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
                  fDate == null ? LoaderWidget() : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  imageAsset(),
                                  height: MediaQuery.of(context).size.height/3,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    fCity != null ? fCity.toString() : "Loading",
                                    style: myTextStyle.copyWith(
                                      fontSize: MediaQuery.of(context).size.height/22,
                                      fontWeight: FontWeight.w700,
                                      color: imageAsset()=='assets/images/snow.jpg'
                                          || imageAsset()=='assets/images/mist.jpg'
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  Text(
                                    temp != null ? " "+temp.toString()+"°" : "",
                                    style: myTextStyle.copyWith(
                                      fontSize: MediaQuery.of(context).size.width/6.5,
                                      fontWeight: FontWeight.w700,
                                      color: imageAsset()=='assets/images/snow.jpg'
                                          || imageAsset()=='assets/images/mist.jpg'
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  Image.asset('assets/icons/$icon.png',
                                    height: MediaQuery.of(context).size.height/10,
                                    width: MediaQuery.of(context).size.width/4,
                                  ),
                                  Text(
                                    desc != null ? desc.toString() : "Loading",
                                    style: TextStyle(
                                      color: imageAsset()=='assets/images/snow.jpg'
                                          || imageAsset()=='assets/images/mist.jpg'
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: MediaQuery.of(context).size.height/45,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            alignment: Alignment.center,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          height: MediaQuery.of(context).size.height/3,
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/40,
                        ),
                        ListTile(
                          leading: Image.asset('assets/icons/mintemp.png',
                            width: MediaQuery.of(context).size.width/12,
                            height: MediaQuery.of(context).size.height/25,
                          ),
                          title: Text(
                            "Min Temperature",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.height/50,
                            ),
                          ),
                          trailing: Text(
                            fMinTemp != null ? fMinTemp.toString()+"°" : "",
                            style: myTextStyle.copyWith(
                              fontSize: MediaQuery.of(context).size.height/50,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Image.asset('assets/icons/maxtemp.png',
                            width: MediaQuery.of(context).size.width/12,
                            height: MediaQuery.of(context).size.height/20,
                          ),
                          title: Text(
                            "Max Temperature",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.height/50,
                            ),
                          ),
                          trailing: Text(
                            fMaxTemp != null ? fMaxTemp.toString()+"°" : "",
                            style: myTextStyle.copyWith(
                              fontSize: MediaQuery.of(context).size.height/50,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Image.asset('assets/icons/wind.png',
                            width: MediaQuery.of(context).size.width/12,
                            height: MediaQuery.of(context).size.height/25,
                          ),
                          title: Text(
                            "Wind Speed",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.height/50,
                            ),
                          ),
                          trailing: Text(
                            wind != null ? wind.toString()+" km/h" : "",
                            style: myTextStyle.copyWith(
                              fontSize: MediaQuery.of(context).size.height/50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/90,
                        ),
                        Divider(
                          thickness: 0.2,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/40,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/4.5,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: fCityList.length,
                            itemBuilder: (context, index) {
                              return ForecastCard(
                                date: fDateList[index],
                                temp: fTempList[index],
                                icon: fIconList[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
