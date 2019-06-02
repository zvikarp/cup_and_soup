import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/dialogs/refundRequest.dart';

class RefundRequestsPage extends StatefulWidget {
  @override
  _RefundRequestsPageState createState() => _RefundRequestsPageState();
}

class _RefundRequestsPageState extends State<RefundRequestsPage> {

  List<dynamic> _requests = ["sdfs"];

  _loadRequests() async {
    // for (var request in _requests) {
      Navigator.of(context).push(
                TransparentRoute(
                  builder: (BuildContext context) =>
                      RefundRequestDialog(),
                ),
              );
    // }
  }

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}