import 'package:flutter/material.dart';

class CenterWidget extends StatelessWidget {

  CenterWidget({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("assets/images/center.png"),
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          child: child,
        ),
      ],
    );
  }
}