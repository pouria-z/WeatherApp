import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:weather_app/home.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather_app/all_cities.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/widgets.dart';

class GetLocationWidget extends StatefulWidget {
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocationWidget> {

  var lat;
  var lon;

  ///new variables
  String icon;
  double temp;
  String desc;
  double wind;
  int code;

  ///separate from here

  String fCity;
  String fIcon;
  double fTemp;
  double fMinTemp;
  double fMaxTemp;
  String fDesc;
  var fDate;
  var weather;
  List<Widget> weatherWidget = [];
  ///new variables

  RefreshController refreshController =
  RefreshController(initialRefresh: false);


  Future loc() async {
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

  Future locCurrentWeather() async {

    var url = "https://api.weatherbit.io/v2.0/current?lat=$lat&lon=$lon&key=bbdea9bfe56d427f9a8e2a35eea23d73";
    Response response = await get(url);
    var locWeather = jsonDecode(response.body);
    setState(() {
      LocCurrentWeather(
        icon = locWeather['data'][0]['weather']['icon'],
        temp = locWeather['data'][0]['temp'],
        desc = locWeather['data'][0]['weather']['description'],
        wind = locWeather['data'][0]['wind_spd'],
        wind = locWeather['data'][0]['weather']['code'],
      );
    });
    refreshController.refreshCompleted();

  }

  Future locForecastWeather() async {

    var url = "https://api.weatherbit.io/v2.0/forecast/daily?lat=$lat&lon=$lon&key=bbdea9bfe56d427f9a8e2a35eea23d73";
    Response response = await get(url);
    var locWeather = jsonDecode(response.body);
    for(weather in locWeather){
      setState(() {
        LocForecastWeather(
          fCity = weather['city_name'],
          fIcon = weather['data']['weather']['icon'],
          fTemp = weather['data']['temp'],
          fMinTemp = weather['data']['min_temp'],
          fMaxTemp = weather['data']['max_temp'],
          fDesc = weather['data']['weather']['description'],
          fDate = weather['data']['datetime'],
        );
        final test = ForecastCard(date: fDate, temp: fTemp, icon: fIcon);
        weatherWidget.add(test);
      });
    }
    refreshController.refreshCompleted();
  }

  // ignore: missing_return
  Widget getImage() {
    if (code.toString() == "700" || code.toString() == "711" ||
        code.toString() == "721" || code.toString() == "731"
        || code.toString() == "741" || code.toString() == "751") {
      return Stack(
        children: [
          ClipRRect(
            child: Image.asset('assets/images/mist.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  fCity != null ? fCity.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height/22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tempIf(),
                //iconWeather(),
                Text(
                  desc != null ? desc.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    else if (code.toString() == "801" || code.toString() == "802" ||
        code.toString() == "803" || code.toString() == "804") {
      return Stack(
        children: [
          ClipRRect(
            child: Image.asset('assets/images/cloud.jpg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  fCity != null ? fCity.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tempIf(),
                //iconWeather(),
                Text(
                  desc != null ? desc.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    else if (code.toString() == "600" || code.toString() == "601" ||
        code.toString() == "602" || code.toString() == "610" ||
        code.toString() == "611" || code.toString() == "612" ||
        code.toString() == "621" || code.toString() == "622") {
      return Stack(
        children: [
          ClipRRect(
            child: Image.asset('assets/images/snow.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  fCity != null ? fCity.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height/22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tempIf(),
                //iconWeather(),
                Text(
                  desc != null ? desc.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w900,
                    backgroundColor: Colors.white30,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    else if (code.toString() == "500" || code.toString() == "501" ||
        code.toString() == "502" || code.toString() == "511" ||
        code.toString() == "520" || code.toString() == "521" ||
        code.toString() == "522"){
      return Stack(
        children: [
          ClipRRect(
            child: Image.asset('assets/images/rain.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  fCity != null ? fCity.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tempIf(),
                //iconWeather(),
                Text(
                  desc != null ? desc.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    else if (code.toString() == "800"){
      return Stack(
        children: [
          ClipRRect(
            child: Image.asset('assets/images/clear.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  fCity != null ? fCity.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tempIf(),
                //iconWeather(),
                Text(
                  desc != null ? desc.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    else if (code.toString() == "300" || code.toString() == "301" ||
        code.toString() == "302"){
      return Stack(
        children: [
          ClipRRect(
            child: Image.asset('assets/images/drizzle.jpg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  fCity != null ? fCity.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tempIf(),
                //iconWeather(),
                Text(
                  desc != null ? desc.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    else if (code.toString() == "200" || code.toString() == "201" ||
        code.toString() == "202" || code.toString() == "230" ||
        code.toString() == "231" || code.toString() == "232" ||
        code.toString() == "233"){
      return Stack(
        children: [
          ClipRRect(
            child: Image.asset('assets/images/thunderstorm.jpg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  fCity != null ? fCity.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tempIf(),
                //iconWeather(),
                Text(
                  desc != null ? desc.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Future<bool> exitApp() {
    SystemNavigator.pop();
  }

@override
  void initState() {
    super.initState();
    loc().then((value) => locCurrentWeather().then((value) => locForecastWeather()));
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SmartRefresher(
          onRefresh:() {
            loc();
            locCurrentWeather();
            locForecastWeather();
          },
          controller: refreshController,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/15,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    IconButton(icon: Icon(Icons.info_outline_rounded,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height/35,
                     ),
                      onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(
                        builder: (context) => Info(),
                      ));
                     }
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TypeAheadField(
                        suggestionsCallback: (String pattern) async {
                          return CitiesService.cities.where((item) => item.
                          toLowerCase().startsWith(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, suggestion){
                          return ListTile(
                            leading: Icon(Icons.search_rounded,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height/35,
                            ),
                            title: Text(suggestion,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          if (cityname.text.length >= 3){
                            return suggestionsBox;
                          }
                          else {
                            return null;
                          }
                        },
                        onSuggestionSelected: (suggestion){
                          cityname.text = suggestion;
                          Navigator.push(context, CupertinoPageRoute(
                            builder: (context) => Home(),
                          ));
                        },
                        noItemsFoundBuilder: (context) => ListTile(
                          title: Text(
                            "No Item Found!",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          leading: Icon(Icons.dangerous,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.height/35,
                          ),
                        ),
                        hideSuggestionsOnKeyboardHide: true,
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                            color: Theme.of(context).primaryColor,
                            elevation: 0,
                            offsetX: -69,
                            constraints: BoxConstraints.tightFor(
                              width: MediaQuery.of(context).size.width,
                            )
                        ),
                        textFieldConfiguration: TextFieldConfiguration(
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          cursorColor: Colors.white,
                          controller: cityname,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            icon: Icon(Icons.search_rounded,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height/35,
                            ),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: MediaQuery.of(context).size.height/50,
                            ),
                            //suffixIcon:
                          ),
                          onSubmitted: (value) {
                            if (cityname.text.isEmpty){
                              showDialog(context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                    "Error!",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  content: Text(
                                    "Please Enter City Name!",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () {
                                      Navigator.pop(context);
                                      }, child: Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            else {
                              return Navigator.push(context, CupertinoPageRoute(
                                builder: (context) => Home(),
                              ));
                            }
                          },
                        ),
                        suggestionsBoxVerticalOffset: 6,
                      ),
                    ),
                    Clear(),
                  ],
                ),
              ),
              pleaseRef(),
              Padding(
                padding: const EdgeInsets.only(top: 15,left: 15, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height/3,
                  width: MediaQuery.of(context).size.width,
                  child: getImage(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              fCity == null ? CircularProgressIndicator(
                strokeWidth: 2,
              )
              : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                  child: ListView(
                    children: [
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
                        trailing: minTemp(),
                      ),
                      ListTile(
                        leading: Image.asset('assets/icons/maxtemp.png',
                          width: MediaQuery.of(context).size.width/12,
                          height: MediaQuery.of(context).size.height/25,
                        ),
                        title: Text(
                          "Max Temperature",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height/50,
                          ),
                        ),
                        trailing: maxTemp(),
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
                        trailing: windSpeed(),
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
                      /// hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          children: weatherWidget,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Clear() {

    if (cityname.selection.isValid) {
      return IconButton(icon: Icon(Icons.clear_rounded,
        color: Colors.white,
      ),
        onPressed: () => cityname.text = "",
      );
    }
    else {
      return SizedBox(width: 0,);
    }
  }
  Widget pleaseRef() {

    if (fCity.toString() == "null") {
      return Text(
        " \n Please Pull Down to Refresh",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      );
    }
    else {
      return SizedBox(width: 0,);
    }

  }
  Widget minTemp() {
    if (fMinTemp.runtimeType == int){
      return Text(
        fMinTemp != null ? fMinTemp.toString() + "\u00B0" : "-",
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height/37,
        ),
      );
    }
    else if (fMinTemp.runtimeType == double) {
      return Text(
        fMinTemp != null ? fMinTemp.round().toString() + "\u00B0" : "-",
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height/37,
        ),
      );
    }
  }
  Widget maxTemp() {
    if (fMaxTemp.runtimeType == int){
      return Text(
        fMaxTemp != null ? fMaxTemp.toString() + "\u00B0" : "-",
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height/37,
        ),
      );
    }
    else if (fMaxTemp.runtimeType == double) {
      return Text(
        fMaxTemp != null ? fMaxTemp.round().toString() + "\u00B0" : "-",
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height/37,
        ),
      );
    }
  }
  Widget windSpeed() {
    if (wind.runtimeType == int){
      return Text(
        wind != null ? wind.toString() + " km/h" : "-",
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height/50,
        ),
      );
    }
    else if (wind.runtimeType == double) {
      return Text(
        wind != null ? wind.round().toString() + " km/h" : "-",
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height/50,
        ),
      );
    }
  }
  Widget tempIf() {
    if (temp.runtimeType == double) {
      if (code.toString() == "700" || code.toString() == "711" ||
          code.toString() == "721" || code.toString() == "731"
          || code.toString() == "741" || code.toString() == "751") {
        return Text(
          temp != null ? " " + temp.round().toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "801" || code.toString() == "802" ||
          code.toString() == "803" || code.toString() == "804") {
        return Text(
          temp != null ? " " + temp.round().toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "600" || code.toString() == "601" ||
          code.toString() == "602" || code.toString() == "610" ||
          code.toString() == "611" || code.toString() == "612" ||
          code.toString() == "621" || code.toString() == "622") {
        return Text(
          temp != null ? " " + temp.round().toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "500" || code.toString() == "501" ||
          code.toString() == "502" || code.toString() == "511" ||
          code.toString() == "520" || code.toString() == "521" ||
          code.toString() == "522") {
        return Text(
          temp != null ? " " + temp.round().toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "800") {
        return Text(
          temp != null ? " " + temp.round().toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "300" || code.toString() == "301" ||
          code.toString() == "302") {
        return Text(
          temp != null ? " " + temp.round().toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "200" || code.toString() == "201" ||
          code.toString() == "202" || code.toString() == "230" ||
          code.toString() == "231" || code.toString() == "232" ||
          code.toString() == "233") {
        return Text(
          temp != null ? " " + temp.round().toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
    }
    else if (temp.runtimeType == int) {
      if (code.toString() == "700" || code.toString() == "711" ||
          code.toString() == "721" || code.toString() == "731"
          || code.toString() == "741" || code.toString() == "751") {
        return Text(
          temp != null ? " " + temp.toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "801" || code.toString() == "802" ||
          code.toString() == "803" || code.toString() == "804") {
        return Text(
          temp != null ? " " + temp.toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "600" || code.toString() == "601" ||
          code.toString() == "602" || code.toString() == "610" ||
          code.toString() == "611" || code.toString() == "612" ||
          code.toString() == "621" || code.toString() == "622") {
        return Text(
          temp != null ? " " + temp.toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "500" || code.toString() == "501" ||
          code.toString() == "502" || code.toString() == "511" ||
          code.toString() == "520" || code.toString() == "521" ||
          code.toString() == "522") {
        return Text(
          temp != null ? " " + temp.toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "800") {
        return Text(
          temp != null ? " " + temp.toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "300" || code.toString() == "301" ||
          code.toString() == "302") {
        return Text(
          temp != null ? " " + temp.toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
      else if (code.toString() == "200" || code.toString() == "201" ||
          code.toString() == "202" || code.toString() == "230" ||
          code.toString() == "231" || code.toString() == "232" ||
          code.toString() == "233") {
        return Text(
          temp != null ? " " + temp.toString() + "\u00B0" : "Loading",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height/15,
            fontWeight: FontWeight.w500,
          ),
        );
      }
    }
  }
  // Widget temp1If() {
  //   if (temp1.runtimeType == int){
  //     return Text(
  //       temp1 != null ? temp1.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  //   else if (temp1.runtimeType == double) {
  //     return Text(
  //       temp1 != null ? " " + temp1.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  // }
  // Widget temp2If() {
  //   if (temp2.runtimeType == int){
  //     return Text(
  //       temp2 != null ? temp2.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  //   else if (temp2.runtimeType == double) {
  //     return Text(
  //       temp2 != null ? " " + temp2.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  // }
  // Widget temp3If() {
  //   if (temp3.runtimeType == int){
  //     return Text(
  //       temp3 != null ? temp3.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  //   else if (temp3.runtimeType == double) {
  //     return Text(
  //       temp3 != null ? " " + temp3.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  // }
  // Widget temp4If() {
  //   if (temp4.runtimeType == int){
  //     return Text(
  //       temp4 != null ? temp4.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  //   else if (temp4.runtimeType == double) {
  //     return Text(
  //       temp4 != null ? " " + temp4.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  // }
  // Widget temp5If() {
  //   if (temp5.runtimeType == int){
  //     return Text(
  //       temp5 != null ? temp5.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  //   else if (temp5.runtimeType == double) {
  //     return Text(
  //       temp5 != null ? " " + temp5.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  // }
  // Widget temp6If() {
  //   if (temp6.runtimeType == int){
  //     return Text(
  //       temp6 != null ? temp6.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  //   else if (temp6.runtimeType == double) {
  //     return Text(
  //       temp6 != null ? " " + temp6.round().toString() + "\u00B0" : "-",
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: MediaQuery.of(context).size.height/37,
  //       ),
  //     );
  //   }
  // }
  // Widget iconWeather() {
  //
  //   if (icon.toString() == "t01d" || icon.toString() == "t02d" || icon.toString() == "t03d" || icon.toString() == "t04d" || icon.toString() == "t04d"){
  //     return Image.asset('assets/icons/thunder-d.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "t01n" || icon.toString() == "t02n" || icon.toString() == "t03n" || icon.toString() == "t04n" || icon.toString() == "t04n"){
  //     return Image.asset('assets/icons/thunder-n.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "d01d" || icon.toString() == "d02d"){
  //     return Image.asset('assets/icons/drizzle-d.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "d01n" || icon.toString() == "d02n"){
  //     return Image.asset('assets/icons/drizzle-n.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "d03d" || icon.toString() == "d03n"){
  //     return Image.asset('assets/icons/drizzle-heavy.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "r01d" || icon.toString() == "r01n" || icon.toString() == "r02d" || icon.toString() == "r02n"){
  //     return Image.asset('assets/icons/light-rain.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //       color: Colors.white,
  //     );
  //   }
  //   else if (icon.toString() == "r03d" || icon.toString() == "r03n" || icon.toString() == "f01d" || icon.toString() == "f01n" || icon.toString() == "r04d" || icon.toString() == "r04n" || icon.toString() == "r05d" || icon.toString() == "r05n" || icon.toString() == "r06d" || icon.toString() == "r06n"){
  //     return Image.asset('assets/icons/shower.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //       color: Colors.white,
  //     );
  //   }
  //   else if (icon.toString() == "s01d"){
  //     return Image.asset('assets/icons/light-snow-d.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "s01n"){
  //     return Image.asset('assets/icons/light-snow-n.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "s02d" || icon.toString() == "s02n" || icon.toString() == "s03d" || icon.toString() == "s03n" || icon.toString() == "s06d" || icon.toString() == "s06n"){
  //     return Image.asset('assets/icons/snow.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "s04d"){
  //     return Image.asset('assets/icons/mix-snow-d.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "s04n"){
  //     return Image.asset('assets/icons/mix-snow-n.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "s05d" || icon.toString() == "s05n"){
  //     return Image.asset('assets/icons/sleet.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "a01d" || icon.toString() == "a02d" || icon.toString() == "a03d" || icon.toString() == "a04d" || icon.toString() == "a05d" || icon.toString() == "a06d"){
  //     return Image.asset('assets/icons/mist-d.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "a01n" || icon.toString() == "a02n" || icon.toString() == "a03n" || icon.toString() == "a04n" || icon.toString() == "a05n" || icon.toString() == "a06n"){
  //     return Image.asset('assets/icons/mist-n.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "c01d"){
  //     return Image.asset('assets/icons/clear-d.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "c01n"){
  //     return Image.asset('assets/icons/clear-n.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "c02d" || icon.toString() == "c03d"){
  //     return Image.asset('assets/icons/cloud-d.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "c02n" || icon.toString() == "c03n"){
  //     return Image.asset('assets/icons/cloud-n.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //   else if (icon.toString() == "c04d" || icon.toString() == "c04n"){
  //     return Image.asset('assets/icons/overcast-cloud.png',
  //       height: MediaQuery.of(context).size.height/11,
  //       width: MediaQuery.of(context).size.width/4,
  //     );
  //   }
  //
  // }
  // Widget iconWeather1() {
  //
  //   if (icon1.toString() == "t01d" || icon1.toString() == "t02d" || icon1.toString() == "t03d" || icon1.toString() == "t04d" || icon1.toString() == "t04d"){
  //     return Image.asset('assets/icons/thunder-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "t01n" || icon1.toString() == "t02n" || icon1.toString() == "t03n" || icon1.toString() == "t04n" || icon1.toString() == "t04n"){
  //     return Image.asset('assets/icons/thunder-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "d01d" || icon1.toString() == "d02d"){
  //     return Image.asset('assets/icons/drizzle-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "d01n" || icon1.toString() == "d02n"){
  //     return Image.asset('assets/icons/drizzle-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "d03d" || icon1.toString() == "d03n"){
  //     return Image.asset('assets/icons/drizzle-heavy.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "r01d" || icon1.toString() == "r01n" || icon1.toString() == "r02d" || icon1.toString() == "r02n"){
  //     return Image.asset('assets/icons/light-rain.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "r03d" || icon1.toString() == "r03n" || icon1.toString() == "f01d" || icon1.toString() == "f01n" || icon1.toString() == "r04d" || icon1.toString() == "r04n" || icon1.toString() == "r05d" || icon1.toString() == "r05n" || icon1.toString() == "r06d" || icon1.toString() == "r06n"){
  //     return Image.asset('assets/icons/shower.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "s01d"){
  //     return Image.asset('assets/icons/light-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "s01n"){
  //     return Image.asset('assets/icons/light-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "s02d" || icon1.toString() == "s02n" || icon1.toString() == "s03d" || icon1.toString() == "s03n" || icon1.toString() == "s06d" || icon1.toString() == "s06n"){
  //     return Image.asset('assets/icons/snow.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "s04d"){
  //     return Image.asset('assets/icons/mix-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "s04n"){
  //     return Image.asset('assets/icons/mix-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "s05d" || icon1.toString() == "s05n"){
  //     return Image.asset('assets/icons/sleet.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "a01d" || icon1.toString() == "a02d" || icon1.toString() == "a03d" || icon1.toString() == "a04d" || icon1.toString() == "a05d" || icon1.toString() == "a06d"){
  //     return Image.asset('assets/icons/mist-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "a01n" || icon1.toString() == "a02n" || icon1.toString() == "a03n" || icon1.toString() == "a04n" || icon1.toString() == "a05n" || icon1.toString() == "a06n"){
  //     return Image.asset('assets/icons/mist-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "c01d"){
  //     return Image.asset('assets/icons/clear-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "c01n"){
  //     return Image.asset('assets/icons/clear-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "c02d" || icon1.toString() == "c03d"){
  //     return Image.asset('assets/icons/cloud-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "c02n" || icon1.toString() == "c03n"){
  //     return Image.asset('assets/icons/cloud-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon1.toString() == "c04d" || icon1.toString() == "c04n"){
  //     return Image.asset('assets/icons/overcast-cloud.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //
  // }
  // Widget iconWeather2() {
  //
  //   if (icon2.toString() == "t01d" || icon2.toString() == "t02d" || icon2.toString() == "t03d" || icon2.toString() == "t04d" || icon2.toString() == "t04d"){
  //     return Image.asset('assets/icons/thunder-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "t01n" || icon2.toString() == "t02n" || icon2.toString() == "t03n" || icon2.toString() == "t04n" || icon2.toString() == "t04n"){
  //     return Image.asset('assets/icons/thunder-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "d01d" || icon2.toString() == "d02d"){
  //     return Image.asset('assets/icons/drizzle-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "d01n" || icon2.toString() == "d02n"){
  //     return Image.asset('assets/icons/drizzle-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "d03d" || icon2.toString() == "d03n"){
  //     return Image.asset('assets/icons/drizzle-heavy.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "r01d" || icon2.toString() == "r01n" || icon2.toString() == "r02d" || icon2.toString() == "r02n"){
  //     return Image.asset('assets/icons/light-rain.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon2.toString() == "r03d" || icon2.toString() == "r03n" || icon2.toString() == "f01d" || icon2.toString() == "f01n" || icon2.toString() == "r04d" || icon2.toString() == "r04n" || icon2.toString() == "r05d" || icon2.toString() == "r05n" || icon2.toString() == "r06d" || icon2.toString() == "r06n"){
  //     return Image.asset('assets/icons/shower.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon2.toString() == "s01d"){
  //     return Image.asset('assets/icons/light-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "s01n"){
  //     return Image.asset('assets/icons/light-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "s02d" || icon2.toString() == "s02n" || icon2.toString() == "s03d" || icon2.toString() == "s03n" || icon2.toString() == "s06d" || icon2.toString() == "s06n"){
  //     return Image.asset('assets/icons/snow.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "s04d"){
  //     return Image.asset('assets/icons/mix-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "s04n"){
  //     return Image.asset('assets/icons/mix-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "s05d" || icon2.toString() == "s05n"){
  //     return Image.asset('assets/icons/sleet.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "a01d" || icon2.toString() == "a02d" || icon2.toString() == "a03d" || icon2.toString() == "a04d" || icon2.toString() == "a05d" || icon2.toString() == "a06d"){
  //     return Image.asset('assets/icons/mist-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "a01n" || icon2.toString() == "a02n" || icon2.toString() == "a03n" || icon2.toString() == "a04n" || icon2.toString() == "a05n" || icon2.toString() == "a06n"){
  //     return Image.asset('assets/icons/mist-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "c01d"){
  //     return Image.asset('assets/icons/clear-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "c01n"){
  //     return Image.asset('assets/icons/clear-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "c02d" || icon2.toString() == "c03d"){
  //     return Image.asset('assets/icons/cloud-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "c02n" || icon2.toString() == "c03n"){
  //     return Image.asset('assets/icons/cloud-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon2.toString() == "c04d" || icon2.toString() == "c04n"){
  //     return Image.asset('assets/icons/overcast-cloud.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //
  // }
  // Widget iconWeather3() {
  //
  //   if (icon3.toString() == "t01d" || icon3.toString() == "t02d" || icon3.toString() == "t03d" || icon3.toString() == "t04d" || icon3.toString() == "t04d"){
  //     return Image.asset('assets/icons/thunder-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "t01n" || icon3.toString() == "t02n" || icon3.toString() == "t03n" || icon3.toString() == "t04n" || icon3.toString() == "t04n"){
  //     return Image.asset('assets/icons/thunder-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "d01d" || icon3.toString() == "d02d"){
  //     return Image.asset('assets/icons/drizzle-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "d01n" || icon3.toString() == "d02n"){
  //     return Image.asset('assets/icons/drizzle-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "d03d" || icon3.toString() == "d03n"){
  //     return Image.asset('assets/icons/drizzle-heavy.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "r01d" || icon3.toString() == "r01n" || icon3.toString() == "r02d" || icon3.toString() == "r02n"){
  //     return Image.asset('assets/icons/light-rain.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon3.toString() == "r03d" || icon3.toString() == "r03n" || icon3.toString() == "f01d" || icon3.toString() == "f01n" || icon3.toString() == "r04d" || icon3.toString() == "r04n" || icon3.toString() == "r05d" || icon3.toString() == "r05n" || icon3.toString() == "r06d" || icon3.toString() == "r06n"){
  //     return Image.asset('assets/icons/shower.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon3.toString() == "s01d"){
  //     return Image.asset('assets/icons/light-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "s01n"){
  //     return Image.asset('assets/icons/light-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "s02d" || icon3.toString() == "s02n" || icon3.toString() == "s03d" || icon3.toString() == "s03n" || icon3.toString() == "s06d" || icon3.toString() == "s06n"){
  //     return Image.asset('assets/icons/snow.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "s04d"){
  //     return Image.asset('assets/icons/mix-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "s04n"){
  //     return Image.asset('assets/icons/mix-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "s05d" || icon3.toString() == "s05n"){
  //     return Image.asset('assets/icons/sleet.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "a01d" || icon3.toString() == "a02d" || icon3.toString() == "a03d" || icon3.toString() == "a04d" || icon3.toString() == "a05d" || icon3.toString() == "a06d"){
  //     return Image.asset('assets/icons/mist-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "a01n" || icon3.toString() == "a02n" || icon3.toString() == "a03n" || icon3.toString() == "a04n" || icon3.toString() == "a05n" || icon3.toString() == "a06n"){
  //     return Image.asset('assets/icons/mist-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "c01d"){
  //     return Image.asset('assets/icons/clear-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "c01n"){
  //     return Image.asset('assets/icons/clear-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "c02d" || icon3.toString() == "c03d"){
  //     return Image.asset('assets/icons/cloud-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "c02n" || icon3.toString() == "c03n"){
  //     return Image.asset('assets/icons/cloud-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon3.toString() == "c04d" || icon3.toString() == "c04n"){
  //     return Image.asset('assets/icons/overcast-cloud.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //
  // }
  // Widget iconWeather4() {
  //
  //   if (icon4.toString() == "t01d" || icon4.toString() == "t02d" || icon4.toString() == "t03d" || icon4.toString() == "t04d" || icon4.toString() == "t04d"){
  //     return Image.asset('assets/icons/thunder-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "t01n" || icon4.toString() == "t02n" || icon4.toString() == "t03n" || icon4.toString() == "t04n" || icon4.toString() == "t04n"){
  //     return Image.asset('assets/icons/thunder-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "d01d" || icon4.toString() == "d02d"){
  //     return Image.asset('assets/icons/drizzle-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "d01n" || icon4.toString() == "d02n"){
  //     return Image.asset('assets/icons/drizzle-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "d03d" || icon4.toString() == "d03n"){
  //     return Image.asset('assets/icons/drizzle-heavy.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "r01d" || icon4.toString() == "r01n" || icon4.toString() == "r02d" || icon4.toString() == "r02n"){
  //     return Image.asset('assets/icons/light-rain.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon4.toString() == "r03d" || icon4.toString() == "r03n" || icon4.toString() == "f01d" || icon4.toString() == "f01n" || icon4.toString() == "r04d" || icon4.toString() == "r04n" || icon4.toString() == "r05d" || icon4.toString() == "r05n" || icon4.toString() == "r06d" || icon4.toString() == "r06n"){
  //     return Image.asset('assets/icons/shower.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon4.toString() == "s01d"){
  //     return Image.asset('assets/icons/light-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "s01n"){
  //     return Image.asset('assets/icons/light-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "s02d" || icon4.toString() == "s02n" || icon4.toString() == "s03d" || icon4.toString() == "s03n" || icon4.toString() == "s06d" || icon4.toString() == "s06n"){
  //     return Image.asset('assets/icons/snow.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "s04d"){
  //     return Image.asset('assets/icons/mix-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "s04n"){
  //     return Image.asset('assets/icons/mix-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "s05d" || icon4.toString() == "s05n"){
  //     return Image.asset('assets/icons/sleet.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "a01d" || icon4.toString() == "a02d" || icon4.toString() == "a03d" || icon4.toString() == "a04d" || icon4.toString() == "a05d" || icon4.toString() == "a06d"){
  //     return Image.asset('assets/icons/mist-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "a01n" || icon4.toString() == "a02n" || icon4.toString() == "a03n" || icon4.toString() == "a04n" || icon4.toString() == "a05n" || icon4.toString() == "a06n"){
  //     return Image.asset('assets/icons/mist-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "c01d"){
  //     return Image.asset('assets/icons/clear-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "c01n"){
  //     return Image.asset('assets/icons/clear-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "c02d" || icon4.toString() == "c03d"){
  //     return Image.asset('assets/icons/cloud-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "c02n" || icon4.toString() == "c03n"){
  //     return Image.asset('assets/icons/cloud-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon4.toString() == "c04d" || icon4.toString() == "c04n"){
  //     return Image.asset('assets/icons/overcast-cloud.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //
  // }
  // Widget iconWeather5() {
  //
  //   if (icon5.toString() == "t01d" || icon5.toString() == "t02d" || icon5.toString() == "t03d" || icon5.toString() == "t04d" || icon5.toString() == "t04d"){
  //     return Image.asset('assets/icons/thunder-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "t01n" || icon5.toString() == "t02n" || icon5.toString() == "t03n" || icon5.toString() == "t04n" || icon5.toString() == "t04n"){
  //     return Image.asset('assets/icons/thunder-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "d01d" || icon5.toString() == "d02d"){
  //     return Image.asset('assets/icons/drizzle-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "d01n" || icon5.toString() == "d02n"){
  //     return Image.asset('assets/icons/drizzle-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "d03d" || icon5.toString() == "d03n"){
  //     return Image.asset('assets/icons/drizzle-heavy.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "r01d" || icon5.toString() == "r01n" || icon5.toString() == "r02d" || icon5.toString() == "r02n"){
  //     return Image.asset('assets/icons/light-rain.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon5.toString() == "r03d" || icon5.toString() == "r03n" || icon5.toString() == "f01d" || icon5.toString() == "f01n" || icon5.toString() == "r04d" || icon5.toString() == "r04n" || icon5.toString() == "r05d" || icon5.toString() == "r05n" || icon5.toString() == "r06d" || icon5.toString() == "r06n"){
  //     return Image.asset('assets/icons/shower.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon5.toString() == "s01d"){
  //     return Image.asset('assets/icons/light-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "s01n"){
  //     return Image.asset('assets/icons/light-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "s02d" || icon5.toString() == "s02n" || icon5.toString() == "s03d" || icon5.toString() == "s03n" || icon5.toString() == "s06d" || icon5.toString() == "s06n"){
  //     return Image.asset('assets/icons/snow.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "s04d"){
  //     return Image.asset('assets/icons/mix-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "s04n"){
  //     return Image.asset('assets/icons/mix-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "s05d" || icon5.toString() == "s05n"){
  //     return Image.asset('assets/icons/sleet.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "a01d" || icon5.toString() == "a02d" || icon5.toString() == "a03d" || icon5.toString() == "a04d" || icon5.toString() == "a05d" || icon5.toString() == "a06d"){
  //     return Image.asset('assets/icons/mist-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "a01n" || icon5.toString() == "a02n" || icon5.toString() == "a03n" || icon5.toString() == "a04n" || icon5.toString() == "a05n" || icon5.toString() == "a06n"){
  //     return Image.asset('assets/icons/mist-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "c01d"){
  //     return Image.asset('assets/icons/clear-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "c01n"){
  //     return Image.asset('assets/icons/clear-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "c02d" || icon5.toString() == "c03d"){
  //     return Image.asset('assets/icons/cloud-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "c02n" || icon5.toString() == "c03n"){
  //     return Image.asset('assets/icons/cloud-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon5.toString() == "c04d" || icon5.toString() == "c04n"){
  //     return Image.asset('assets/icons/overcast-cloud.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //
  // }
  // Widget iconWeather6() {
  //
  //   if (icon6.toString() == "t01d" || icon6.toString() == "t02d" || icon6.toString() == "t03d" || icon6.toString() == "t04d" || icon6.toString() == "t04d"){
  //     return Image.asset('assets/icons/thunder-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "t01n" || icon6.toString() == "t02n" || icon6.toString() == "t03n" || icon6.toString() == "t04n" || icon6.toString() == "t04n"){
  //     return Image.asset('assets/icons/thunder-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "d01d" || icon6.toString() == "d02d"){
  //     return Image.asset('assets/icons/drizzle-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "d01n" || icon6.toString() == "d02n"){
  //     return Image.asset('assets/icons/drizzle-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "d03d" || icon6.toString() == "d03n"){
  //     return Image.asset('assets/icons/drizzle-heavy.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "r01d" || icon6.toString() == "r01n" || icon6.toString() == "r02d" || icon6.toString() == "r02n"){
  //     return Image.asset('assets/icons/light-rain.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon6.toString() == "r03d" || icon6.toString() == "r03n" || icon6.toString() == "f01d" || icon6.toString() == "f01n" || icon6.toString() == "r04d" || icon6.toString() == "r04n" || icon6.toString() == "r05d" || icon6.toString() == "r05n" || icon6.toString() == "r06d" || icon6.toString() == "r06n"){
  //     return Image.asset('assets/icons/shower.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //
  //     );
  //   }
  //   else if (icon6.toString() == "s01d"){
  //     return Image.asset('assets/icons/light-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "s01n"){
  //     return Image.asset('assets/icons/light-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "s02d" || icon6.toString() == "s02n" || icon6.toString() == "s03d" || icon6.toString() == "s03n" || icon6.toString() == "s06d" || icon6.toString() == "s06n"){
  //     return Image.asset('assets/icons/snow.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "s04d"){
  //     return Image.asset('assets/icons/mix-snow-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "s04n"){
  //     return Image.asset('assets/icons/mix-snow-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "s05d" || icon6.toString() == "s05n"){
  //     return Image.asset('assets/icons/sleet.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "a01d" || icon6.toString() == "a02d" || icon6.toString() == "a03d" || icon6.toString() == "a04d" || icon6.toString() == "a05d" || icon6.toString() == "a06d"){
  //     return Image.asset('assets/icons/mist-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "a01n" || icon6.toString() == "a02n" || icon6.toString() == "a03n" || icon6.toString() == "a04n" || icon6.toString() == "a05n" || icon6.toString() == "a06n"){
  //     return Image.asset('assets/icons/mist-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "c01d"){
  //     return Image.asset('assets/icons/clear-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "c01n"){
  //     return Image.asset('assets/icons/clear-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "c02d" || icon6.toString() == "c03d"){
  //     return Image.asset('assets/icons/cloud-d.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "c02n" || icon6.toString() == "c03n"){
  //     return Image.asset('assets/icons/cloud-n.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //   else if (icon6.toString() == "c04d" || icon6.toString() == "c04n"){
  //     return Image.asset('assets/icons/overcast-cloud.png',
  //       height: MediaQuery.of(context).size.height/14,
  //       width: MediaQuery.of(context).size.width/5,
  //     );
  //   }
  //
  // }

}

class ForecastCard extends StatelessWidget {

  final String date;
  final String icon;
  final double temp;

  const ForecastCard({Key key, @required this.date, @required this.temp, @required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/6,
      width: MediaQuery.of(context).size.width/4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(date != null ? date.toString() : "",
            style: myTextStyle.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 15,
            ),
          ),
          Image.asset('assets/icons/$icon.png',
            height: MediaQuery.of(context).size.height/14,
            width: MediaQuery.of(context).size.width/5,
          ),
          Text(
            temp.toString(),
            style: myTextStyle,
          ),
        ],
      ),
    );
  }
}
