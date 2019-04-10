import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/pageHeader.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key key}) : super(key: key);

  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          PageHeaderWidget(
            title: "shop",
          ),
          Center(child: Text("shop page")),
        ],
      ),
    );
  }
}
