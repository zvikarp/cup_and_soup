import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {

  ScannerPage({Key key}) : super(key: key);

  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("scanner page")),
    );
  }
}