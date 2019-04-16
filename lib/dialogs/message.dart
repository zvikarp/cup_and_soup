import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';

class MessageDialog extends StatelessWidget {

  MessageDialog({
    @required this.message,
    this.flareActor,
  });

  final String message;
  final FlareActor flareActor;

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      child: Center(
        child: Text(message),
      )
    );
  }
}