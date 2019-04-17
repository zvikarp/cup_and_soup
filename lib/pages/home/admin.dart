import 'package:flutter/material.dart';

import 'package:cup_and_soup/pages/admin/transferMoney.dart';

import 'package:cup_and_soup/widgets/admin/gridItem.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Map<String, Widget> _gridListItems = {
    "Transfer Money": TransferMoneyPage(),
    "Edit Store": TransferMoneyPage(),
    "Edit Sales": TransferMoneyPage(),
    "Customers Manager": TransferMoneyPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _gridListItems.length,
            itemBuilder: (context, index) {
              return GridItemWidget(
                text: _gridListItems.keys.toList()[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            _gridListItems.values.toList()[index]),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
