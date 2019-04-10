import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class TransactionPage extends StatelessWidget {

  TransactionPage({
    @required this.amount,
  });

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: PageWidget(
        title: "transaction",
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "you just recevied money in your Cup&Soup account!",
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
              onPressed: () => Navigator.pop(context),
              text: "Cool!",
            ),
          ),
        ],
      ),
    );
  }
}