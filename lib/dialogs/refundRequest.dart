import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class RefundRequestDialog extends StatelessWidget {

  Widget _actionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ButtonWidget(
            text: "IGNORE",
            onPressed: () => Navigator.pop(context, 0),
            primary: false,
          ),
          ButtonWidget(
            text: "DECLINE",
            onPressed: () => Navigator.pop(context, -1),
            primary: false,
          ),
          ButtonWidget(
            text: "EXCEPT",
            onPressed: () => Navigator.pop(context, 1),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Container();
  }
  

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      scrollable: true,
      heading: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Notification Settings",
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