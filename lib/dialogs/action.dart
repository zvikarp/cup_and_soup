import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class ActionDialog extends StatelessWidget {
  ActionDialog({
    @required this.type,
  });

  final String type;

  Widget _actionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ButtonWidget(
            text: "NO",
            onPressed: () => Navigator.pop(context, false),
            primary: false,
          ),
          ButtonWidget(
            text: "YES",
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  String _text() {
    if (type == "delete")
      return "Are you sure you want to delete this?";
    else
      return "unknown error";
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      heading: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Worning!",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24),
            child: Icon(Icons.warning),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Text(
              _text(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      actionSection: _actionSection(context),
    );
  }
}
