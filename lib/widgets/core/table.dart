import 'dart:math';

import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/tableItem.dart';

class TableWidget extends StatelessWidget {
  TableWidget({
    @required this.items,
    this.headings = const [],
    @required this.flex,
    this.length = -1,
    this.itemsPerPage = 10,
    this.onPageChange,
    this.page,
    this.itemType = "items",
  });

  final List<List<Widget>> items;
  final List<String> headings;
  final List<int> flex;
  final int length;
  final int itemsPerPage;
  final Function(int) onPageChange;
  final int page;
  final String itemType;

  Widget _topBar() {
    return Container(
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
    );
  }

  Widget _content() {
    print(items);
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: length == -1
          ? items.length
          : min(itemsPerPage, ((length) - (itemsPerPage * page))),
      itemBuilder: (BuildContext context, int index) {
        return TableItemWidget(columns: items[index], flex: flex);
      },
    );
  }

  Widget _bottomBar() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        color: Colors.grey[200],
      ),
      child: length == -1 ? Container() : _bottomNavbar(),
    );
  }

  Widget _bottomNavbar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Icon(Icons.navigate_before),
            onTap: () => onPageChange(page - 1),
          ),
          Text("displaying " +
              itemType +
              " " +
              ((page * itemsPerPage) + 1).toString() +
              " - " +
              (min(((page + 1) * itemsPerPage), length)).toString() +
              " of " +
              length.toString()),
          GestureDetector(
            child: Icon(Icons.navigate_next),
            onTap: () => onPageChange(page + 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _topBar(),
        _content(),
        _bottomBar(),
      ],
    );
  }
}
