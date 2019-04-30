import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/admin/giveDiscount/amountInput.dart';
import 'package:cup_and_soup/widgets/admin/barcodeGenerator.dart';

class GiveDiscountPage extends StatefulWidget {
  @override
  _GiveDiscountPageState createState() => _GiveDiscountPageState();
}

class _GiveDiscountPageState extends State<GiveDiscountPage> {
  int _step = 1;
  double _amount = 0.0;
  String _barcode = "";

  void _amountSubmited(String amount, DateTime dateTime, int usageLimit, bool userLimit, int scans) async {
    String barcode = await cloudFirestoreService.uploadDiscountBarcode(double.parse(amount), dateTime, usageLimit, userLimit, scans);
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
        title: "give-discount",
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
