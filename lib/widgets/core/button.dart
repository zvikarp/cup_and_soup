import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  ButtonWidget({
    @required this.text,
    @required this.onPressed,
    this.primary = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
  });

  final bool primary;
  final String text;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 42),
      onPressed: onPressed,
      child: Text(text, 
      style: TextStyle(
        fontFamily: "PrimaryFont",
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),),
      color: primary ? Theme.of(context).primaryColor : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );
  }
}