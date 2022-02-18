import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screens/favorite/favorite_details.dart';
import 'package:weather_app/services/services.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with AutomaticKeepAliveClientMixin {
  List cities = [];
  List cache = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getFavoriteList();
    });
  }

  Future<void> getFavoriteList() async {
    var weather = Provider.of<Weather>(context, listen: false);
    weather.favoritesModelList.clear();
    for (var city in weather.favorites!.toList()) {
      await weather.getAllFavoritesWeather(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var weather = Provider.of<Weather>(context, listen: false);
    return Consumer<Weather>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            title: Text(
              "Favorites",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              weather.isSelected.contains(true)
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            final selects =
                            weather.isSelected.getRange(0, weather.favorites!.length).toList();
                            if (!selects.contains(false)) {
                              // has selected all
                              setState(() {
                                preferences.clear();
                                weather.getFavoritesList();
                                weather.favoritesModelList.clear();
                                weather.isSelected.fillRange(0, 500, false);
                                weather.selectedCities.fillRange(0, 500, "");
                              });
                            } else {
                              for (var i in weather.selectedCities) {
                                setState(() {
                                  preferences.remove(i);
                                  weather.isSelected.fillRange(0, 500, false);
                                  weather.selectedCities.fillRange(0, 500, "");
                                });
                              }
                              preferences.reload();
                              print(weather.isSelected);
                              print(weather.selectedCities);
                            }
                          },
                          icon: Icon(Iconsax.trash),
                        ),
                        IconButton(
                          onPressed: () {
                            List list = List.generate(weather.favorites!.length, (index) => true);
                            final selects =
                                weather.isSelected.getRange(0, weather.favorites!.length).toList();
                            print("list: $list, selects: $selects");
                            // deselect all
                            if (listEquals(list, selects)) {
                              setState(() {
                                weather.isSelected.fillRange(0, weather.favorites!.length, false);
                                weather.selectedCities.fillRange(0, weather.favorites!.length, "");
                              });
                            } else {
                              // select all
                              setState(() {
                                weather.isSelected.fillRange(0, weather.favorites!.length, true);
                                int counter = 0;
                                for (var city in weather.favorites!.cast()) {
                                  print(city);
                                  weather.selectedCities
                                      .fillRange(counter, weather.favorites!.length, city);
                                  counter++;
                                }
                              });
                              // print(weather.selectedCities);
                            }
                          },
                          icon: Icon(Icons.select_all_rounded),
                        )
                      ],
                    )
                  : IconButton(
                      onPressed: () async {
                        for (var i in weather.favoritesModelList) {
                          cities.add(i.data![0].cityName);
                        }
                        cache = weather.favorites!.cast().toList();
                        print("$cache, $cities");
                        if (cities.length == cache.length) {
                          if (cache.every((item) => cities.contains(item))) {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text("Your favorites are updated :)"),
                                  dismissDirection: DismissDirection.horizontal,
                                ),
                              );
                          } else {
                            await getFavoriteList();
                          }
                        } else {
                          await getFavoriteList();
                        }
                      },
                      icon: Icon(Icons.refresh_rounded),
                    )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Center(
              child: Column(
                children: [
                  weather.favorites!.isNotEmpty
                      ? ListView.builder(
                          itemCount: weather.favorites!.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            print(weather.favoritesModelList.length);
                            var favorite = weather.favoritesModelList[index].data![0];
                            return SlideInRight(
                              from: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 1),
                                child: InkWell(
                                  onTap: () {
                                    if (weather.isSelected.contains(true)) {
                                      setState(() {
                                        if (!weather.isSelected[index]) {
                                          weather.isSelected[index] = true;
                                          weather.selectedCities[index] = favorite.cityName!;
                                          var i = weather.selectedCities.getRange(0, 3);
                                          print(i);
                                        } else {
                                          weather.isSelected[index] = false;
                                          weather.selectedCities[index] = "";
                                          var i = weather.selectedCities.getRange(0, 3);
                                          print(i);
                                        }
                                      });
                                    } else {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) {
                                            return FavoriteDetailsPage(city: favorite.cityName!);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  onLongPress: () {
                                    if (!weather.isSelected.contains(true)) {
                                      setState(() {
                                        weather.isSelected[index] = !weather.isSelected[index];
                                        weather.selectedCities[index] = favorite.cityName!;
                                      });
                                      var i = weather.selectedCities.getRange(0, 3);
                                      print(i);
                                    }
                                  },
                                  splashColor: Theme.of(context).cardColor,
                                  enableFeedback: false,
                                  borderRadius: BorderRadius.circular(15),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 250),
                                    height: 80,
                                    // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: weather.isSelected[index]
                                          ? Colors.lightBlueAccent.withAlpha(150)
                                          : Colors.transparent,
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.asset(
                                              favorite.weatherModel!.imageAsset(),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                              child: Center(
                                                child: ListTile(
                                                  leading: Image.asset(
                                                      'assets/icons/${favorite.weatherModel!.icon}.png'),
                                                  title: Text(
                                                    "${favorite.cityName}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: favorite.weatherModel!.imageAsset() ==
                                                                  'assets/images/snow.jpg' ||
                                                              favorite.weatherModel!.imageAsset() ==
                                                                  'assets/images/mist.jpg'
                                                          ? Colors.black
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    "${favorite.weatherModel!.description}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: favorite.weatherModel!.imageAsset() ==
                                                                  'assets/images/snow.jpg' ||
                                                              favorite.weatherModel!.imageAsset() ==
                                                                  'assets/images/mist.jpg'
                                                          ? Colors.black87
                                                          : Colors.white70,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    "${favorite.temp}°",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: favorite.weatherModel!.imageAsset() ==
                                                                  'assets/images/snow.jpg' ||
                                                              favorite.weatherModel!.imageAsset() ==
                                                                  'assets/images/mist.jpg'
                                                          ? Colors.black
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Your list is empty :(",
                              style: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
