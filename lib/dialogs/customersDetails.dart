import 'package:flutter/material.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/services/cloudFunctions.dart';

class CustomersDetailsDialog extends StatelessWidget {
  CustomersDetailsDialog({
    @required this.userDoc,
  });

  final dynamic userDoc;

  Widget _actionSection(BuildContext context) {
    return ButtonWidget(
      text: "Close",
      onPressed: () {
        Navigator.pop(context);
      },
      primary: false,
      size: "small",
    );
  }

  TableRow _nameRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text("Name:"),
      ),
      Text(userDoc['name']),
    ]);
  }

  TableRow _emailRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text("Email:"),
      ),
      Text(userDoc['email']),
    ]);
  }

  TableRow _moneyRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text("Money:"),
      ),
      Text(userDoc['money'].toString()),
    ]);
  }

  TableRow _creditRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text("Allowed Credit:"),
      ),
      Text(userDoc['allowedCredit'].toString()),
    ]);
  }

  TableRow _rolesRow() {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text("Roles:"),
      ),
      Text(userDoc['roles'].cast<String>().join(", ")),
    ]);
  }

  TableRow _disabledRow(context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text("Disabled:"),
      ),
      Switch(
        value: userDoc['disabled'] ?? false,
        onChanged: (v) async {
          print(userDoc.documentID.toString());
          print(v);
          await cloudFunctionsService.changeUserStatus(userDoc.documentID.toString(), v);
          Navigator.pop(context);
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ]);
  }

  Widget _content(context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {0: FractionColumnWidth(.3)},
      children: <TableRow>[
        _nameRow(),
        _emailRow(),
        _moneyRow(),
        _creditRow(),
        _rolesRow(),
        _disabledRow(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _content(context),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _actionSection(context),
          ),
        ],
      ),
    );
  }
}
