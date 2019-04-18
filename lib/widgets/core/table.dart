import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/tableItem.dart';

class TableWidget extends StatelessWidget {
  TableWidget({
    @required this.items,
    this.headings = const [],
    @required this.flex,
  });

  final List<List<Widget>> items;
  final List<String> headings;
  final List<int> flex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            color: Colors.grey[200],
          ),
          child: headings == []
              ? Container()
              : Row(
                  children: headings
                      .map((heading) => Expanded(
                            child: Text(heading),
                            flex: flex[headings.indexOf(heading)],
                          ))
                      .toList()),
        ),
        ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            if (items[index].toString() == "[Container]")
              return Container();
            else
              return TableItemWidget(columns: items[index], flex: flex);
          },
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}
