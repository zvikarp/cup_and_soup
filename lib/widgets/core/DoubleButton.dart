import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/button.dart';

class DoubleButtonWidget extends StatelessWidget {

  DoubleButtonWidget({
    @required this.leftText,
    @required this.rightText,
    @required this.leftOnPressed,
    @required this.rightOnPressed,
  });

  final String leftText;
  final String rightText;
  final VoidCallback leftOnPressed;
  final VoidCallback rightOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ButtonWidget(
          text: leftText,
          onPressed: leftOnPressed,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
          primary: false,
        ),
        SizedBox(
          width: 6,
        ),
        ButtonWidget(
          text: rightText,
          onPressed: rightOnPressed,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
        ),
      ],
    );
  }
}