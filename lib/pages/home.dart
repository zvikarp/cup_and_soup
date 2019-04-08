import 'package:flutter/material.dart';

import 'package:cup_and_soup/pages/shop.dart';
import 'package:cup_and_soup/pages/account.dart';
import 'package:cup_and_soup/pages/scanner.dart';
import 'package:cup_and_soup/widgets/home/navigationBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pages = [
    AccountPage(),
    ShopPage(),
    ScannerPage(),
  ];
  int _currentPage = 1;

  void _onTabTaped(int tab) {
    setState(() {
      _currentPage = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentPage],
      bottomNavigationBar: NavigationBarWidget(
        index: _currentPage,
        tabTapped: _onTabTaped,
      ),
    );
  }
}
