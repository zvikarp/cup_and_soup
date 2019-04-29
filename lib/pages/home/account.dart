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


  void _getData() async {
    String uid = await authService.getUid();
    Map<String, dynamic> userData = await cloudFirestoreService.loadUserData();
    setState(() {
      _uid = uid;
      _userData = userData;
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
              SizedBox(height: 42)
            ]
          : <Widget>[
              Text("loading..."),
            ],
    );
  }
}
