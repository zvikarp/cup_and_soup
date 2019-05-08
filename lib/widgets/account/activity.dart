import 'dart:math';

import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/utils/dateTime.dart';
import 'package:cup_and_soup/dialogs/activityDetails.dart';
import 'package:cup_and_soup/widgets/core/table.dart';

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
  bool _refreshed = true;
  List<List<Widget>> _activities = [];
  List<List<Widget>> _activitiesOnPage = [];

  @override
  void initState() {
    super.initState();
    _getActivities();
  }

  void _onMorePressed(var doc) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => ActivityDetailsDialog(
              type: doc['type'],
              name: doc['desc'],
              amount: doc['money'].toDouble(),
              timestamp: dateTimeUtil.timestampStringToDate(doc['timestamp'].toString()),
            ),
      ),
    );
  }

  void _getActivities() async {
    setState(() {
      _refreshed = false;
    });
    List<dynamic> list = await cloudFirestoreService.getActivities();
    List<List<Widget>> activities = [];
    list.forEach((doc) {
      activities.add([
        Container(
          alignment: Alignment(-1, 0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _typeIcon(doc['type']),
          ),
        ),
        Text(doc['desc'].toString()),
        Text(doc['money'].toString()),
        Center(child: _date(doc['timestamp'].toString())),
        _more(doc),
      ]);
    });
    if (mounted) {
    setState(() {
      _activities = activities;
      _length = _activities.length;
      _refreshed = true;
    });
    }
    _onPageChanged(0);
  }

  Widget _more(var doc) {
    return GestureDetector(
      onTap: () {
        _onMorePressed(doc);
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 42,
          padding: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black,
          ),
          child: Icon(
            Icons.navigate_next,
            size: 16,
            color: Colors.grey[200],
          ),
        ),
      ),
    );
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
    } else if (type == "credit") {
      return Icon(
        Icons.atm,
        size: 16,
      );
    } else if (type == "discount") {
      return Icon(
        Icons.attach_money,
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
    DateTime date = dateTimeUtil.timestampStringToDate(stringDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          dateTimeUtil.date(date),
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          dateTimeUtil.time(date),
          style: Theme.of(context).textTheme.caption,
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
          style: Theme.of(context).textTheme.title,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          child: Text(
            "This list contains every successful activity that occurred in your account.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        _refreshed
            ? IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black54,
                ),
                onPressed: _getActivities,
              )
            : Padding(
                padding: EdgeInsets.all(15),
                child: Text("Refreshing..."),
              ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: _length == 0
              ? Text(
                  "Hey! it looks like there is nothing to see here.",
                  textAlign: TextAlign.center,
                )
              : TableWidget(
                  length: _length,
                  headings: ["", "Name", "Amo.", "Date", " "],
                  items: _activitiesOnPage,
                  flex: [.2, .3, .1, .2, .2],
                  page: _page,
                  onPageChange: _onPageChanged,
                ),
        ),
      ],
    );
  }
}
