import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cup_and_soup/widgets/core/page.dart';
import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/widgets/core/doubleButton.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
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

  File image;

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

  void _getImage() async {
    var newImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = newImage;
    });
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
        hechsherimCtr.text = widget.item.hechsherim;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
          title:
              widget.newItem ? "create new item" : "edit ${widget.item.name}",
          child: Column(
            children: <Widget>[
              Container(
                child: image == null
                    ? Container()
                    : Image.file(
                        image,
                        height: 200,
                      ),
              ),
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
              ButtonWidget(
                text: "upload image",
                onPressed: _getImage,
              ),
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
