import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/auth.dart';
import 'package:cup_and_soup/widgets/core/table.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/pages/splash.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TableWidget(
            headings: [" ", " "],
            flex: [1, 2],
            items: [
              [
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
              [
                Text(
                  "Email: ",
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.userData["email"]),
              ],
              widget.userData["role"] != "customer"
                  ? [
                      Text(
                        "Role: ",
                        style: TextStyle(
                          fontFamily: "PrimaryFont",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(widget.userData["role"]),
                    ]
                  : [Container()],
            ],
          ),
        ),
        // Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 24),
        //     child: Center(
        //       child: ButtonWidget(
        //         text: "Sign Out",
        //         onPressed: () {authService.signOut(); exit(0);
        // },
        //         primary: false,
        //         size: "small",
        //       ),
            // )),
      ],
    );
  }
}