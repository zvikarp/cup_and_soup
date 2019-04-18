import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/dialogs/message.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';

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
  StreamSubscription _requestStream;

  void _waitForResponce() {
    _requestStream = cloudFirestoreService.subscribeToRequestsStream().listen((snap) {
      print(snap['barcode']);
      if (snap['barcode'] == widget.barcode) {
        print("jobdone! " + snap['message'].toString());
        _requestStream.cancel();
        cloudFirestoreService.deleteRequest(snap['id']);
        setState(() {
          loading = false;
        });
        Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => MessageDialog(
          message: snap['message'].toString(),
        ),
      ),
    );
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
