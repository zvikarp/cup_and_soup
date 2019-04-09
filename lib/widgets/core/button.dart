import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  ButtonWidget({
    @required this.text,
    @required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 42),
      onPressed: onPressed,
      child: Text(text, 
      style: TextStyle(
        fontFamily: "PrimaryFont",
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),),
      color: Colors.yellow[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}