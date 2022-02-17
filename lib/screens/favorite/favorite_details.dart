import 'package:flutter/material.dart';
import 'package:weather_app/services/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:weather_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/favorite_models/favorite_details_current.dart';
import 'package:weather_app/models/favorite_models/favorite_details_forecast.dart';

class FavoriteDetailsPage extends StatefulWidget {
  const FavoriteDetailsPage({Key? key, required this.city}) : super(key: key);

  final String city;

  @override
  _FavoriteDetailsPageState createState() => _FavoriteDetailsPageState();
}

class _FavoriteDetailsPageState extends State<FavoriteDetailsPage> {
  @override
  void initState() {
    super.initState();
    var weather = Provider.of<Weather>(context, listen: false);
    weather.favoriteDetailsCurrentWeatherModel = null;
    Future.delayed(Duration.zero, () async {
      weather.favoriteDetailsCurrentWeatherModel =
          weather.favoriteDetailsCurrent(widget.city).whenComplete(() async {
        weather.setFavoriteInDetails();
      });
      weather.favoriteDetailsForecastWeatherModel = weather.favoriteDetailsForecast(widget.city);
    });
  }

  @override
  Widget build(BuildContext context) {
    var weather = Provider.of<Weather>(context, listen: false);
    return Consumer<Weather>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(widget.city),
            actions: [
              IconButton(
                onPressed: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  var city = weather.favoriteDetailsCurrentModel!.data![0].cityName;
                  if (!weather.isFavorite) {
                    print("not in faves");
                    await preferences.setString("$city", "$city");
                    print("$city saved successfully!");
                    await weather.getFavoritesList();
                    await weather.setFavoriteInDetails();
                  } else {
                    print("already in faves");
                    preferences.remove("$city");
                    print("$city removed successfully!");
                    await weather.getFavoritesList();
                    await weather.setFavoriteInDetails();
                  }
                },
                icon: Icon(
                  weather.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                  color: weather.isFavorite ? Theme.of(context).colorScheme.primary : Colors.white,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<FavoriteDetailsCurrentModel>(
                    future: weather.favoriteDetailsCurrentWeatherModel,
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
                                weather.favoriteDetailsCurrentWeatherModel =
                                    weather.favoriteDetailsCurrent(widget.city);
                                weather.favoriteDetailsForecastWeatherModel =
                                    weather.favoriteDetailsForecast(widget.city);
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
                                imagePath: currentData.weatherModel!.imageAsset(),
                                isFavorite: true,
                                cityName: currentData.cityName,
                                url: weather.url,
                                temperature: currentData.temp,
                                iconPath: currentData.weatherModel!.icon,
                                description: currentData.weatherModel!.description,
                              ),
                              FutureBuilder<FavoriteDetailsForecastModel>(
                                future: weather.favoriteDetailsForecastWeatherModel,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                          height: MediaQuery.of(context).size.height / 4.5,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.data!.length,
                                            itemBuilder: (context, index) {
                                              var item = snapshot.data!.data![index];
                                              return ForecastCard(
                                                date: weather.favoriteForecastDate[index],
                                                temp: item.temp,
                                                minTemp: item.minTemp,
                                                maxTemp: item.maxTemp,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
