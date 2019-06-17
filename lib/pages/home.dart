import 'dart:async';

import 'package:cup_and_soup/models/user.dart';
import 'package:cup_and_soup/utils/localizations.dart';
import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/services/firebaseMessaging.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/dialogs/block.dart';
import 'package:cup_and_soup/pages/home/insider.dart';
import 'package:cup_and_soup/pages/home/store.dart';
import 'package:cup_and_soup/pages/home/account.dart';
import 'package:cup_and_soup/pages/home/scanner.dart';
import 'package:cup_and_soup/pages/home/admin.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:cup_and_soup/widgets/home/navigationBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();

  static String getVersion() => "v0.3.0";
  static Future<bool> newVersion() async {
    String lastVersion = await cloudFirestoreService.getLastVersion();
    return (getVersion() == lastVersion);
  }
}

class _HomePageState extends State<HomePage> {
  List<String> _roles = [];

  Map<String, Map<String, dynamic>> _allPages = {
    'account': {
      'icon': "assets/flare/user.flr",
      'page': AccountPage(),
    },
    'store': {
      'icon': "assets/flare/basket.flr",
      'page': StorePage(),
    },
    'admin': {
      'icon': "assets/flare/lock.flr",
      'page': AdminPage(),
    },
    'scanner': {
      'icon': "assets/flare/barcode.flr",
      'page': ScannerPage(goToStore: () => null)
    },
    'insider': {
      'icon': "assets/flare/star.flr",
      'page': InsiderPage(),
    },
  };

  Map<String, Map<String, dynamic>> _pages = {};
  String _currentPage = 'store';
  String _lastPage = "";
  PageController pageCtr = PageController();

  void _updateUserRoles(List<String> roles) {
    setState(() {
      _roles = roles;
    });
    if (_roles.contains("admin")) cloudFirestoreService.clearSupriseBox();
    _updatePages();
  }

  void _getUserData() async {
    cloudFirestoreService.streamUserData().listen((User user) {
      if (user.roles != _roles) _updateUserRoles(user.roles);

      if (user.disabled) {
        Navigator.of(context).push(
          TransparentRoute(
            builder: (BuildContext context) => BlockDialog(
                  type: "disabled",
                ),
          ),
        );
      }
    });
    // Map userData = await cloudFirestoreService.getUserData();
    // setState(() {
    //   _roles = userData['roles'].cast<String>();
    // });
    // _updatePages();
    var storeStatus = await cloudFirestoreService.loadStoreStatus();
    if (DateTime.now().isAfter(storeStatus['closeingDate'].toDate()) &&
        DateTime.now().isBefore(storeStatus['openingDate'].toDate())) {
      if (_roles.contains("admin")) {
        SnackbarWidget.infoBar(context, translate.text("home:p-storeClosed-sb"));
      } else {
        Navigator.of(context).push(
          TransparentRoute(
            builder: (BuildContext context) =>
                BlockDialog(type: "closed", storeStatus: storeStatus),
          ),
        );
      }
    }
  }

  void _updatePages() {
    Map<String, Map<String, dynamic>> pages = {};
    if (_roles.contains('customer')) {
      pages.putIfAbsent('account', () => _allPages['account']);
      pages.putIfAbsent('store', () => _allPages['store']);
      pages.putIfAbsent('scanner', () => _allPages['scanner']);
    }
    if (_roles.contains('admin')) {
      pages.putIfAbsent('admin', () => _allPages['admin']);
      pages.putIfAbsent('store', () => _allPages['store']);
      _allPages['store']['page'] = StorePage(isAdmin: true);
    }
    if (_roles.contains('insider')) {
      pages.putIfAbsent('insider', () => _allPages['insider']);
    }
    setState(() {
      _pages = pages;
    });
  }

  void _checkForUpdates() async {
    bool upToDate = await HomePage.newVersion();
    if (!upToDate) {
      SnackbarWidget.infoBar(
          context, translate.text("home:p-newVersion-sb"));
    }
  }

  @override
  void initState() {
    super.initState();
    firebaseMessagingService.firebaseCloudMessagingListeners(context);
    setState(() {
      _allPages['scanner']['page'] =
          ScannerPage(goToStore: () => _onTabTaped('store'));
    });
    _getUserData();
    cloudFirestoreService.getRequests();
    _checkForUpdates();
  }

  void _onTabTaped(String page) {
    setState(() {
      _lastPage = _currentPage;
      _currentPage = page;
    });
  }

  Widget _content() {
    if (_pages[_currentPage] != null) {
      return  _pages[_currentPage]['page'];
    } else {
      return StorePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return (!_roles.contains("cashRegister") && _pages.length > 0)
        ? Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Stack(
                children: <Widget>[
              //     PageView(
              //       controller: pageCtr,
              //       // physics: NeverScrollableScrollPhysics(),
              //       children: (_pages.keys
              //               .toList()
              //               .map<Widget>((page) => _pages[page]['page']))
              //           .toList(),
              //       onPageChanged: (pos) {
              //         setState(() {
              //           _currentPage = pos;
              //         });
              //       },
              //     ),
                  Theme(
                      data: Theme.of(context)
                          .copyWith(canvasColor: themes.load("canvasColor")),
                      child: _content()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: NavigationBarWidget(
                      currentPage: _currentPage,
                      lastPage: _lastPage,
                      tabTapped: _onTabTaped,
                      pages: _pages,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: StorePage(),
          );
  }
}
