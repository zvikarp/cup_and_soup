import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';

class ActionSectionWidget extends StatefulWidget {
  ActionSectionWidget({
    @required this.barcode,
    @required this.price,
  });

  final String barcode;
  final double price;

  @override
  _ActionSectionWidgetState createState() => _ActionSectionWidgetState();
}

class _ActionSectionWidgetState extends State<ActionSectionWidget> {
  bool loading = false;

  void _waitForResponce() {
    cloudFirestoreService.subscribeToRequestsStream().listen((snap) {
      print(snap['barcode']);
      if (snap['barcode'] == widget.barcode) {
        print("jobdone!" + snap['message'].toString());
        setState(() {
          loading = false;
        });
        cloudFirestoreService.deleteRequest(snap['id']);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[600],
            blurRadius: 5.0,
            spreadRadius: 1.0,
          )
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Theme.of(context).accentColor,
      ),
      child: BottomAppBar(
          elevation: 0,
          color: Theme.of(context).accentColor,
          child: loading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                )
              : ButtonWidget(
                  text: "Buy Now for ${widget.price.toString()} NIS",
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    _waitForResponce();
                    cloudFirestoreService.buyItem(widget.barcode);
                  },
                )),
    );
  }
}
