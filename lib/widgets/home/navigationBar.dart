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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Colors.grey[900],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        currentIndex: index,
        onTap: tabTapped,
        fixedColor: Colors.yellow[700],
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("Account"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Shop"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.aspect_ratio),
            title: Text("Scanner"),
          ),
        ],
      ),
    );
  }
}
