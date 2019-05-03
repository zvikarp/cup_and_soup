import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFunctions.dart';
import 'package:cup_and_soup/widgets/core/dialog.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class CustomersDetailsDialog extends StatelessWidget {
  CustomersDetailsDialog({
    @required this.userDoc,
  });

  final dynamic userDoc;

  Widget _actionSection(BuildContext context) {
    return ButtonWidget(
      text: "CLOSE",
      onPressed: () => Navigator.pop(context),
      primary: false,
    );
  }

  TableRow _nameRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Name:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(userDoc['name']),
    ]);
  }

  TableRow _emailRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Email:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(userDoc['email']),
    ]);
  }

  TableRow _moneyRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Money:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(userDoc['money'].toString()),
    ]);
  }

  TableRow _creditRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Allowed Credit:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(userDoc['allowedCredit'].toString()),
    ]);
  }

  TableRow _rolesRow(BuildContext context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Roles:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Text(userDoc['roles'].cast<String>().join(", ")),
    ]);
  }

  TableRow _disabledRow(context) {
    return TableRow(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "Disabled:",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Switch(
        value: userDoc['disabled'] ?? false,
        onChanged: (v) async {
          print(userDoc.documentID.toString());
          print(v);
          await cloudFunctionsService.changeUserStatus(
              userDoc.documentID.toString(), v);
          Navigator.pop(context);
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ]);
  }

  Widget _content(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {0: FractionColumnWidth(.3)},
      children: <TableRow>[
        _nameRow(context),
        _emailRow(context),
        _moneyRow(context),
        _creditRow(context),
        _rolesRow(context),
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
