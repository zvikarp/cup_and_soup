import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/utils/dateTime.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/dialogs/action.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/table.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class ActiveBarcodesPage extends StatefulWidget {
  @override
  _ActiveBarcodesPageState createState() => _ActiveBarcodesPageState();
}

class _ActiveBarcodesPageState extends State<ActiveBarcodesPage> {
  List<List<Widget>> _docsToItem(dynamic snapshot) {
    List<List<Widget>> items = [];

    snapshot.forEach((doc) {
      items.add([
        Container(
          alignment: Alignment(-1, 0),
          child: _typeIcon(doc['type']),
        ),
        Text(doc['amount'].toString()),
        _content(doc),
        _date(doc['expiringDate']),
        _delete(doc.documentID.toString()),
      ]);
    });

    return items;
  }

  void _onDeletePressed(String barcode) async {
    bool res = await Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => ActionDialog(type: "delete"),
      ),
    );
    if (res) {
      cloudFirestoreService.deleteBarcode(barcode);
    }
  }

  Widget _delete(String barcode) {
    return GestureDetector(
      onTap: () => _onDeletePressed(barcode),
      child: Icon(
        Icons.delete,
        size: 16,
      ),
    );
  }

  Widget _content(dynamic doc) {
    String text = "no info";
    if (doc['type'] == 'money') {
      if (doc['quantity'] == -1) {
        text = "one time code";
      } else {
        text = "can be scanned " + doc['quantity'].toString() + " more times";
        if (doc['userLimit']) text += ", one per user";
      }
    } else if (doc['type'] == 'discount') {
      if (doc['quantity'] == -1) {
        text = "one time code";
      } else {
        text = "can be scanned " + doc['quantity'].toString() + " more times";
        if (doc['userLimit']) text += ", one per user";
      }
      if (doc['usageLimit'] != -1)
        text += ", and used " + doc['usageLimit'].toString() + " times";
    } else if (doc['type'] == 'credit') {
      text = "---";
    }
    return Text(text);
  }

  Widget _typeIcon(String type) {
    if (type == "money") {
      return Icon(
        Icons.monetization_on,
        size: 16,
      );
    } else if (type == "discount") {
      return Icon(
        Icons.monetization_on,
        size: 16,
      );
    } else if (type == "credit") {
      return Icon(
        Icons.monetization_on,
        size: 16,
      );
    } else {
      return Icon(
        Icons.error,
        size: 16,
      );
    }
  }

  Widget _date(Timestamp stringDate) {
    DateTime date = stringDate.toDate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "expiring at:",
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          dateTimeUtil.date(date) + " " + dateTimeUtil.time(date),
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        title: "active-barcodes",
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: StreamBuilder(
                  stream:
                      Firestore.instance.collection('surpriseBox').snapshots(),
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
                      headings: [" ", " ", " ", " ", " "],
                      items: _docsToItem(snapshot.data.documents),
                      flex: [1, 2, 5, 3, 1],
                    );
                  }),
            ),
            ButtonWidget(
              text: "BACK",
              onPressed: () => Navigator.pop(context),
              primary: false,
            ),
          ],
        ),
      ),
    );
  }
}
