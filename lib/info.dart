import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        backgroundColor: Theme.of(context).primaryColor,
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
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 4,
                        blurRadius: 20,
                        offset: Offset(0, 12)),
                  ]),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: Icon(FontAwesomeIcons.solidEnvelope),
                        title: Text(
                          "Contact Me",
                          style: myTextStyleBold,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: () {
                            var url = "mailto:pouria.zeinalzadeh@gmail.com?subject=Weather App";
                            launch(url);
                          },
                          tooltip: "pouria.zeinalzadeh@gmail.com",
                        ),
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.solidStar),
                        title: Text(
                          "Rate This App",
                          style: myTextStyleBold,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: () {
                            var url =
                                "https://cafebazaar.ir/app/com.weather.weather_app?l=en";
                            launch(url);
                          },
                          tooltip: "CafeBazaar | WeatherApp",
                        ),
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.googlePlay),
                        title: Text(
                          "My Other Apps",
                          style: myTextStyleBold,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            var url =
                                "https://cafebazaar.ir/developer/413934687302?l=en";
                            launch(url);
                          },
                          tooltip: "CafeBazaar | Pouria Zeinalzadeh",
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
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
                          ]
                        ),
                      ),
                    ],
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
