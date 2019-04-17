import 'package:flutter/material.dart';

class TableItemWidget extends StatelessWidget {
  TableItemWidget({
    @required this.columns,
    @required this.flex,
  });

  final List<Widget> columns;
  final List<int> flex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      color: Colors.grey[200],
      child: Row(
          children: columns.map((item) {
        return Expanded(
          child: item,
          flex: flex[columns.indexOf(item)],
        );
      }).toList()),
    );
  }
}
