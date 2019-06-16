import 'dart:async';

import 'package:cup_and_soup/utils/localizations.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
  String _price = "";

  void _checkDiscount() async {
    // Map<String, dynamic> discount = await sharedPreferencesService.getDiscount();
    // if ((discount != {}) && (discount != null)) {
    //   print(discount);
    //   if (discount["usageLimit"] > 0) {
    //     setState(() {
    //       _price = (widget.price - (widget.price * (discount['amount'] / 100)))
    //           .toString();
    //     });
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    _checkDiscount();
    setState(() {
      _price = widget.price.toString();
    });
  }

  void _waitForResponce() {
    if (_requestStream != null) _requestStream.cancel();
    _requestStream =
        cloudFirestoreService.subscribeToBuyRequestsStream().listen((snap) {
      if (snap['barcode'] == widget.barcode) {
        _requestStream.cancel();
        cloudFirestoreService.deleteRequest("buy");
        if (!mounted) return;
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
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage(
            "assets/images/navBar.png",
          ),
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
                    text: translate.text("item:p-buyButton")[0] +
                        _price +
                        translate.text("item:p-buyButton")[1],
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
