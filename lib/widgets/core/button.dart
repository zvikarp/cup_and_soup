import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  ButtonWidget({
    @required this.text,
    @required this.onPressed,
    this.primary = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.size = "big",
  });

  final String size;
  final bool primary;
  final String text;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: size == "big" ? EdgeInsets.symmetric(vertical: 16, horizontal: 42) :  EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      onPressed: onPressed,
      child: Text(text, 
      style: TextStyle(
        fontFamily: "PrimaryFont",
        fontWeight: FontWeight.bold,
        fontSize: size == "big" ? 20 : 14,
      ),),
      color: primary ? Theme.of(context).primaryColor : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );
  }
}