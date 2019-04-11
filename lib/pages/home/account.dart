import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/pages/signin.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/center.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/widgets/core/list.dart';
import 'package:cup_and_soup/widgets/core/listItem.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  List<Map<String, dynamic>> historyList = [
    {
      "title": "title 1",
      "subtitle": "subtitle 1",
      "price": "25",
    },
    {
      "title": "title 2",
      "subtitle": "subtitle 2",
      "price": "6554",
    },
    {
      "title": "title 3",
      "subtitle": "subtitle 3",
      "price": "43",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "account",
      children: <Widget>[
        Text(
          "Your account balence:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        CenterWidget(
          child: Center(
            child: Text(
              "24.6",
              style: TextStyle(
                fontFamily: "PrimaryFont",
                fontSize: 42,
                color: Theme.of(context).primaryColor
              ),
            ),
          ),
        ),
        Text(
          "Full transsaction history:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        
        ListWidget(
          headings: ["title", "subtitle", "price"],
          items: (historyList.map((item) => ListItemWidget(
            title: item["title"],
            subTitle: item["subtitle"],
            price: item["price"],
          )).toList()
          ),
        ),

        ButtonWidget(
          primary: false,
          onPressed: () async {
            await authService.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SigninPage()));
          },
          text: "Sign Out",
        ),
      ],
    );
  }
}
