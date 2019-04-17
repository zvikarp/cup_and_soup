import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/account/activity.dart';
import 'package:cup_and_soup/widgets/account/balence.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _uid;

  void _getUid() async {
    String uid = await authService.getUid();
    setState(() {
      _uid = uid;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUid();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "account",
      children: _uid != null
          ? <Widget>[
              BalenceWidget(
                uid: _uid,
              ),
              ActivityWidget(
                uid: _uid,
              ),
              // ButtonWidget(
              //   primary: false,
              //   onPressed: () async {
              //     await authService.signOut();
              //     Navigator.push(
              //         context, MaterialPageRoute(builder: (context) => SigninPage()));
              //   },
              //   text: "Sign Out",
              // ),
            ]
          : <Widget>[
              Text("loading..."),
            ],
    );
  }
}
