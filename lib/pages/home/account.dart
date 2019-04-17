import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/account/activity.dart';
import 'package:cup_and_soup/widgets/account/balence.dart';
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
              BalenceWidget(
                uid: _uid,
                userData: _userData,
              ),
              Padding(
                padding: EdgeInsets.all(45),
                child: Image.asset(
                  "assets/images/divider.png",
                  width: 50,
                ),
              ),
              SettingsWidget(
                uid: _uid,
                userData: _userData,
              ),
              Padding(
                padding: EdgeInsets.all(45),
                child: Image.asset(
                  "assets/images/divider.png",
                  width: 50,
                ),
              ),
              ActivityWidget(
                uid: _uid,
              ),
              SizedBox(height: 42)
            ]
          : <Widget>[
              Text("loading..."),
            ],
    );
  }
}
