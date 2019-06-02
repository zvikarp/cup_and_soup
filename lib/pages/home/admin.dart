import 'package:flutter/material.dart';

import 'package:cup_and_soup/dialogs/composeMessage.dart';
import 'package:cup_and_soup/dialogs/closeStore.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/pages/admin/customersDetails.dart';
import 'package:cup_and_soup/pages/admin/updateCredit.dart';
import 'package:cup_and_soup/pages/admin/transferMoney.dart';
import 'package:cup_and_soup/pages/admin/activeBarcodes.dart';
import 'package:cup_and_soup/pages/admin/giveDiscount.dart';
import 'package:cup_and_soup/pages/admin/refundRequests.dart';
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
          style: Theme.of(context).textTheme.title,
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                          color: Colors.white,
                        ),
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                          color: Colors.white,
                        ),
                      ),
                ),
              ),
            ),
          ),
        ),
        DividerWidget(),
        Text(
          "Requests",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Orders",
              ),
              ButtonWidget(
                text: "VIEW",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActiveBarcodesPage()),
                  );
                },
                primary: false,
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
                "Refund Requests",
              ),
              ButtonWidget(
                text: "VIEW",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RefundRequestsPage()),
                  );
                },
                primary: false,
              ),
            ],
          ),
        ),
        DividerWidget(),
        Text(
          "More",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title
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
                text: "VIEW",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActiveBarcodesPage()),
                  );
                },
                primary: false,
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
                text: "VIEW",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomersDetailsPage()),
                  );
                },
                primary: false,
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
                text: "COMPOSE",
                onPressed: () {
                  Navigator.of(context).push(
                    TransparentRoute(
                      builder: (BuildContext context) => ComposeMessageDialog(),
                    ),
                  );
                },
                primary: false,
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
                text: "CLOSE",
                onPressed: () {
                  Navigator.of(context).push(
                    TransparentRoute(
                      builder: (BuildContext context) => CloseStoreDialog(),
                    ),
                  );
                },
                primary: false,
              ),
            ],
          ),
        ),
        SizedBox(height: 42)
      ]),
    );
  }
}
