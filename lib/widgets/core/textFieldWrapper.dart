import 'package:flutter/material.dart';

class TextFieldWrapperWidget extends StatelessWidget {
  TextFieldWrapperWidget({
    @required this.textField,
    @required this.prefix,
  });

  final Widget textField;
  final Widget prefix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        prefix,
      Expanded(child: textField,),
      ],
    );
  }
}