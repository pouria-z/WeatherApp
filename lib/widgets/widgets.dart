import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/all_cities.dart';
import 'package:weather_app/screens/info.dart';
import 'package:iconsax/iconsax.dart';

final textEditingController = TextEditingController();
bool showClear = false;

class TopLoading extends StatelessWidget {
  const TopLoading({
    Key? key,
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
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                ),
                trailing: Container(height: 2, width: 10, color: Colors.white),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/icons/maxtemp.png',
                  width: MediaQuery.of(context).size.width / 12,
                  height: MediaQuery.of(context).size.height / 25,
                ),
                title: Container(
                  height: 5,
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                ),
                trailing: Container(height: 2, width: 10, color: Colors.white),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/icons/wind.png',
                  width: MediaQuery.of(context).size.width / 12,
                  height: MediaQuery.of(context).size.height / 25,
                ),
                title: Container(
                  height: 5,
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                ),
                trailing: Container(height: 2, width: 10, color: Colors.white),
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
        ),
      ),
      baseColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class BottomLoading extends StatelessWidget {
  const BottomLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
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
              title: Container(
                height: 5,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              ),
              trailing: Container(height: 2, width: 10, color: Colors.white),
            ),
            ListTile(
              leading: Image.asset(
                'assets/icons/maxtemp.png',
                width: MediaQuery.of(context).size.width / 12,
                height: MediaQuery.of(context).size.height / 25,
              ),
              title: Container(
                height: 5,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              ),
              trailing: Container(height: 2, width: 10, color: Colors.white),
            ),
            ListTile(
              leading: Image.asset(
                'assets/icons/wind.png',
                width: MediaQuery.of(context).size.width / 12,
                height: MediaQuery.of(context).size.height / 25,
              ),
              title: Container(
                height: 5,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              ),
              trailing: Container(height: 2, width: 10, color: Colors.white),
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
      ),
      baseColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class ForecastCard extends StatefulWidget {
  const ForecastCard({Key? key, this.date, this.temp, this.icon, this.minTemp, this.maxTemp})
      : super(key: key);

  final date;
  final temp;
  final icon;
  final minTemp;
  final maxTemp;

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
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.date != null ? widget.date.toString() : "",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          Image.asset(
            'assets/icons/${widget.icon}.png',
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.height / 10,
          ),
          Text(
            " " + widget.temp.toString() + "°",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\n ${widget.minTemp.toString()}°",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
              Text(
                "\n  /  ${widget.maxTemp.toString()}°",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  final Widget locIcon;
  final onSuggestionSelected;
  final onSubmitted;
  final double? sizedBoxWidth;
  final double offset;
  final favoriteWidget;

  const SearchBox({
    Key? key,
    required this.locIcon,
    this.onSubmitted,
    this.sizedBoxWidth,
    required this.offset,
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
      child: SlideInDown(
        from: MediaQuery.of(context).size.height,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 54,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(17),
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
                        .where((item) => item.toLowerCase().startsWith(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, dynamic suggestion) {
                    return ListTile(
                      leading: Icon(
                        Iconsax.search_normal_1,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.height / 35,
                      ),
                      title: Text(
                        suggestion,
                      ),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    if (textEditingController.text.length >= 3) {
                      return suggestionsBox;
                    } else {
                      return SizedBox();
                    }
                  },
                  onSuggestionSelected: widget.onSuggestionSelected,
                  noItemsFoundBuilder: (context) => ListTile(
                    title: Text("No Item Found!"),
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
                    cursorColor: Colors.white,
                    cursorWidth: 1.5,
                    controller: textEditingController,
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
                        textEditingController.clear();
                        setState(() {
                          showClear = false;
                        });
                      },
                      splashRadius: 20,
                    )
                  : Container(),
              widget.favoriteWidget,
            ],
          ),
        ),
      ),
    );
  }
}

class ListTiles extends StatefulWidget {
  final minTemp;
  final maxTemp;
  final wind;

  const ListTiles({Key? key, this.minTemp, this.maxTemp, this.wind}) : super(key: key);

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
          title: Text("Min Temperature"),
          trailing: Text(
            widget.minTemp,
          ),
        ),
        ListTile(
          leading: Image.asset(
            'assets/icons/maxtemp.png',
            width: MediaQuery.of(context).size.width / 12,
            height: MediaQuery.of(context).size.height / 20,
          ),
          title: Text("Max Temperature"),
          trailing: Text(
            widget.maxTemp,
          ),
        ),
        ListTile(
          leading: Image.asset(
            'assets/icons/wind.png',
            width: MediaQuery.of(context).size.width / 12,
            height: MediaQuery.of(context).size.height / 25,
          ),
          title: Text("Wind Speed"),
          trailing: Text(
            widget.wind,
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
  const CurrentWeatherWidget({
    Key? key,
    required this.imagePath,
    required this.cityName,
    required this.isFavorite,
    required this.url,
    required this.temperature,
    required this.iconPath,
    required this.description,
  }) : super(key: key);

  final String? imagePath;
  final String? cityName;
  final bool isFavorite;
  final url;
  final temperature;
  final String? iconPath;
  final String? description;

  @override
  _CurrentWeatherWidgetState createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              widget.imagePath!,
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
                        (widget.cityName != null && widget.url.toString().contains('city')) ||
                                widget.isFavorite
                            ? widget.cityName.toString()
                            : widget.cityName != null
                                ? "📍" + widget.cityName.toString()
                                : "Loading",
                        style: TextStyle(
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
                    widget.temperature != null ? " " + widget.temperature.toString() + "°" : "",
                    style: TextStyle(
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
                    widget.description != null ? widget.description.toString() : "Loading",
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
          color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(40)),
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key? key,
    required this.items,
    required this.backgroundColor,
  }) : super(key: key);

  final List<BottomNavigationItem> items;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      from: MediaQuery.of(context).size.height,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 6,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 1,
              color: Colors.black12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        ),
      ),
    );
  }
}

class BottomNavigationItem extends StatefulWidget {
  const BottomNavigationItem({
    Key? key,
    required this.controller,
    required this.currentIndex,
    required this.icon,
    required this.onPressed,
    this.title,
    this.selectedIcon,
    this.shape,
  }) : super(key: key);

  final PageController controller;
  final int currentIndex;
  final Icon icon;
  final void Function() onPressed;
  final String? title;
  final Icon? selectedIcon;
  final ShapeBorder? shape;

  @override
  State<BottomNavigationItem> createState() => _BottomNavigationItemState();
}

class _BottomNavigationItemState extends State<BottomNavigationItem> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget iconWidget() {
      if (widget.controller.page == null) {
        return widget.icon;
      } else {
        if (widget.controller.page!.round() != widget.currentIndex) {
          return widget.icon;
        } else {
          return widget.selectedIcon ?? widget.icon;
        }
      }
    }

    Widget indicator() {
      if (widget.controller.page == null) {
        return Container();
      } else {
        if (widget.controller.page!.round() == widget.currentIndex) {
          return BounceInUp(
            from: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFEF233C),
                borderRadius: BorderRadius.circular(10),
              ),
              width: 4,
              height: 4,
            ),
          );
        } else {
          return Container();
        }
      }
    }

    return Expanded(
      child: MaterialButton(
        onPressed: widget.onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget(),
            indicator(),
          ],
        ),
        shape: widget.shape ?? RoundedRectangleBorder(),
      ),
    );
  }
}
