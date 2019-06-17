import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/admin/createNote/amountInput.dart';
import 'package:cup_and_soup/widgets/admin/barcodeGenerator.dart';

class CreateNotePage extends StatefulWidget {
  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  int _step = 1;
  String _barcode = "";

  void _amountSubmited(String note, DateTime dateTime, int usageLimit, bool userLimit, int scans) async {
    String barcode = await cloudFirestoreService.uploadNoteBarcode(note, dateTime, usageLimit, userLimit, scans);
    setState(() {
      _step = 2;
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
        title: "create-note",
        child: _step == 1
            ? AmountInputWidget(onNoteSubmit: _amountSubmited)
            : BarcodeGeneratorWidget(
              amount: 0,
              barcode: _barcode,
              backPressed: _stepBack
            ),
      ),
    );
  }
}
