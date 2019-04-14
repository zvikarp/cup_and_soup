import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/button.dart';

class ActionSectionWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[600],
            blurRadius: 5.0,
            spreadRadius: 1.0,
          )
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Theme.of(context).accentColor,
      ),
      child: BottomAppBar(
        elevation: 0,
        color: Theme.of(context).accentColor,
        child: ButtonWidget(
          text: "Buy Now for 23.4 NIS",
          onPressed: () {},
        )
      ),
    );
  }
}
