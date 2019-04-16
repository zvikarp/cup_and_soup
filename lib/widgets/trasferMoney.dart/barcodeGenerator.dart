import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

import 'package:cup_and_soup/widgets/core/button.dart';

class BarcodeGeneratorWidget extends StatelessWidget {
  BarcodeGeneratorWidget({
    @required this.amount,
    @required this.barcode,
    @required this.backPressed,
  });

  final double amount;
  final String barcode;
  final Function() backPressed;
  final TextEditingController _amountInputCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
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
        Padding(
          padding: EdgeInsets.all(42),
          child: RotatedBox(
  quarterTurns: 1,

            child: BarCodeImage(
              data: barcode,
              codeType: BarCodeType.Code39,
              lineWidth: 2.0,
              barHeight: 120.0,
              onError: (error) {
                print('error = $error');
              },
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
