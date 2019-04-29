import 'package:cup_and_soup/pages/home.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/account/activity.dart';
import 'package:cup_and_soup/widgets/account/balance.dart';
import 'package:cup_and_soup/widgets/account/settings.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _uid;
  Map<String, dynamic> _userData;
  bool _upToDate = true;

  void _getData() async {
    String uid = await authService.getUid();
    Map<String, dynamic> userData = await cloudFirestoreService.loadUserData();
    bool upToDate = await HomePage.newVersion();
    setState(() {
      _uid = uid;
      _userData = userData;
      _upToDate = upToDate;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "account",
      children: _uid != null && _userData != null
          ? <Widget>[
              BalanceWidget(
                uid: _uid,
                userData: _userData,
              ),
              DividerWidget(),
              ActivityWidget(
                uid: _uid,
              ),
              DividerWidget(),
              SettingsWidget(
                uid: _uid,
                userData: _userData,
              ),
              DividerWidget(),
              Text(
                "cup&soup (c) 2019 Zvi Karp | version " + HomePage.getVersion(),
                style: TextStyle(
                  fontFamily: "PrimaryFont",
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                child: Text(
                  !_upToDate
                      ? "There is a new version to download from the Play Store!"
                      : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "PrimaryFont",
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 36),
            ]
          : <Widget>[
              Text("loading..."),
            ],
    );
  }
}
