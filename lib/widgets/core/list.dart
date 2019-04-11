import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  ListWidget({
    @required this.items,
    this.headings = const [],
  });

  final List<Widget> items;
  final List<String> headings;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: Colors.grey[200],
            ),
            child: headings == []
                ? Container()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        headings.map((heading) => Text(heading)).toList()),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return items[index];
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 6),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
