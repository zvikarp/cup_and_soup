import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cup_and_soup/utils/dateTime.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';

class BlockDialog extends StatelessWidget {
  BlockDialog({
    this.type = "disabled",
    this.storeStatus,
  });

  final String type;
  final dynamic storeStatus;

  Widget _child() {
    if (type == "closed") {
      return Text(
        "The app is closed until " +
            dateTimeUtil.date(storeStatus["openingDate"].toDate()) +
            " " +
            dateTimeUtil.time(storeStatus["openingDate"].toDate()),
        textAlign: TextAlign.center,
      );
    } else if (type == "disabled") {
      return Text(
        "Your account is temporarily blocked. please contact a admin to unlock your account.",
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        "Unknown error.",
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      heading: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Compose Message",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      child: WillPopScope(
        onWillPop: () {
          exit(0);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: Icon(Icons.warning),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: _child(),
            ),
          ],
        ),
      ),
      actionSection: Padding(
        padding: const EdgeInsets.all(16),
        child: ButtonWidget(
          text: "EXIT APP",
          onPressed: () => exit(0),
          primary: false,
        ),
      ),
    );
  }
}
