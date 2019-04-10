import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';

class ItemPage extends StatelessWidget {
  ItemPage({
    @required this.name,
  });

  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        title: name,
        child: Container(),
      ),
    );
  }
}
