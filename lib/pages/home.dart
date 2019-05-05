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

  static String getVersion() => "v0.2.0";
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

  void _getUserData() async {
    Map userData = await cloudFirestoreService.getUserData();
    setState(() {
      _roles = userData['roles'].cast<String>();
    });
    _updatePages();
    if (_roles.contains("admin")) cloudFirestoreService.clearSupriseBox();
    if (userData['disabled']) {
      Navigator.of(context).push(
        TransparentRoute(
          builder: (BuildContext context) => BlockDialog(
                type: "disabled",
              ),
        ),
      );
    }
    var storeStatus = await cloudFirestoreService.loadStoreStatus();
    print(DateTime.now());
    print(storeStatus['closeingDate'].toDate());
    if (DateTime.now().isAfter(storeStatus['closeingDate'].toDate()) &&
        DateTime.now().isBefore(storeStatus['openingDate'].toDate())) {
      if (_roles.contains("admin")) {
        SnackbarWidget.infoBar(context, "The store is closed!");
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
          context, "There is a new version to download from the Play Store!");
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

  @override
  Widget build(BuildContext context) {
    return !_roles.contains("cashRegister")
        ? Scaffold(
            body: _pages[_currentPage] != null
                ? _pages[_currentPage]['page']
                : StorePage(),
            bottomNavigationBar: NavigationBarWidget(
              currentPage: _currentPage,
              lastPage: _lastPage,
              tabTapped: _onTabTaped,
              pages: _pages,
            ),
          )
        : Scaffold(
            body: StorePage(),
          );
  }
}
