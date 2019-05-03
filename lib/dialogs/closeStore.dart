import 'package:flutter/material.dart';

import 'package:cup_and_soup/utils/dateTime.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class CloseStoreDialog extends StatefulWidget {
  @override
  _CloseStoreDialogState createState() => _CloseStoreDialogState();
}

class _CloseStoreDialogState extends State<CloseStoreDialog> {
  DateTime _openDateTime = DateTime.now();
  DateTime _closeDateTime = DateTime.now();

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
      initialTime:
          TimeOfDay(hour: _openDateTime.hour, minute: _openDateTime.minute),
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
      initialTime:
          TimeOfDay(hour: _closeDateTime.hour, minute: _closeDateTime.minute),
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

  Widget _actionSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ButtonWidget(
          text: "NO",
          onPressed: () => Navigator.pop(context, false),
          primary: false,
        ),
        ButtonWidget(
          text: "YES",
          onPressed: () {
            cloudFirestoreService.updateStoreStatus(
                _openDateTime, _closeDateTime);
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  TableRow _openFromWidget(BuildContext context) {
    return TableRow(
      children: <Widget>[
        Text(
          "opening date: ",
          style: Theme.of(context).textTheme.body2
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
        Container(),
        GestureDetector(
          onTap: () => _openTimeSelector(context),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black54, width: 1))),
            child: Text(dateTimeUtil.time(_openDateTime)),
          ),
        ),
      ],
    );
  }

  TableRow _closeFromWidget(BuildContext context) {
    return TableRow(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            "closing date: ",
            style: Theme.of(context).textTheme.body2
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
        Container(),
        GestureDetector(
          onTap: () => _closeTimeSelector(context),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black54, width: 1))),
            child: Text(dateTimeUtil.time(_closeDateTime)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          Icon(Icons.warning),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FractionColumnWidth(.4),
              1: FractionColumnWidth(.25),
              2: FractionColumnWidth(.1),
              3: FractionColumnWidth(.25)
            },
            children: <TableRow>[
              _closeFromWidget(context),
              _openFromWidget(context),
            ],
          ),
          DividerWidget(),
          _actionSection(context),
        ],
      ),
    ));
  }
}
