import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class NavigationBarWidget extends StatelessWidget {
  NavigationBarWidget({
    Key key,
    @required this.currentPage,
    @required this.lastPage,
    @required this.tabTapped,
    @required this.pages,
  }) : super(key: key);

  final String currentPage;
  final String lastPage;
  final void Function(String) tabTapped;
  final Map<String, Map<String, dynamic>> pages;

  List<Widget> appBarIcons(BuildContext context) {
    List<Widget> buttons = [];
    pages.values.forEach((page) {
      String thisPage =
          pages.keys.toList()[pages.values.toList().indexOf(page)];
      buttons.add(
        Center(
          child: GestureDetector(
            onTap: () => tabTapped(thisPage),
            child: Container(
              height: 36,
              width: 36,
              child: FlareActor(page['icon'],
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: (currentPage == thisPage) ? "onClick" : 
                  (lastPage == thisPage) ? "onLeave" : "idle",
                  //   color: currentPage != thisPage
                  //       ? Colors.white70
                  //       : Theme.of(context).primaryColor,
                  // ),
                  ),
            ),
          ),
        ),
      );
    });
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(0, -5),
          child: Image.asset(
            "assets/images/navBar.png",
            height: 70,
            width: double.infinity,
            alignment: Alignment(0, -1),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          height: 70,
          color: Colors.black,
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
