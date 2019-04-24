import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/table.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class CustomersDataPage extends StatefulWidget {
  @override
  _CustomersDataPageState createState() => _CustomersDataPageState();
}

class _CustomersDataPageState extends State<CustomersDataPage> {
  List<List<Widget>> _docsToItem(dynamic snapshot) {
    List<List<Widget>> items = [];

    snapshot.forEach((doc) {
      items.add([
        Container(
          alignment: Alignment(-1, 0),
          child: _roleIcon(doc['role']),
        ),
        Text(doc['name'].toString()),
        Text(doc['money'].toString()),
      ]);
    });

    return items;
  }
 
  Widget _roleIcon(String role) {
    if (role == "customer") {
      return Icon(
        Icons.supervisor_account,
        size: 16,
      );
    } else if (role == "admin") {
      return Icon(
        Icons.security,
        size: 16,
      );
    } else {
      return Icon(
        Icons.error,
        size: 16,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        title: "customers-details",
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: StreamBuilder(
                  stream:
                      Firestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    int length = 0;
                    if (!snapshot.hasData || snapshot.data.documents == null)
                      return Text("Loading...");
                    length = snapshot.data.documents.length;
                    if (length == 0) {
                      return Text(
                        "Hey! it looks like there is nothing to see here.",
                        textAlign: TextAlign.center,
                      );
                    }
                    return TableWidget(
                      headings: [" ", " ", " "],
                      items: _docsToItem(snapshot.data.documents),
                      flex: [1, 3, 2],
                    );
                  }),
            ),
            ButtonWidget(
              text: "back",
              onPressed: () {
                Navigator.pop(context);
              },
              primary: false,
              size: "small",
            ),
          ],
        ),
      ),
    );
  }
}
