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
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("No, data!");
        String balence = snapshot.data['money'].toString() ?? "...";
        String credit = snapshot.data['allowedCredit'].toString() ?? "0";
        return Column(
          children: <Widget>[
            Text(
              "Balence",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "PrimaryFont",
                fontSize: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: CenterWidget(
                child: Center(
                  child: Text(
                    balence,
                    style: TextStyle(
                        fontFamily: "PrimaryFont",
                        fontSize: 42,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Text(
                "You have up to $credit NIS in credit, ask a admin to give you more.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "PrimaryFont",
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
