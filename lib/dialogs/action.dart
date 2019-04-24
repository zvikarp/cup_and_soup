import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class ActionDialog extends StatelessWidget {

  ActionDialog({
    @required this.type,
  });

  final String type;

  Widget _actionSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ButtonWidget(
          text: "No",
          onPressed: () {
            Navigator.pop(context, false);
          },
          primary: false,
          size: "small",
        ),
        ButtonWidget(
          text: "Yes",
          onPressed: () {
            Navigator.pop(context, true);
          },
          // primary: false,
          size: "small",
        ),
      ],
    );
  }

  String _text() {
    if (type == "delete")
    return "Are you sure you want to delete this?";
    else return "unknown error";
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
        child: Column(
      children: <Widget>[
        Icon(Icons.warning),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Text(
            _text(),
            textAlign: TextAlign.center,
          ),
        ),
        DividerWidget(),
        _actionSection(context),
      ],
    ));
  }
}
