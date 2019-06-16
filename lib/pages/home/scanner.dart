import 'dart:async';

import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/pages/store/item.dart';
import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:flutter/services.dart';
import 'package:cup_and_soup/dialogs/message.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({
    Key key,
    this.goToStore,
  }) : super(key: key);

  final VoidCallback goToStore;

  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  StreamSubscription _requestStream;
  List<String> types = ['M', 'C', 'D'];

  void _waitForResponce(String barcode) {
    if (_requestStream != null) _requestStream.cancel();
    _requestStream =
        cloudFirestoreService.subscribeToGeneralRequestsStream().listen((snap) {
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
        widget.goToStore();
        return;
      }
    });
  }

  void _barcodeNotFound() async {
    await Navigator.of(context).push(
          TransparentRoute(
            builder: (BuildContext context) => MessageDialog(
                  responseCode: 's-e2',
                ),
          ),
        );
      initPlatformState();
  }

  Future<void> initPlatformState() async {
    String barcodeScanRes;
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false);
      if (barcodeScanRes == "") {
        widget.goToStore();
      } else if (types.contains(barcodeScanRes[0])) {
        cloudFirestoreService.sendRequest(barcodeScanRes);
        _waitForResponce(barcodeScanRes);
      } else if (int.tryParse(barcodeScanRes).toString() == barcodeScanRes) {
        Item item = await cloudFirestoreService.getItem(barcodeScanRes);
        if (item != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemPage(
                      item: item,
                    )),
          );
          widget.goToStore();
        } else {
        _barcodeNotFound();
        }
      } else { 
        _barcodeNotFound();
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      widget.goToStore();
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
          valueColor: AlwaysStoppedAnimation<Color>(themes.load("body2")),
        ),
      ),
    );
  }
}
