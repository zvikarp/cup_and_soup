import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/admin/updateCredit/amountInput.dart';
import 'package:cup_and_soup/widgets/admin/barcodeGenerator.dart';

class UpdateCreditPage extends StatefulWidget {
  @override
  _UpdateCreditPageState createState() => _UpdateCreditPageState();
}

class _UpdateCreditPageState extends State<UpdateCreditPage> {
  int _step = 1;
  double _amount = 0.0;
  String _barcode = "";

  void _amountSubmited(String amount, DateTime dateTime) async {
    String barcode = await cloudFirestoreService.updateCreditBarcode(double.parse(amount), dateTime);
    setState(() {
      _step = 2;
      _amount = double.parse(amount);
      _barcode = barcode;
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
        title: "update-credit",
        child: _step == 1
            ? AmountInputWidget(onAmountSubmit: _amountSubmited)
            : BarcodeGeneratorWidget(
              amount: _amount,
              barcode: _barcode,
              backPressed: _stepBack
            ),
      ),
    );
  }
}
