import 'package:flutter/material.dart';
import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/pages/signin.dart';

class AccountPage extends StatefulWidget {

  AccountPage({Key key}) : super(key: key);

  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("account page"),
          RaisedButton(
            onPressed: () async {
              await authService.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => SigninPage()));
            },
            child: Text("signout"),
          ),
        ],
      )),
    );
  }
}