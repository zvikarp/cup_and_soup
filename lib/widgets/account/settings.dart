import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/widgets/core/button.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({
    @required this.uid,
    @required this.userData,
  });

  final String uid;
  final Map<String, dynamic> userData;

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            "Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PrimaryFont",
              fontSize: 24,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Name: ",
                style: TextStyle(
                  fontFamily: "PrimaryFont",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 200,
                child: TextFormField(
                  enabled: false,
                  initialValue: widget.userData["name"],
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    fontSize: 18,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: "Your awesome name",
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Row(
            children: <Widget>[
              Text(
                "Email: ",
                style: TextStyle(
                  fontFamily: "PrimaryFont",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("test.zektec@gmail.com"),
            ],
          ),
        ),
        widget.userData["role"] != "customer"
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Role: ",
                      style: TextStyle(
                        fontFamily: "PrimaryFont",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.userData["role"]),
                  ],
                ),
              )
            : Container(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: ButtonWidget(
                text: "Log Out",
                onPressed: () {},
                primary: false,
                size: "small",
              ),
            )),
      ],
    );
  }
}
