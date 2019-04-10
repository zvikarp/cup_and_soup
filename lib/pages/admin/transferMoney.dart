import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/trasferMoney.dart/amountInput.dart';
import 'package:cup_and_soup/widgets/trasferMoney.dart/barcodeGenerator.dart';

class TransferMoneyPage extends StatefulWidget {
  @override
  _TransferMoneyPageState createState() => _TransferMoneyPageState();
}

class _TransferMoneyPageState extends State<TransferMoneyPage> {
  int _step = 1;
  double _amount = 0.0;

  void _amountSubmited(String amount) {
    setState(() {
      _step = 2;
      _amount = double.parse(amount);
    });
  }

  void _stepBack() {
    setState(() {
      _step = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        title: "trasfer-money",
        child: _step == 1
            ? AmountInputWidget(onAmountSubmit: _amountSubmited)
            : BarcodeGeneratorWidget(
              amount: _amount,
              backPressed: _stepBack
            ),
      ),
    );
  }
}
