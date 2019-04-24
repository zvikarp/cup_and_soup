import 'package:flutter/material.dart';

class NavigationBarWidget extends StatelessWidget {
  NavigationBarWidget({
    Key key,
    @required this.index,
    @required this.tabTapped,
    @required this.isAdmin,
  }) : super(key: key);

  final int index;
  final void Function(int) tabTapped;
  final bool isAdmin;

  List<Widget> appBarIcons(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.account_circle,
          color: index != 0 ? Colors.white70 : Theme.of(context).primaryColor,
        ),
        onPressed: () => tabTapped(0),
      ),
      IconButton(
        icon: Icon(
          Icons.shopping_cart,
          color: index != 1 ? Colors.white70 : Theme.of(context).primaryColor,
        ),
        onPressed: () => tabTapped(1),
      ),
      IconButton(
        icon: Icon(
          Icons.center_focus_strong,
          color: index != 2 ? Colors.white70 : Theme.of(context).primaryColor,
        ),
        onPressed: () => tabTapped(2),
      ),
    ];
  }

  List<Widget> adminAppBarWIcons(BuildContext context) {
    List<Widget> list = appBarIcons(context);
    list.add(IconButton(
      icon: Icon(
        Icons.star,
        color: index != 3 ? Colors.white70 : Theme.of(context).primaryColor,
      ),
      onPressed: () => tabTapped(3),
    ));
    return list;
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
            children:
                isAdmin ? adminAppBarWIcons(context) : appBarIcons(context),
          ),
        ),
      ],
    );
  }
}
