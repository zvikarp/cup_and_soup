import 'package:cup_and_soup/utils/dateTime.dart';
import 'package:flutter/material.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class CloseStoreDialog extends StatefulWidget {

  @override
  _CloseStoreDialogState createState() => _CloseStoreDialogState();
}

class _CloseStoreDialogState extends State<CloseStoreDialog> {
  DateTime _openDateTime = DateTime.now();
  DateTime _closeDateTime= DateTime.now();
  final Firestore _storeStat = Firestore.instance;

  Widget _actionSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ButtonWidget(
          text: "No",
          onPressed: () {
            Navigator.pop(context, false);
          },
          primary: false,
          size: "small",
        ),
        ButtonWidget(
          text: "Yes",
          onPressed: () {
            cloudFirestoreService.updateStoreStatus(_openDateTime, _closeDateTime);
            Navigator.pop(context, true);
          },
          // primary: false,
          size: "small",
        ),
      ],
    );
  }
  
  

  Widget _openFromWidget(BuildContext context) {
    return 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
        "opening date: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
          GestureDetector(
            onTap: () => _openDateSelector(context),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 1))),
              child: Text(dateTimeUtil.date(_openDateTime)),
            ),
          ),
          GestureDetector(
            onTap: () => _openTimeSelector(context),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 1))),
              child: Text(dateTimeUtil.time(_openDateTime)),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _openDateTime = DateTime.now().add(Duration(minutes: 5));
              });
            },
          )
        ],
      );
  }

  void _openDateSelector(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _openDateTime,
      firstDate: DateTime.now().add(Duration(days: -600)),
      lastDate: DateTime.now().add(Duration(days: 600)),
    );
    if (picked != null) {
      setState(() {
        _openDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _openDateTime.hour,
          _openDateTime.minute,
        );
      });
    }
  }

  void _openTimeSelector(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _openDateTime.hour, minute: _openDateTime.minute),
    );
    if (picked != null) {
      setState(() {
        _openDateTime = DateTime(
          _openDateTime.year,
          _openDateTime.month,
          _openDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

   void _closeDateSelector(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _closeDateTime,
      firstDate: DateTime.now().add(Duration(days: -600)),
      lastDate: DateTime.now().add(Duration(days: 600)),
    );
    if (picked != null) {
      setState(() {
        _closeDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _closeDateTime.hour,
          _closeDateTime.minute,
        );
      });
    }
  }

  void _closeTimeSelector(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _closeDateTime.hour, minute: _closeDateTime.minute),
    );
    if (picked != null) {
      setState(() {
        _closeDateTime = DateTime(
          _closeDateTime.year,
          _closeDateTime.month,
          _closeDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Widget _closeFromWidget(BuildContext context) {
    return
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
        "closing date: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
          GestureDetector(
            onTap: () => _closeDateSelector(context),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 1))),
              child: Text(dateTimeUtil.date(_closeDateTime)),
            ),
          ),
          GestureDetector(
            onTap: () => _closeTimeSelector(context),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 1))),
              child: Text(dateTimeUtil.time(_closeDateTime)),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _openDateTime = DateTime.now().add(Duration(minutes: 5));
              });
            },
          )
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
        child: Column(
      children: <Widget>[
        Icon(Icons.warning),
        _closeFromWidget(context),
        _openFromWidget(context),
        DividerWidget(),
        _actionSection(context),
      ],
    ));
  }
}