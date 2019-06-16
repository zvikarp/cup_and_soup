import 'dart:math';

import 'package:cup_and_soup/utils/localizations.dart';
import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/utils/dateTime.dart';
import 'package:cup_and_soup/dialogs/activityDetails.dart';
import 'package:cup_and_soup/widgets/core/table.dart';

class ActivityWidget extends StatefulWidget {
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
              aid: doc['aid'] ?? "not provided",
              type: doc['type'],
              name: doc['desc'],
              status: doc['status'] ?? "success",
              amount: doc['money'].toDouble(),
              timestamp: dateTimeUtil
                  .timestampStringToDate(doc['timestamp'].toString()),
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
            child: Icon(
              _typeIcon(doc['type']),
              color: themes.load("body2"),
              size: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(doc['desc'].toString()),
        ),
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

  IconData _typeIcon(String type) {
    IconData icon = Icons.error;
    switch (type) {
      case "buy":
        icon = Icons.fastfood;
        break;
      case "money":
        icon = Icons.monetization_on;
        break;
      case "credit":
        icon = Icons.atm;
        break;
      case "discount":
        icon = Icons.attach_money;
        break;
      default:
        icon = Icons.error;
        break;
    }
    return icon;
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
          translate.text("acc:p-activity:w-t"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          child: Text(
            translate.text("acc:p-activity:w-st"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        _refreshed
            ? IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: themes.load("body1"),
                ),
                onPressed: _getActivities,
              )
            : Padding(
                padding: EdgeInsets.all(15),
                child: Text(translate.text("core-refreshing")),
              ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: _length == 0
              ? Text(
                  translate.text("core-emptySpace"),
                  textAlign: TextAlign.center,
                )
              : TableWidget(
                  length: _length,
                  headings: ["", translate.text("field-name"), translate.text("field-amount"), translate.text("field-date"), " "],
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
