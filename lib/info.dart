import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/widgets.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    tapGestureRecognizer.onTap = () {
      var url = "https://www.weatherbit.io";
      launch(url);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Info",
          style: myTextStyleBold,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhysicalModel(
              color: Colors.transparent,
              elevation: 15,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: Icon(
                            Iconsax.message_24,
                            // color: Colors.orange,
                          ),
                          title: Text(
                            "Contact Me",
                            style: myTextStyleBold,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Iconsax.arrow_circle_right,
                              // color: Colors.orange,
                            ),
                            onPressed: () {
                              var url =
                                  "mailto:pouria.zeinalzadeh@gmail.com?subject=Weather App";
                              launch(url);
                            },
                            tooltip: "pouria.zeinalzadeh@gmail.com",
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Iconsax.star,
                            // color: Colors.orange,
                          ),
                          title: Text(
                            "Rate This App",
                            style: myTextStyleBold,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Iconsax.arrow_circle_right,
                              // color: Colors.orange,
                            ),
                            onPressed: () {
                              var url = Platform.isAndroid
                                  ? "https://cafebazaar.ir/app/com.weather.weather_app?l=en"
                                  : "https://sibapp.com/";
                              launch(url);
                            },
                            tooltip: Platform.isAndroid
                                ? "CafeBazaar | WeatherApp"
                                : "SibApp | WeatherApp",
                          ),
                        ),
                        Platform.isAndroid
                            ? ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.googlePlay,
                                  // color: Colors.orange,
                                  size: 20,
                                ),
                                title: Text(
                                  "My Other Apps",
                                  style: myTextStyleBold,
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Iconsax.arrow_circle_right,
                                    // color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    var url =
                                        "https://cafebazaar.ir/developer/413934687302?l=en";
                                    launch(url);
                                  },
                                  tooltip: "CafeBazaar | Pouria Zeinalzadeh",
                                ),
                              )
                            : Container(),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: "Data provided by: ",
                              style: myTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: "weatherbit.io",
                              style: myTextStyle.copyWith(
                                fontSize: 14,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: tapGestureRecognizer,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "☕ If you'd like to say thanks, I'd appreciate a coffee :) ☕",
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      var url = "http://www.coffeete.ir/pouria";
                      launch(url);
                    },
                    child: Image.network(
                      "http://www.coffeete.ir/images/buttons/lemonchiffon.png",
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
