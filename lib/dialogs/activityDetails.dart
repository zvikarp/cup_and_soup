// import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:cup_and_soup/utils/localizations.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class ActivityDetailsDialog extends StatefulWidget {
  ActivityDetailsDialog({
    @required this.aid,
    @required this.type,
    @required this.name,
    @required this.amount,
    @required this.timestamp,
    @required this.status,
  });

  final String aid;
  final String type;
  final String name;
  final String status;
  final double amount;
  final DateTime timestamp;

  @override
  _ActivityDetailsDialogState createState() => _ActivityDetailsDialogState();
}

class _ActivityDetailsDialogState extends State<ActivityDetailsDialog> {
  List<Widget> _actionWidgets(BuildContext context) {
    List<Widget> list = [];
    if ((widget.type == "buy") &&
        (widget.aid != "not provided") &&
        (widget.status == "success") &&
        (widget.timestamp.isAfter(DateTime.now().add(Duration(days: -1))))) {
      list.add(
        GestureDetector(
          onTap: () {
            cloudFirestoreService.requestRefund(widget.aid);
            SnackbarWidget.infoBar(context,
                "Your request has been sent, we well notify you in under 1 hour if your request has been exepted.");
            // Navigator.pop(context);
          },
          child: Text(
            translate.text("activityDetailes:d-requestRefund"),
            style: Theme.of(context)
                .textTheme
                .subtitle
                .merge(TextStyle(decoration: TextDecoration.underline)),
          ),
        ),
      );
    }
    list.add(ButtonWidget(
      text: translate.text("button-close"),
      onPressed: () => Navigator.pop(context),
      primary: false,
    ));
    return list;
  }

  Widget _actionSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _actionWidgets(context),
    );
  }

  TableRow _typeRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          translate.text("field-type") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(translate.text("action-types")[widget.type.toString()]),
    ]);
  }

  TableRow _nameRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          translate.text("field-name") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(widget.name),
    ]);
  }

  TableRow _amountRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          translate.text("field-amount") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(widget.amount.toString()),
    ]);
  }

  TableRow _timestampRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          translate.text("field-timestamp") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(widget.timestamp.toString()),
    ]);
  }

  TableRow _aidRow(BuildContext context) {
    String aid = widget.aid.toString();
    if (aid == "not provided")
      aid = translate.text("activityDetailes:d-notProvided");
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          translate.text("field-receiptNumber") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(aid),
    ]);
  }

  TableRow _statusRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          translate.text("field-status") + ": ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(translate.text("status-types")[widget.status.toString()]),
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
        _aidRow(context),
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
          translate.text("activityDetailes:d-t"),
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
