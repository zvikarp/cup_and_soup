import 'package:flutter/material.dart';

import 'package:cup_and_soup/pages/home/store.dart';
import 'package:cup_and_soup/pages/home/account.dart';
import 'package:cup_and_soup/pages/home/scanner.dart';
import 'package:cup_and_soup/pages/home/admin.dart';
import 'package:cup_and_soup/widgets/home/navigationBar.dart';
import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAdmin = false;
  String _role = "cashRegister";

  final List<Widget> pages = [
    AccountPage(),
    StorePage(),
  ];
  int _currentPage = 1;

  void getRole() async {
    String role = await authService.getRole();
    setState(() {
      _role = role;
      _isAdmin = role == 'admin';
      if (_isAdmin) {
        pages.add(AdminPage());
        pages.removeAt(1);
        pages.insert(
            1,
            StorePage(
              isAdmin: true,
            ));
        cloudFirestoreService.clearSupriseBox();
      }
    });
  }

  void addScanner() {
    pages.add(ScannerPage(
      goToStore: () => _onTabTaped(1),
    ));
  }

  @override
  void initState() {
    super.initState();
    addScanner();
    getRole();
    cloudFirestoreService.getRequests();
  }

  void _onTabTaped(int tab) {
    setState(() {
      _currentPage = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _role != "cashRegister"
        ? Scaffold(
            body: pages[_currentPage],
            bottomNavigationBar: NavigationBarWidget(
              index: _currentPage,
              tabTapped: _onTabTaped,
              isAdmin: _isAdmin,
            ),
          )
        : Scaffold(
            body: StorePage(),
          );
  }
}
