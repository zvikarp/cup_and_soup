import 'package:flutter/material.dart';

class NavigationBarWidget extends StatelessWidget {
  NavigationBarWidget({
    Key key,
    @required this.index,
    @required this.tabTapped,
  }) : super(key: key);

  final int index;
  final void Function(int) tabTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[600],
            blurRadius: 5.0,
            spreadRadius: 1.0,
          )
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Theme.of(context).accentColor,
      ),
      child: BottomAppBar(
        elevation: 0,
        color: Theme.of(context).accentColor,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: index != 0
                    ? Theme.of(context).accentIconTheme.color
                    : Theme.of(context).primaryColor,
              ),
              onPressed: () => tabTapped(0),
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: index != 1
                    ? Theme.of(context).accentIconTheme.color
                    : Theme.of(context).primaryColor,
              ),
              onPressed: () => tabTapped(1),
            ),
            IconButton(
              icon: Icon(
                Icons.center_focus_strong,
                color: index != 2
                    ? Theme.of(context).accentIconTheme.color
                    : Theme.of(context).primaryColor,
              ),
              onPressed: () => tabTapped(2),
            ),
            IconButton(
              icon: Icon(
                Icons.star,
                color: index != 3
                    ? Theme.of(context).accentIconTheme.color
                    : Theme.of(context).primaryColor,
              ),
              onPressed: () => tabTapped(3),
            ),
          ],
        ),
      ), //bottomAppBar
    );
  }
}
