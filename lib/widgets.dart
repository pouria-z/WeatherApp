import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/all_cities.dart';
import 'package:weather_app/info.dart';
import 'package:iconsax/iconsax.dart';

const myTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontFamily: 'Roboto',
);
const myTextStyleBold = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
);
final cityName = TextEditingController();
bool showClear = false;

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/mintemp.png',
                      width: MediaQuery.of(context).size.width / 12,
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    trailing:
                        Container(height: 2, width: 10, color: Colors.white),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/maxtemp.png',
                      width: MediaQuery.of(context).size.width / 12,
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    trailing:
                        Container(height: 2, width: 10, color: Colors.white),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/icons/wind.png',
                      width: MediaQuery.of(context).size.width / 12,
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    trailing:
                        Container(height: 2, width: 10, color: Colors.white),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 90,
                  ),
                  Divider(
                    thickness: 0.2,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4.5,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 16,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          'assets/icons/c01n.png',
                          width: MediaQuery.of(context).size.width / 3,
                          color: Colors.white,
                        );
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

class ForecastCard extends StatefulWidget {
  final date;
  final temp;
  final icon;

  const ForecastCard({Key key, this.date, this.temp, this.icon})
      : super(key: key);

  @override
  _ForecastCardState createState() => _ForecastCardState();
}

class _ForecastCardState extends State<ForecastCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 30,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.date != null ? widget.date.toString() : "",
            style: myTextStyle.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: MediaQuery.of(context).size.height / 50,
            ),
          ),
          Image.asset(
            'assets/icons/${widget.icon}.png',
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.height / 10,
          ),
          Text(
            " " + widget.temp.toString() + "°",
            style: myTextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height / 35,
            ),
          ),
        ],
      ),
    );
  }
}

class ForecastCardList extends StatefulWidget {
  const ForecastCardList({
    Key key,
    @required this.fCityList,
    @required this.fDateList,
    @required this.fTempList,
    @required this.fIconList,
  }) : super(key: key);

  final List fCityList;
  final List fDateList;
  final List fTempList;
  final List fIconList;

  @override
  _ForecastCardListState createState() => _ForecastCardListState();
}

class _ForecastCardListState extends State<ForecastCardList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.fCityList.length,
        itemBuilder: (context, index) {
          return ForecastCard(
            date: widget.fDateList[index],
            temp: widget.fTempList[index],
            icon: widget.fIconList[index],
          );
        },
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  final locIcon;
  final onSuggestionSelected;
  final onSubmitted;
  final sizedBoxWidth;
  final offset;
  final favoriteWidget;

  const SearchBox({
    Key key,
    this.locIcon,
    this.onSubmitted,
    this.sizedBoxWidth,
    this.offset,
    this.onSuggestionSelected,
    this.favoriteWidget,
  }) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 54,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ]),
        child: Row(
          children: [
            SizedBox(width: 10),
            IconButton(
              icon: Icon(
                Iconsax.info_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Info(),
                  ),
                );
              },
              splashRadius: 20,
            ),
            widget.locIcon,
            SizedBox(
              width: widget.sizedBoxWidth,
            ),
            Expanded(
              child: TypeAheadField(
                suggestionsCallback: (String pattern) async {
                  return CitiesService.cities
                      .where((item) =>
                          item.toLowerCase().startsWith(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(
                      Iconsax.search_normal_1,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height / 35,
                    ),
                    title: Text(
                      suggestion,
                      style: myTextStyle,
                    ),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  if (cityName.text.length >= 3) {
                    return suggestionsBox;
                  } else {
                    return null;
                  }
                },
                onSuggestionSelected: widget.onSuggestionSelected,
                noItemsFoundBuilder: (context) => ListTile(
                  title: Text("No Item Found!", style: myTextStyle),
                  leading: Icon(
                    Iconsax.danger,
                    color: Colors.white,
                  ),
                ),
                hideSuggestionsOnKeyboardHide: true,
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  offsetX: widget.offset,
                  constraints: BoxConstraints.tightFor(
                    width: MediaQuery.of(context).size.width - 30,
                  ),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  textCapitalization: TextCapitalization.words,
                  style: myTextStyle.copyWith(fontSize: 16),
                  cursorColor: Colors.white,
                  cursorWidth: 1.5,
                  controller: cityName,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    icon: Icon(
                      Iconsax.search_normal,
                      color: Colors.white60,
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      showClear = true;
                    });
                    if (value.toString() == "") {
                      setState(() {
                        showClear = false;
                      });
                    }
                  },
                  onSubmitted: widget.onSubmitted,
                ),
                suggestionsBoxVerticalOffset: 6,
              ),
            ),
            showClear == true
                ? IconButton(
                    icon: Icon(Icons.clear_rounded),
                    onPressed: () {
                      cityName.clear();
                      setState(() {
                        showClear = false;
                      });
                    },
                    splashRadius: 20,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ListTiles extends StatefulWidget {
  final minTemp;
  final maxTemp;
  final wind;

  const ListTiles({Key key, this.minTemp, this.maxTemp, this.wind})
      : super(key: key);

  @override
  _ListTilesState createState() => _ListTilesState();
}

class _ListTilesState extends State<ListTiles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        ListTile(
          leading: Image.asset(
            'assets/icons/mintemp.png',
            width: MediaQuery.of(context).size.width / 12,
            height: MediaQuery.of(context).size.height / 25,
          ),
          title: Text(
            "Min Temperature",
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height / 50,
            ),
          ),
          trailing: Text(
            widget.minTemp,
            style: myTextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height / 50,
            ),
          ),
        ),
        ListTile(
          leading: Image.asset(
            'assets/icons/maxtemp.png',
            width: MediaQuery.of(context).size.width / 12,
            height: MediaQuery.of(context).size.height / 20,
          ),
          title: Text(
            "Max Temperature",
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height / 50,
            ),
          ),
          trailing: Text(
            widget.maxTemp,
            style: myTextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height / 50,
            ),
          ),
        ),
        ListTile(
          leading: Image.asset(
            'assets/icons/wind.png',
            width: MediaQuery.of(context).size.width / 12,
            height: MediaQuery.of(context).size.height / 25,
          ),
          title: Text(
            "Wind Speed",
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height / 50,
            ),
          ),
          trailing: Text(
            widget.wind,
            style: myTextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height / 50,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 90,
        ),
        Divider(
          thickness: 0.2,
          color: Colors.white24,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
      ],
    );
  }
}

class CurrentWeatherWidget extends StatefulWidget {
  final String imagePath;
  final String cityName;
  final url;
  final temperature;
  final String iconPath;
  final String description;

  const CurrentWeatherWidget({
    Key key,
    @required this.imagePath,
    @required this.cityName,
    @required this.url,
    @required this.temperature,
    @required this.iconPath,
    @required this.description,
  }) : super(key: key);

  @override
  _CurrentWeatherWidgetState createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var area = (size.height) * (size.width);
    return Container(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              widget.imagePath,
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height / 18,
                    width: size.width / 1.2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.cityName != null &&
                                widget.url.toString().contains('city')
                            ? widget.cityName.toString()
                            : widget.cityName != null
                                ? "📍" + widget.cityName.toString()
                                : "Loading",
                        style: myTextStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: widget.imagePath == 'assets/images/snow.jpg' ||
                                  widget.imagePath == 'assets/images/mist.jpg'
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: size.height / 13,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    widget.temperature != null
                        ? " " + widget.temperature.toString() + "°"
                        : "",
                    style: myTextStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: widget.imagePath == 'assets/images/snow.jpg' ||
                              widget.imagePath == 'assets/images/mist.jpg'
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              Image.asset(
                'assets/icons/${widget.iconPath.toString()}.png',
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 3,
              ),
              Container(
                height: size.height / 50,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    widget.description != null
                        ? widget.description.toString()
                        : "Loading",
                    style: TextStyle(
                      color: widget.imagePath == 'assets/images/mist.jpg'
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        alignment: Alignment.center,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
    );
  }
}
