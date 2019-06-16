import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    @required this.text,
    @required this.onPressed,
    this.disabled = false,
    this.primary = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
  });

  final bool primary;
  final bool disabled;
  final String text;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      return Opacity(
        opacity: 0.3,
        child: FlatButton(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            onPressed: () {},
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .merge(TextStyle(color: themes.load("body1"))),
            ),
            color: themes.load("disabled"),
            shape: RoundedRectangleBorder(borderRadius: borderRadius)),
      );
    }
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.button,
      ),
      color: primary ? Theme.of(context).primaryColor : themes.load("cardColor"),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );
  }
}
