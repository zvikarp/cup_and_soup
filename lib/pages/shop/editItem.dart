import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/widgets/core/doubleButton.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';

class EditItemPage extends StatefulWidget {
  EditItemPage({
    this.item,
    this.newItem = false,
  });

  final Item item;
  final bool newItem;

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController barcodeCtr = TextEditingController();
  TextEditingController descCtr = TextEditingController();
  TextEditingController priceCtr = TextEditingController();
  TextEditingController tagsCtr = TextEditingController();
  TextEditingController stockCtr = TextEditingController();
  TextEditingController hechsherimCtr = TextEditingController();

  void _saveChanges() async {
    Item item = Item(
      barcode: barcodeCtr.text,
      name: nameCtr.text,
      desc: descCtr.text,
      image: widget.newItem ? "image url" : widget.item.image,
      price: double.parse(priceCtr.text),
      stock: int.parse(stockCtr.text),
      tags: tagsCtr.text,
      hechsherim: hechsherimCtr.text,
    );
    bool res = await cloudFirestoreService.updateItem(item);
    if (res) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!widget.newItem) {
      setState(() {
        nameCtr.text = widget.item.name;
        descCtr.text = widget.item.desc;
        priceCtr.text = widget.item.price.toString();
        tagsCtr.text = widget.item.tags;
        stockCtr.text = widget.item.stock.toString();
        barcodeCtr.text = widget.item.barcode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
          title: widget.newItem ? "create new item" : "edit ${widget.item.name}",
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameCtr,
              ), // name
              TextFormField(
                controller: descCtr,
              ), // description
              TextFormField(
                controller: barcodeCtr,
              ), // description
              TextFormField(
                controller: priceCtr,
              ), // price
              TextFormField(
                controller: tagsCtr,
              ), // tags
              TextFormField(
                controller: stockCtr,
              ), // stock
              TextFormField(
                controller: hechsherimCtr,
              ), // hechsherim
              DoubleButtonWidget(
                leftText: "Cancel",
                leftOnPressed: () {
                  Navigator.pop(context);
                },
                rightText: "Save",
                rightOnPressed: _saveChanges,
              )
            ],
          )),
    );
  }
}
