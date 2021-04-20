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
import 'package:weather_app/widgets.dart';
import 'package:shimmer/shimmer.dart';

class GetLocationWidget extends StatefulWidget {
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocationWidget> {

  var lat;
  var lon;
  // LocCurrentWeather locCurrentWeather;
  // ForecastItems forecastItems;
  // LocForecastWeather locForecastWeather;


  ///current variables
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

  bool showClear = false;

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
          fMaxTemp=json['data'][0]['max_temp'].round();
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
  }

  Future<bool> exitApp() {
    SystemNavigator.pop();
  }

@override
  void initState() {
    super.initState();
    loc().then((value) => currentWeather().then((value) => forecastWeather()));
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
            currentWeather();
            forecastWeather();
          },
          controller: refreshController,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/15,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 1,
                          color: Colors.black87,
                          offset: Offset.fromDirection(4,-2)
                        ),
                      ]
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
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
                              onChanged: (value) {
                                setState(() {
                                  showClear=true;
                                });
                                if(value.toString()==""){
                                  setState(() {
                                    showClear=false;
                                  });
                                }
                              },
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
                        showClear==true ? IconButton(
                          icon: Icon(Icons.clear_rounded),
                          onPressed: () {
                            cityname.clear();
                            setState(() {
                              showClear=false;
                            });
                          },
                        ) : Container(),
                      ],
                    ),
                  ),
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
                      /// hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
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

}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                  ),
                  ListTile(
                    leading: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    trailing: Container(height: 2, width: 10, color: Colors.white),
                  ),
                  ListTile(
                    leading: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    trailing: Container(height: 2, width: 10, color: Colors.white),
                  ),
                  ListTile(
                    leading: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    trailing: Container(height: 2, width: 10, color: Colors.white),
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
                      itemCount: 16,
                      itemBuilder: (context, index) {
                        return ForecastCard(icon: 'c01n',);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      baseColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class ForecastCard extends StatelessWidget {

  final date;
  final temp;
  final icon;

  const ForecastCard({Key key, this.date, this.temp, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width/3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date != null ? date.toString() : "",
              style: myTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 15,
              ),
            ),
            Image.asset(
              'assets/icons/$icon.png',
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.height / 10,
            ),
            Text(
              temp.toString()+"°",
              style: myTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
