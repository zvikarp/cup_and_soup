import 'package:flutter/material.dart';

import 'package:cup_and_soup/dialogs/composeMessage.dart';
import 'package:cup_and_soup/dialogs/closeStore.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/pages/admin/customersDetails.dart';
import 'package:cup_and_soup/pages/admin/updateCredit.dart';
import 'package:cup_and_soup/pages/admin/transferMoney.dart';
import 'package:cup_and_soup/pages/admin/activeBarcodes.dart';
import 'package:cup_and_soup/pages/admin/giveDiscount.dart';
import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/center.dart';
import 'package:cup_and_soup/widgets/core/button.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "admin",
      child: Column(children: <Widget>[
        Text(
          "Quick Actions",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransferMoneyPage()),
              );
            },
            child: CenterWidget(
              child: Center(
                child: Text(
                  "Transfer Money",
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateCreditPage()),
              );
            },
            child: CenterWidget(
              child: Center(
                child: Text(
                  "Update User Credit",
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GiveDiscountPage()),
              );
            },
            child: CenterWidget(
              child: Center(
                child: Text(
                  "Give Discount",
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        DividerWidget(),
        Text(
          "More Options",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "View active barcodes",
              ),
              ButtonWidget(
                text: "View",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActiveBarcodesPage()),
                  );
                },
                primary: false,
                size: "small",
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "View customers details",
              ),
              ButtonWidget(
                text: "View",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomersDetailsPage()),
                  );
                },
                primary: false,
                size: "small",
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Push messages",
              ),
              ButtonWidget(
                text: "compose",
                onPressed: () {
                  Navigator.of(context).push(
                    TransparentRoute(
                      builder: (BuildContext context) => ComposeMessageDialog(),
                    ),
                  );
                },
                primary: false,
                size: "small",
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Close store",
              ),
              ButtonWidget(
                text: "Close",
                onPressed: () {
                  Navigator.of(context).push(
                    TransparentRoute(
                      builder: (BuildContext context) => CloseStoreDialog(),
                    ),
                  );
                },
                primary: false,
                size: "small",
              ),
            ],
          ),
        ),
        SizedBox(height: 42)
      ]),
    );
  }
}
