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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Activity",
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
