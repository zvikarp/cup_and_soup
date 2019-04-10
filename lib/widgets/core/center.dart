import 'package:flutter/material.dart';

class CenterWidget extends StatelessWidget {

  CenterWidget({
    @required this.child,
  });

  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[900],
      ),
      child: child,
    );
  }
}