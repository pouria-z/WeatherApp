import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/widgets.dart';


class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  void contactMe() async {
    var url = "mailto:pouria.zeinalzadeh@gmail.com";
    launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Info",
          style: myTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: MediaQuery.of(context).size.height/5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    leading: Icon(Icons.email,
                      color: Colors.white,
                      size: 25,
                    ),
                    title: Text(
                      "Contact Me",
                      style: myTextStyleBold,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: contactMe,
                      tooltip: "pouria.zeinalzadeh@gmail.com",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Using following API:",
                  style: myTextStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
                Linkify(
                  onOpen: _onOpen,
                  text: "https://www.weatherbit.io",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}