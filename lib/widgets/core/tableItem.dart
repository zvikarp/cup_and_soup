import 'package:flutter/material.dart';

class TableItemWidget extends StatelessWidget {
  TableItemWidget({
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
        children: <Widget>[
          Expanded(child: Text(title), flex: 1,),
          Expanded(child: Text(subTitle), flex: 1,),
          Expanded(child: Text(price), flex: 1,),
        ],
      ),
    );
  }
}
