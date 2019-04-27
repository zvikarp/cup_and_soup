import 'package:flutter/material.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class CustomersDetailsDialog extends StatelessWidget {

  CustomersDetailsDialog({
    @required this.uid,
  });

  final String uid;

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
          size: "small",
        ),
      ],
    );
  }

  String _text() {
    if (uid == "delete")
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
