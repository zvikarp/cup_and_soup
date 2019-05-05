import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class ActivityDetailsDialog extends StatelessWidget {
  ActivityDetailsDialog({
    @required this.type,
    @required this.name,
    @required this.amount,
    @required this.timestamp,
  });

  final String type;
  final String name;
  final double amount;
  final DateTime timestamp;

  Widget _actionSection(BuildContext context) {
    return ButtonWidget(
      text: "CLOSE",
      onPressed: () => Navigator.pop(context),
      primary: false,
    );
  }

  TableRow _typeRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Type:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(type),
    ]);
  }

  TableRow _nameRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Name:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(name),
    ]);
  }

  TableRow _amountRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Amount:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(amount.toString()),
    ]);
  }

  TableRow _timestampRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Timestamp:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(timestamp.toString()),
    ]);
  }

  TableRow _statusRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Status:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text("success"),
    ]);
  }

  Widget _content(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {0: FractionColumnWidth(.3)},
      children: <TableRow>[
        _typeRow(context),
        _nameRow(context),
        _amountRow(context),
        _timestampRow(context),
        _statusRow(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      scrollable: true,
      heading: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Activity Details",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24),
            child: _content(context),
          ),
        ],
      ),
      actionSection: Padding(
        padding: const EdgeInsets.all(16),
        child: _actionSection(context),
      ),
    );
  }
}
