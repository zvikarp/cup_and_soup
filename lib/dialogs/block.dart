import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';

class BlockDialog extends StatelessWidget {
  BlockDialog({
    this.type = "disabled",
  });

  final String type;

  Widget _child() {
    if (type == "disabled") {
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
        child: WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Column(
        children: <Widget>[
          Icon(Icons.warning),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: _child(),
          ),
        ],
      ),
    ));
  }
}
