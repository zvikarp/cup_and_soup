import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/widgets/core/center.dart';

class BalenceWidget extends StatefulWidget {

  BalenceWidget({
    @required this.uid,
  });

  final String uid;

  @override
  _BalenceWidgetState createState() => _BalenceWidgetState();
}

class _BalenceWidgetState extends State<BalenceWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Your account balence:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        StreamBuilder(
          stream:
              Firestore.instance.collection('users').document(widget.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("No, data!");
            String balence = snapshot.data['money'].toString() ?? "...";
            return CenterWidget(
              child: Center(
                child: Text(
                  balence,
                  style: TextStyle(
                      fontFamily: "PrimaryFont",
                      fontSize: 42,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
