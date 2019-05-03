import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/core/dateTimePicker.dart';
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

  TableRow _openFromRow(BuildContext context) {
    return TableRow(
      children: <Widget>[
        Text("opening date: ", style: Theme.of(context).textTheme.body2),
        DateTimePicker(
          initDateTime: DateTime.now(),
          onDateTimeChange: (DateTime dateTime) {
            setState(() {
              _openDateTime = dateTime;
            });
          },
        ),
      ],
    );
  }

  TableRow _closeFromRow(BuildContext context) {
    return TableRow(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child:
              Text("closing date: ", style: Theme.of(context).textTheme.body2),
        ),
        DateTimePicker(
          initDateTime: DateTime.now(),
          onDateTimeChange: (DateTime dateTime) {
            setState(() {
              _closeDateTime = dateTime;
            });
          },
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
              1: FractionColumnWidth(.6),
            },
            children: <TableRow>[
              _closeFromRow(context),
              _openFromRow(context),
            ],
          ),
          DividerWidget(),
          _actionSection(context),
        ],
      ),
    ));
  }
}
