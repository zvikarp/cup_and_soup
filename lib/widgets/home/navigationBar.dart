import 'package:flutter/material.dart';

class NavigationBarWidget extends StatelessWidget {
  NavigationBarWidget({
    Key key,
    @required this.currentPage,
    @required this.tabTapped,
    @required this.pages,
  }) : super(key: key);

  final String currentPage;
  final void Function(String) tabTapped;
  final Map<String, Map<String, dynamic>> pages;

  List<Widget> appBarIcons(BuildContext context) {
    List<Widget> buttons = [];
    pages.values.forEach((page) {
      String thisPage = pages.keys.toList()[pages.values.toList().indexOf(page)];
      buttons.add(
        IconButton(
          icon: Icon(
            page['icon'],
            color: currentPage != thisPage ? Colors.white70 : Theme.of(context).primaryColor,
          ),
          onPressed: () => tabTapped(thisPage),
        ),
      );
    });
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/navBar.png",
          height: 70,
          width: double.infinity,
          alignment: Alignment(0, -1),
          fit: BoxFit.cover,
        ),
        Container(
          alignment: Alignment.bottomCenter,
          height: 63,
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: appBarIcons(context),
          ),
        ),
      ],
    );
  }
}
