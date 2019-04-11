import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  ListItemWidget({
    @required this.title,
    @required this.subTitle,
    this.price = "0.0"
  });

  final String title;
  final String subTitle;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title),
          Text(subTitle),
          Text(price),
        ],
      ),
    );
  }
}
