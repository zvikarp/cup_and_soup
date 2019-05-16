import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/models/user.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/services/firebaseDatabase.dart';
import 'package:cup_and_soup/services/sqflite.dart';
import 'package:cup_and_soup/utils/localizations.dart';
import 'package:cup_and_soup/utils/dateTime.dart';
import 'package:cup_and_soup/pages/store/item.dart';
import 'package:cup_and_soup/pages/store/editItem.dart';
import 'package:cup_and_soup/widgets/store/gridItem.dart';
import 'package:cup_and_soup/widgets/core/page.dart';

class StorePage extends StatefulWidget {
  StorePage({
    Key key,
    this.isAdmin = false,
  }) : super(key: key);

  final bool isAdmin;

  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Map<dynamic, dynamic> _discount;

  Widget _addItemButton() {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditItemPage(newItem: true),
            ),
          );
        },
        child: Center(
          child: Image.asset(
            "assets/images/add.png",
            height: 50,
          ),
        ),
      ),
    );
  }

  void _checkDiscount() async {
    cloudFirestoreService.streamUserData().listen((User user) {
      if ((user.discount != {}) && (user.discount != null)) {
        print(user.discount.toString() + "xvcxvcx");
        if ((user.discount["usageLimit"] != null) && (user.discount["usageLimit"] > 0)) {
          setState(() {
            _discount = user.discount;
          });
        }
      }
    });
  }

  Widget _discountContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.star,
            color: Theme.of(context).primaryColor,
          ),
          Container(
              width: 200,
              child: Text("A discount of " +
                  _discount['amount'].toString() +
                  "% well be applied to your next perchese. You can use it " +
                  _discount['usageLimit'].toString() +
                  " more times, until " +
                  dateTimeUtil.date(_discount['expiringDate'].toDate()) +
                  " " +
                  dateTimeUtil.time(_discount['expiringDate'].toDate()) +
                  ", enjoy!")),
        ],
      ),
    );
  }

  void _dataStream() {
    sqfliteService.loadItems("customer");
  }

  @override
  void initState() {
    _checkDiscount();
    _dataStream();
    // firebaseDatabaseService.streamItemsStock();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: Language.of(context).translate("storePageName"),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _discount == null ? Container() : _discountContainer(),
          StreamBuilder(
              stream: sqfliteService.streamItems(),
              builder: (context, snapshot) {
                int length = 0;
                if (snapshot.data != null)
                  length += (snapshot.data.length ?? 0);
                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: widget.isAdmin ? length + 1 : length,
                  itemBuilder: (context, index) {
                    if (index == length) {
                      return _addItemButton();
                    }
                    Item item = snapshot.data[index];
                    return GridItemWidget(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemPage(
                                    item: item,
                                  ),
                            ),
                          );
                        },
                        onLongPress: () {
                          if (widget.isAdmin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditItemPage(
                                      item: item,
                                    ),
                              ),
                            );
                          }
                        });
                  },
                );
              }),
        ],
      ),
    );
  }
}
