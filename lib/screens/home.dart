import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:weather_app/screens/favorite/favorites.dart';
import 'package:weather_app/screens/location.dart';
import 'package:weather_app/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;

  List<Widget> _screens = [
    LocationPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: _screens,
            controller: pageController,
            onPageChanged: (value) {
              setState(() {});
            },
            physics: BouncingScrollPhysics(),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
            child: BottomNavigation(
              backgroundColor: Theme.of(context).cardColor,
              items: [
                BottomNavigationItem(
                  controller: pageController,
                  currentIndex: 0,
                  icon: Icon(Iconsax.home_2),
                  selectedIcon: Icon(Iconsax.home_25),
                  onPressed: () {
                    setState(() {
                      pageController.animateToPage(
                        0,
                        duration: Duration(milliseconds: 700),
                        curve: Curves.fastOutSlowIn,
                      );
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                ),
                BottomNavigationItem(
                  controller: pageController,
                  currentIndex: 1,
                  icon: Icon(Iconsax.heart),
                  selectedIcon: Icon(Iconsax.heart5),
                  onPressed: () {
                    setState(() {
                      pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 700),
                        curve: Curves.fastOutSlowIn,
                      );
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
