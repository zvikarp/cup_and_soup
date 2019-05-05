import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class FeadbackFormDialog extends StatefulWidget {
  @override
  _FeadbackFormDialogState createState() => _FeadbackFormDialogState();
}

class _FeadbackFormDialogState extends State<FeadbackFormDialog> {
  TextEditingController _titleCtr = TextEditingController();
  TextEditingController _msgCtr = TextEditingController();

  void _onSend() {
    String errorMsg = "no error";
    if (_titleCtr.text == "")
      errorMsg = "The title can't be empty";
    else if (_msgCtr.text == "") errorMsg = "The message can't be empty";
    if (errorMsg == "no error") {
      SnackbarWidget.infoBar(
          context, "This feature is still under develepment.");
    }
    SnackbarWidget.errorBar(context, errorMsg);
  }

  Widget _actionSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ButtonWidget(
          text: "CANCEL",
          onPressed: () => Navigator.pop(context),
          primary: false,
        ),
        ButtonWidget(
          text: "SEND",
          onPressed: () => _onSend(),
        ),
      ],
    );
  }

  TableRow _titleRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "Title:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      TextField(
        controller: _titleCtr,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: "Title",
        ),
      ),
    ]);
  }

  TableRow _messageRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "Message:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      TextField(
        controller: _msgCtr,
        style: Theme.of(context).textTheme.body1,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: "Message",
        ),
      ),
    ]);
  }

  Widget _content(context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {0: FractionColumnWidth(.3)},
      children: <TableRow>[
        _titleRow(),
        _messageRow(),
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
          "Compose Message",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
