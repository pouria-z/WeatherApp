import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/all_cities.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather_app/info.dart';

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
final cityname = TextEditingController();
bool showClear = false;

class LocCurrentWeather {
  final icon;
  final temp;
  final desc;
  final wind;
  final code;
  LocCurrentWeather(this.icon, this.temp, this.desc, this.wind, this.code);

}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                  ),
                  ListTile(
                    leading: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    trailing: Container(height: 2, width: 10, color: Colors.white),
                  ),
                  ListTile(
                    leading: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    trailing: Container(height: 2, width: 10, color: Colors.white),
                  ),
                  ListTile(
                    leading: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    title: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    trailing: Container(height: 2, width: 10, color: Colors.white),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/90,
                  ),
                  Divider(
                    thickness: 0.2,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/4.5,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 16,
                      itemBuilder: (context, index) {
                        return ForecastCard(icon: 'c01n',);
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

class ForecastCard extends StatelessWidget {

  final date;
  final temp;
  final icon;

  const ForecastCard({Key key, this.date, this.temp, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width/3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date != null ? date.toString() : "",
              style: myTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 15,
              ),
            ),
            Image.asset(
              'assets/icons/$icon.png',
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.height / 10,
            ),
            Text(
              temp.toString()+"°",
              style: myTextStyle,
            ),
          ],
        ),
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
  final searchIcon;

  const SearchBox({Key key, this.locIcon, this.onSubmitted, this.sizedBoxWidth,
    this.offset, this.searchIcon, this.onSuggestionSelected}) : super(key: key);


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
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  blurRadius: 7,
                  spreadRadius: 1,
                  color: Colors.black87,
                  offset: Offset.fromDirection(4,-2)
              ),
            ]
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            IconButton(
              icon: Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) => Info(),
                ));
                },
            ),
            widget.locIcon,
            SizedBox(
              width: widget.sizedBoxWidth,
            ),
            Expanded(
              child: TypeAheadField(
                suggestionsCallback: (String pattern) async {
                  return CitiesService.cities.where((item) => item.
                  toLowerCase().startsWith(pattern.toLowerCase())).toList();
                },
                itemBuilder: (context, suggestion){
                  return ListTile(
                    leading: Icon(Icons.search_rounded,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height/35,
                    ),
                    title: Text(suggestion,
                      style: myTextStyle,
                    ),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  if (cityname.text.length >= 3){
                    return suggestionsBox;
                  }
                  else {
                    return null;
                  }
                },
                onSuggestionSelected: widget.onSuggestionSelected,
                noItemsFoundBuilder: (context) => ListTile(
                  title: Text(
                    "No Item Found!",
                    style: myTextStyle
                  ),
                  leading: Icon(Icons.dangerous,
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
                    width: MediaQuery.of(context).size.width -30,
                  ),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  textCapitalization: TextCapitalization.words,
                  style: myTextStyle.copyWith(fontSize: 16),
                  cursorColor: Colors.white,
                  cursorWidth: 1.5,
                  controller: cityname,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    icon: Hero(
                      tag: 'search',
                      child: Icon(Icons.search_rounded,
                        color: Colors.white60,
                      ),
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.height/50,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      showClear=true;
                    });
                    if(value.toString()==""){
                      setState(() {
                        showClear=false;
                      });
                    }
                  },
                  onSubmitted: widget.onSubmitted,
                ),
                suggestionsBoxVerticalOffset: 6,
              ),
            ),
            showClear==true ? IconButton(
              icon: Icon(Icons.clear_rounded),
              onPressed: () {
                cityname.clear();
                setState(() {
                  showClear=false;
                });
              },
            ) : Container(),
          ],
        ),
      ),
    );
  }
}












