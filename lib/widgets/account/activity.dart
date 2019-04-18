import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/widgets/core/table.dart';
import 'package:cup_and_soup/utils/dateTime.dart';

class ActivityWidget extends StatefulWidget {
  ActivityWidget({
    @required this.uid,
  });

  final String uid;

  @override
  _ActivityWidgetState createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  Widget _typeIcon(String type) {
    if (type == "buy") {
      return Icon(
        Icons.fastfood,
        size: 16,
      );
    } else if (type == "money") {
      return Icon(
        Icons.monetization_on,
        size: 16,
      );
    } else {
      return Icon(
        Icons.error,
        size: 16,
      );
    }
  }

  Widget _date(String stringDate) {
    DateTime date = dateTimeUtil.stringToDate(stringDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          dateTimeUtil.date(date),
          style: TextStyle(
            fontFamily: "PrimaryFont",
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
        Text(
          dateTimeUtil.time(date),
          style: TextStyle(
            fontFamily: "PrimaryFont",
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          child: Text(
            "This list contains every successful activity that scored in your account.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PrimaryFont",
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(widget.uid)
                  .collection('activity')
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.documents == null)
                  return Text("No, data!");
                List<List<Widget>> list = [];
                snapshot.data.documents.forEach((doc) {
                  list.add([
                    Container(
                      alignment: Alignment(-1, 0),
                      child: _typeIcon(doc['type']),
                    ),
                    Text(doc['desc'].toString()),
                    Text(doc['money'].toString()),
                    _date(doc['timestamp'].toString()),
                  ]);
                });
                return TableWidget(
                  headings: [" ", " ", " ", " "],
                  items: list,
                  flex: [1, 5, 2, 2],
                );
              }),
        ),
      ],
    );
  }
}
