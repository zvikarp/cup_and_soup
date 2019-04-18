import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/center.dart';
import 'package:cup_and_soup/widgets/core/doubleButton.dart';

class AmountInputWidget extends StatelessWidget {
  AmountInputWidget({
    @required this.onAmountSubmit,
  });

  final Function(String) onAmountSubmit;
  final TextEditingController _amountInputCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Please enter the amout of money you want to trasfer:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PrimaryFont",
              fontSize: 24,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: CenterWidget(
            child: Center(
              child: Container(
                width: 200,
                child: TextFormField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: _amountInputCtr,
                  textAlign: TextAlign.center,
                  onFieldSubmitted: (s) => onAmountSubmit(s),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "PrimaryFont",
                    fontSize: 30,
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: DoubleButtonWidget(
            rightOnPressed: () => onAmountSubmit(_amountInputCtr.text),
            rightText: "Create Barcode",
            leftOnPressed: () => Navigator.pop(context),
            leftText: "Cancel",
          ),
        ),
      ],
    );
  }
}
