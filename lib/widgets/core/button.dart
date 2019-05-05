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
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.button,
      ),
      color: primary ? Theme.of(context).primaryColor : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );
  }
}
