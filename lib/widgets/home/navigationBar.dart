import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:transparent_image/transparent_image.dart';

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
              child: FlareActor(
                page['icon'],
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: (currentPage == thisPage)
                    ? "onClick"
                    : (lastPage == thisPage) ? "onLeave" : "idle",
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
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage(
            "assets/images/navigation.png",
          ),
          // child: Container(
          //   height: 70,
          //   width: 500,
          //   child: SvgPicture.asset(
          //     "assets/images/navBar.svg",
          //     // height: 70,
          //     color: Colors.yellow,
          //     // fit: BoxFit.cover,
          //     // alignment: Alignment(0, -1),
          //     // width: 1000,
          //   ),
          // ),
          height: 70,
          width: double.infinity,
          alignment: Alignment(0, -1),
          fit: BoxFit.cover,
        ),
        Container(
          alignment: Alignment.bottomCenter,
          height: 70,
          child: Transform.translate(
            offset: Offset(0, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: appBarIcons(context),
            ),
          ),
        ),
      ],
    );
  }
}
