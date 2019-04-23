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
    if (_requestStream != null) _requestStream.cancel();
    _requestStream =
        cloudFirestoreService.subscribeToBuyRequestsStream().listen((snap) {
      print(snap['barcode']);
      if (snap['barcode'] == widget.barcode) {
        _requestStream.cancel();
        cloudFirestoreService.deleteRequest("buy");
        setState(() {
          loading = false;
        });
        Navigator.of(context).push(
          TransparentRoute(
            builder: (BuildContext context) => MessageDialog(
                  responseCode: snap['responseCode'].toString(),
                ),
          ),
        );
        return;
      }
    });
  }

  void _errorRequest() {
    if (_requestStream != null) _requestStream.cancel();
    setState(() {
      loading = false;
    });
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => MessageDialog(
              responseCode: "b-ge2",
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/navBar.png",
          height: 70,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 65,
          width: double.infinity,
          child: Center(
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
                      cloudFirestoreService.buyItem(widget.barcode).then((res) {
                        if (!res) {
                          _errorRequest();
                        }
                      });
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
