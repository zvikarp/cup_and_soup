import 'dart:math';

import 'package:cup_and_soup/utils/localizations.dart';
import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  TableWidget({
    @required this.items,
    this.headings = const [],
    @required this.flex,
    this.length = -1,
    this.itemsPerPage = 10,
    this.onPageChange,
    this.page,
    this.itemType = "",
  });

  final List<List<Widget>> items;
  final List<String> headings;
  final List<double> flex;
  final int length;
  final int itemsPerPage;
  final Function(int) onPageChange;
  final int page;
  final String itemType;

  Widget _title(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          text,
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    );
  }

  TableRow _topBar(BuildContext context) {
    return TableRow(
      children: headings.map((heading) => _title(context, heading)).toList(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: themes.load("tableColor"),
      ),
    );
  }

  List<TableRow> _content(BuildContext context) {
    List<TableRow> tableRows = [];
    int rows = length == -1
        ? items.length
        : min(itemsPerPage, ((length) - (itemsPerPage * page)));
    for (int i = 0; i < rows; i++) {
      if (items[i].toString() == "[Container]")
        continue;
      else
        tableRows.add(
          TableRow(
            children: items[i],
            decoration: BoxDecoration(color: themes.load("tableColor")),
          ),
        );
    }
    return tableRows;
  }

  Widget _bottomBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        color: themes.load("tableColor"),
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
            child: Icon(
              Icons.navigate_before,
              color: themes.load("body1"),
            ),
            onTap: () => onPageChange(page - 1),
          ),
          Text(translate.text("core-table:w-st")[0] +
              itemType +
              ((page * itemsPerPage) + 1).toString() +
              translate.text("core-table:w-st")[1] +
              (min(((page + 1) * itemsPerPage), length)).toString() +
              translate.text("core-table:w-st")[2] +
              length.toString()),
          GestureDetector(
            child: Icon(
              Icons.navigate_next,
              color: themes.load("body1"),
            ),
            onTap: () => onPageChange(page + 1),
          ),
        ],
      ),
    );
  }

  List<TableRow> _children(BuildContext context) {
    List<TableRow> children = _content(context);
    children.insert(0, _topBar(context));
    return children;
  }

  Map<int, FractionColumnWidth> _widths() {
    Map<int, FractionColumnWidth> widths = {};
    for (int i = 0; i < flex.length; i++) {
      widths.putIfAbsent(i, () => FractionColumnWidth(flex[i]));
    }
    return widths;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Table(
          children: _children(context),
          columnWidths: _widths(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
              horizontalInside: BorderSide(
            width: 4,
            color: Theme.of(context).canvasColor,
          )),
        ),
        _bottomBar(context),
      ],
    );
  }
}
