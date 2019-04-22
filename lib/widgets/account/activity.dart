import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
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
  int _page = 0;
  int _itemsPerPage = 10;
  int _length = 0;
  int _newLength = 0;
  List<List<Widget>> _activities = [];

  @override
  void initState() {
    super.initState();
    _getLength();
  }

  void _getLength() async {
    int length = await cloudFirestoreService.getActivityItemsCount();
    setState(() {
      _newLength = length;
    });
    _onPageChanged(0);
  }

  void _onPageChanged(newPage) async {
    int first = (newPage * _itemsPerPage);
    int last = (min(((newPage + 1) * _itemsPerPage) + 1, _newLength));
    print("first" + first.toString());
    print("last" + last.toString());
    if ((first >= last) && (last != 0)) return;
    List<List<Widget>> activities = [];
    List<dynamic> list =
        await cloudFirestoreService.getActivityItems(first, last);
    list.forEach((doc) {
      activities.add([
        Container(
          alignment: Alignment(-1, 0),
          child: _typeIcon(doc['type']),
        ),
        Text(doc['desc'].toString()),
        Text(doc['money'].toString()),
        _date(doc['timestamp'].toString()),
      ]);
    });
    setState(() {
      _page = newPage;
      _activities = activities;
      _length = _newLength;
    });
  }

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
            "This list contains every successful activity that occurred in your account.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PrimaryFont",
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                // List<List<Widget>> list = [];
                // int length = snapshot.data.documents.length;
                // if (length == 0) {
                //   list = [[
                //     Text("Hey! it looks like there is nothing to see here.", textAlign: TextAlign.center,)
                //   ]];
                // }
                // else {
                // snapshot.data.documents.forEach((doc) {
                //   list.add([
                //     Container(
                //       alignment: Alignment(-1, 0),
                //       child: _typeIcon(doc['type']),
                //     ),
                //     Text(doc['desc'].toString()),
                //     Text(doc['money'].toString()),
                //     _date(doc['timestamp'].toString()),
                //   ]);
                // }); }
                return TableWidget(
                  length: _length,
                  headings: _length == 0 ? [""] : [" ", " ", " ", " "],
                  items: _activities,
                  flex: _length == 0 ? [1] : [1, 5, 2, 2],
                  page: _page,
                  onPageChange: _onPageChanged,
                );
              }),
        ),
      ],
    );
  }
}
