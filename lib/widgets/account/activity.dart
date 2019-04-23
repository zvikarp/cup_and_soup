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
  List<List<Widget>> _activities = [];
  List<List<Widget>> _activitiesOnPage = [];

  @override
  void initState() {
    super.initState();
    _getActivities();
  }

  void _getActivities() async {
    List<dynamic> list = await cloudFirestoreService.getActivities();
    List<List<Widget>> activities = [];
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
      _activities = activities;
      _length = _activities.length;
    });
    _onPageChanged(0);
  }

  void _onPageChanged(newPage) async {
    if (newPage == -1) return;
    if ((newPage * _itemsPerPage) >= _length) return;
    setState(() {
      _page = newPage;
      _activitiesOnPage = _activities.sublist(((newPage * _itemsPerPage)),
        (min(((newPage + 1) * _itemsPerPage), _length)));
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
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.black54,),
          onPressed: _getActivities,
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
                  return Text("Loading...");
                else if (_length == 0)
                  return Text(
                    "Hey! it looks like there is nothing to see here.",
                    textAlign: TextAlign.center,
                  );
                return TableWidget(
                  length: _length,
                  headings: _length == 0 ? [""] : [" ", " ", " ", " "],
                  items: _activitiesOnPage,
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
