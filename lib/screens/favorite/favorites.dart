import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/favorite/favorite_details.dart';
import 'package:weather_app/services/services.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with AutomaticKeepAliveClientMixin {
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
              IconButton(
                onPressed: () async {
                  List cities = [];
                  for (var i in weather.favoritesModelList) {
                    cities.add(i.data![0].cityName);
                  }
                  var cache = weather.favorites!.cast().toList();
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
                  weather.favoritesModelList.isNotEmpty
                      ? ListView.builder(
                          itemCount: weather.favoritesModelList.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var favorite = weather.favoritesModelList[index].data![0];
                            return SlideInRight(
                              from: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) {
                                        return FavoriteDetailsPage(city: favorite.cityName!);
                                      },
                                    ),
                                  );
                                },
                                splashColor: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  height: 80,
                                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          favorite.weatherModel!.imageAsset(),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      ClipRRect(
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "Your list is empty :(",
                            style: TextStyle(
                              color: Colors.white54,
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
