import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/pages/transaction.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({Key key}) : super(key: key);

  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "scanner",
      child: GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionPage(
                      amount: 25.6,
                    ),
              ),
            ),
        child: Container(
          constraints: BoxConstraints.expand(height: 400),
          color: Colors.blue,
         
        ),
      ),
    );
  }
}
