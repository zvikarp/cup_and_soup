import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/center.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class BarcodeGeneratorWidget extends StatelessWidget {
  BarcodeGeneratorWidget({
    @required this.amount,
    @required this.backPressed,
  });

  final double amount;
  final Function() backPressed;
  final TextEditingController _amountInputCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "Generating your barcode",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PrimaryFont",
              fontSize: 24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            amount.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PrimaryFont",
              fontSize: 24,
            ),
          ),
        ),
        
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: ButtonWidget(
            onPressed: backPressed,
            text: "Back",
            primary: false,
          ),
        ),
      ],
    );
  }
}
