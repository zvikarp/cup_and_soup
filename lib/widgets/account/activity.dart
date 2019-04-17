import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/widgets/core/table.dart';
import 'package:cup_and_soup/widgets/core/tableItem.dart';

class ActivityWidget extends StatefulWidget {
  ActivityWidget({
    @required this.uid,
  });

  final String uid;

  @override
  _ActivityWidgetState createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
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
    return Column(
      children: <Widget>[
        Text(
          "Full transsaction history:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        StreamBuilder(
          stream: Firestore.instance.collection('users').document(widget.uid).collection('activity').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.documents == null) return Text("No, data!");
            List<List<Widget>> list = [];
            snapshot.data.documents.forEach((index) {
                list.add([
                  Text(snapshot.data.documents[0]['money'].toString()),
                  Text(snapshot.data.documents[0]['money'].toString()),
                  Text(snapshot.data.documents[0]['money'].toString()),
                ]);
              });
            return TableWidget(
              headings: ["title", "subtitle", "price"],
              items: list,
            );
          }
        ),
      ],
    );
  }
}
