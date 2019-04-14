import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';

class ItemPage extends StatelessWidget {
  ItemPage({
    @required this.item,
  });

  final Map<String, dynamic> item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        title: item['name'],
        child: Container(),
      ),
    );
  }
}
