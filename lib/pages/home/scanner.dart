import 'package:flutter/material.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/pages/transaction.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({Key key}) : super(key: key);

  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "scanner",
      child: GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp(                           ),
              ),
              // MaterialPageRoute(
              //   builder: (context) => TransactionPage(
              //         amount: 25.6,
              //       ),
              // ),
            ),
        child: Container(
          constraints: BoxConstraints.expand(height: 400),
          color: Colors.blue,
         
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false);
          cloudFirestoreService.sendMoneyRequest(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Barcode scan'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      initPlatformState();
                    },
                    child: Text("Start barcode scan"),
                  ),
                  Text(
                    'Scan result : $_scanBarcode\n',
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
          );
        }),
      ),
    );
  }
}