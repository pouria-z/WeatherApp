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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Info",
          style: myTextStyleBold,
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: MediaQuery.of(context).size.height/3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset.fromDirection(10,-4)
                ),
              ]
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(
                        "Contact Me",
                        style: myTextStyleBold,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: () {
                          var url = "mailto:pouria.zeinalzadeh@gmail.com";
                          launch(url);
                        },
                        tooltip: "pouria.zeinalzadeh@gmail.com",
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.star_rounded),
                      title: Text(
                        "Rate This App",
                        style: myTextStyleBold,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: () {
                          var url = "https://cafebazaar.ir/app/com.weather.weather_app?l=en";
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
                        icon: Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          var url = "https://cafebazaar.ir/developer/413934687302?l=en";
                          launch(url);
                        },
                        tooltip: "CafeBazaar | Pouria Zeinalzadeh",
                      ),
                    ),
                    Text(
                      "Using following API:",
                      style: myTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var url="https://www.weatherbit.io";
                        launch(url);
                      },
                      child: Text(
                        "www.weatherbit.io",
                        style: myTextStyle.copyWith(
                          fontSize: 14,
                          color: Colors.blue[700],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}