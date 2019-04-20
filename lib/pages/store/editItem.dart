import 'dart:io';
import 'package:flutter_tags/input_tags.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/widgets/core/doubleButton.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/store/editItem/imagePicker.dart';

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
  TextEditingController stockCtr = TextEditingController();
  TextEditingController hechsherimCtr = TextEditingController();

  File _imageFile;
  String _imageChanged = "no image";
  List<String> _tags = [];
  bool _loading = false;

  void _saveChanges() async {
    setState(() {
     _loading = true; 
    });
    Item item = Item(
      barcode: barcodeCtr.text,
      name: nameCtr.text,
      desc: descCtr.text,
      image: widget.newItem ? "no image" : widget.item.image,
      price: double.parse(priceCtr.text),
      stock: int.parse(stockCtr.text),
      tags: _tags.join(","),
      hechsherim: hechsherimCtr.text,
    );
    bool res = await cloudFirestoreService.updateItem(
        item, _imageFile, _imageChanged);
    setState(() {
      _loading = false;
    });
    if (res) {
      Navigator.pop(context);
    }
  }

  void _onImageChanged(File file, String change) {
    setState(() {
      _imageFile = file;
      _imageChanged = change;
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
        _tags = widget.item.tags.split(",");
        stockCtr.text = widget.item.stock.toString();
        barcodeCtr.text = widget.item.barcode;
        hechsherimCtr.text = widget.item.hechsherim;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Hero(
                  tag: !widget.newItem ? widget.item.barcode : "new",
                  child: ImagePickerWidget(
                    currantImage: widget.item.image,
                    onImageChanged: _onImageChanged,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  controller: nameCtr,
                  decoration: InputDecoration(
                      prefixText: "Name: ",
                      border: InputBorder.none,
                      hintText: "Name"),
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                    fontFamily: "BrandFont",
                    fontSize: 65,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  controller: hechsherimCtr,
                  decoration: InputDecoration(
                      prefixText: "Hechsher: ",
                      border: InputBorder.none,
                      hintText: "Not kosher..."),
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  controller: descCtr,
                  maxLines: 7,
                  decoration: InputDecoration(
                      prefixText: "Description: ",
                      border: InputBorder.none,
                      hintText: "..."),
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  controller: priceCtr,
                  decoration: InputDecoration(
                      prefixText: "Price: ",
                      border: InputBorder.none,
                      hintText: "0.0"),
                  keyboardType: TextInputType.numberWithOptions(),
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  controller: stockCtr,
                  decoration: InputDecoration(
                      prefixText: "Stock: ",
                      border: InputBorder.none,
                      hintText: "0"),
                  keyboardType: TextInputType.numberWithOptions(),
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  controller: barcodeCtr,
                  decoration: InputDecoration(
                      prefixText: "Barcode: ",
                      border: InputBorder.none,
                      hintText: ""),
                  style: TextStyle(
                    fontFamily: "PrimaryFont",
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              InputTags(
                backgroundContainer: Theme.of(context).canvasColor,
                color: Colors.black,
                textStyle: TextStyle(
                  fontFamily: "PrimaryFont",
                  fontSize: 18,
                  color: Colors.white,
                ),
                tags: _tags,
                columns: 3,
                onDelete: (tag) => print(tag),
                onInsert: (tag) => print(tag),
              ),
              SizedBox(height: 24),
              DoubleButtonWidget(
                leftText: "Cancel",
                leftOnPressed: () {
                  Navigator.pop(context);
                },
                rightText: _loading ? "Saving..." : "Save",
                rightOnPressed: _saveChanges,
              ),
              SizedBox(height: 42),
            ],
          ),
        ),
      ),
    );
  }
}
