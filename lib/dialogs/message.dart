import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class MessageDialog extends StatelessWidget {
  MessageDialog({
    @required this.message,
    @required this.code,
    this.flareActor,
  });

  final String message;
  final String code;
  final FlareActor flareActor;

  Widget _icon() {
    if (code[0] == "s")
      return Icon(Icons.check);
    else
      return Icon(Icons.warning);
  }

  Widget _messageSection() {
    if (code == "s0") {
      return Text(
        "Enjoy your soup!",
        textAlign: TextAlign.center,
      );
    } else if (code == "e2") {
      return Text(
        "We are sorry, currently this item is out of stock. We are trying are best to get it back to you!",
        textAlign: TextAlign.center,
      );
    } else if (code == "e2") {
      return Text(
        "Ouch. It seems like you don't have enough money to my this. You might want to add money to your account.",
        textAlign: TextAlign.center,
      );
    } else if (code == "e7") {
      return Text(
        "We are sorry, we are unable to connect to our backend right now, please try again later.",
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        "Oops... Something unexpected happened, please try again later.",
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _actionSection(BuildContext context) {
    return ButtonWidget(
      text: "Back",
      onPressed: () {
        Navigator.pop(context);
      },
      primary: false,
      size: "small",
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
        child: Column(
      children: <Widget>[
        _icon(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: _messageSection(),
        ),
        DividerWidget(),
        _actionSection(context),
      ],
    ));
  }
}
