import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFunctions.dart';
import 'package:cup_and_soup/widgets/core/dateTimePicker.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class ComposeMessageDialog extends StatefulWidget {
  @override
  _ComposeMessageDialogState createState() => _ComposeMessageDialogState();
}

class _ComposeMessageDialogState extends State<ComposeMessageDialog> {
  TextEditingController _titleCtr = TextEditingController();
  TextEditingController _msgCtr = TextEditingController();
  DateTime _dateTime;
  List<String> _topics = ["important", "general", "special"];
  String _selectedTopic = "general";

  void onSend() {
    String errorMsg = "no error";
    if (_titleCtr.text == "")
      errorMsg = "the title can't be empty";
    else if (_msgCtr.text == "") errorMsg = "the message can't be empty";
    cloudFunctionsService.sendMessage(
        _titleCtr.text, _msgCtr.text, _dateTime, _selectedTopic);
    if (errorMsg != "no error") {
      print("error: " + errorMsg);
    }
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
          onPressed: () {
            onSend();
            Navigator.pop(context);
          },
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

  TableRow _sendAtRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "Send At:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      DateTimePicker(
        initDateTime: DateTime.now(),
        onDateTimeChange: (a) {
          print(a);
        },
      ),
    ]);
  }

  TableRow _sendToRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "Send To:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _selectedTopic,
          onChanged: (topic) {
            setState(() {
              _selectedTopic = topic;
            });
          },
          items: _topics
              .map(
                (topic) => DropdownMenuItem(
                      value: topic,
                      child: Text(
                        topic,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
              )
              .toList(),
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
        _sendAtRow(),
        _sendToRow(),
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
