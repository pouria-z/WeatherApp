import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    var weather = Provider.of<Weather>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      for (var city in weather.favorites!.toList()) {
        print(city);
        await weather.getAllFavoritesWeather(city);
      }
    });
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
            title: Text("Favorites"),
            actions: [
              IconButton(
                onPressed: () {
                  List cities = [];
                  for (var i in weather.favoritesModelList) {
                    cities.add(i.data![0].cityName);
                  }
                  var cache = weather.favorites!.cast().toList();
                  if (cache.every((item) => cities.contains(item))) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text("Your favorites are updated :)"),
                        ),
                      );
                  } else {
                    // refresh list
                  }
                },
                icon: Icon(Icons.refresh_rounded),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                ListView.builder(
                  itemCount: weather.favoritesModelList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var favorite = weather.favoritesModelList[index].data![0];
                    return SlideInRight(
                      from: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                child: ListTile(
                                  leading: Image.asset(
                                      'assets/icons/${favorite.weatherModel!.icon}.png'),
                                  title: Text("${favorite.cityName}"),
                                  trailing: Text("${favorite.temp}"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
