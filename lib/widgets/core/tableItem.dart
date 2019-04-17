import 'package:flutter/material.dart';

class TableItemWidget extends StatelessWidget {
  TableItemWidget({
    @required this.columns,
  });

  final List<Widget> columns;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      color: Colors.grey[200],
      child: Row(children: columns.map((item) {
        return Expanded(child: item, flex: 1,);
      }).toList()),
    );
  }
}
