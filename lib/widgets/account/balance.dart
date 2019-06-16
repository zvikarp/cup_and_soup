import 'package:cup_and_soup/utils/localizations.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/models/user.dart';
import 'package:cup_and_soup/widgets/core/center.dart';

class BalanceWidget extends StatefulWidget {
  BalanceWidget({
    @required this.user,
  });

  final User user;

  @override
  _BalanceWidgetState createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          translate.text("acc:p-balance:w-t"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: CenterWidget(
            child: Center(
              child: Text(
                widget.user.money.toString() ?? "...",
                style: Theme.of(context).textTheme.display1.merge(
                      TextStyle(color: Theme.of(context).primaryColor),
                    ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: Text(
            translate.text("acc:p-balance:w-st")[0] +
                widget.user.allowedCredit.toString() +
                translate.text("acc:p-balance:w-st")[1],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
      ],
    );
  }
}
