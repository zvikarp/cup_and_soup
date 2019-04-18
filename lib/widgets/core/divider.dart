import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(45),
      child: Image.asset(
        "assets/images/divider.png",
        width: 50,
      ),
    );
  }
}
