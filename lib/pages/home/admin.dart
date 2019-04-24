import 'package:flutter/material.dart';

import 'package:cup_and_soup/pages/admin/transferMoney.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/center.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "admin",
      child: Column(children: <Widget>[
        Text(
          "Quick Actions",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransferMoneyPage()),
              );
            },
            child: CenterWidget(
              child: Center(
                child: Text(
                  "Transfer Money",
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: GestureDetector(
            onTap: () {SnackbarWidget.errorBar(context, "This feature dosn't exist yet.");},
            child: CenterWidget(
              child: Center(
                child: Text(
                  "Update User Credit",
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        DividerWidget(),
        Text(
          "More Settings",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "View active barcodes",
              ),
              ButtonWidget(
                text: "View",
                onPressed: () {SnackbarWidget.errorBar(context, "This feature dosn't exist yet.");},
                primary: false,
                size: "small",
              ),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "View customers activity",
              ),
              ButtonWidget(
                text: "View",
                onPressed: () {SnackbarWidget.errorBar(context, "This feature dosn't exist yet.");},
                primary: false,
                size: "small",
              ),
            ],
          ),
        ),

        SizedBox(height: 42)
      ]),
    );
  }
}
