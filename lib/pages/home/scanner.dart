import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:flutter/services.dart';
import 'package:cup_and_soup/dialogs/message.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({
    Key key,
    this.goToShop,
  }) : super(key: key);

  final VoidCallback goToShop;

  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  StreamSubscription _requestStream;
  List<String> types = ['M', 'C'];

  void _waitForResponce(String barcode) {
    if (_requestStream != null) _requestStream.cancel();
    _requestStream =
        cloudFirestoreService.subscribeToGeneralRequestsStream().listen((snap) {
      print(snap['barcode']);
      if (snap['barcode'] == barcode) {
        _requestStream.cancel();
        cloudFirestoreService.deleteRequest(barcode);
        Navigator.of(context).push(
          TransparentRoute(
            builder: (BuildContext context) => MessageDialog(
                  responseCode: snap['responseCode'],
                ),
          ),
        );
        widget.goToShop();
        return;
      }
    });
  }

  Future<void> initPlatformState() async {
    String barcodeScanRes;
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false);
          String type = barcodeScanRes[0];
      if (barcodeScanRes == "")
        widget.goToShop();
      else if (types.contains(type)) {
        cloudFirestoreService.sendRequest(barcodeScanRes);
        _waitForResponce(barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
  }
}
