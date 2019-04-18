import 'dart:io';
import 'package:flutter_tags/input_tags.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  File _imageFile;
  String _imageUrl = "no image";
  String _placeholder = "assets/images/loading.png";

  void _saveChanges() async {
    Item item = Item(
      barcode: barcodeCtr.text,
      name: nameCtr.text,
      desc: descCtr.text,
      image: widget.newItem ? "no image" : widget.item.image,
      price: double.parse(priceCtr.text),
      stock: int.parse(stockCtr.text),
      tags: tagsCtr.text,
      hechsherim: hechsherimCtr.text,
    );
    bool res = await cloudFirestoreService.updateItem(item, _imageUrl == "file" ? _imageFile : null);
    if (res) {
      Navigator.pop(context);
    }
  }

  void _getImage() async {
    var newImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImage == null) return;
    setState(() {
      _imageFile = newImage;
      _imageUrl = "file";
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.newItem) {
      setState(() {
        if (widget.item.image != "no image") {
          _imageUrl = widget.item.image;
        }
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.all(36),
                      height: 230,
                      child: Hero(
                        tag: widget.item.barcode,
                        child: _imageUrl == "file" ? Image.file(
                                _imageFile,
                                fit: BoxFit.contain,
                              )
                            : _imageUrl == "no image" ? Image.asset(
                                _placeholder,
                                fit: BoxFit.contain,
                              ) : FadeInImage.assetNetwork(
                                placeholder: 'assets/images/loading.png',
                                image: _imageUrl,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                      child: IconButton(
                        iconSize: 36,
                        color: Colors.white,
                        icon: Icon(Icons.camera_alt),
                        onPressed: _getImage,
                      ),
                    ),
                  )
                ],
              ),
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
              InputTags(
                backgroundContainer: Theme.of(context).canvasColor,
                color: Colors.black,
                textStyle: TextStyle(
                  fontFamily: "PrimaryFont",
                  fontSize: 18,
                  color: Colors.white,
                ),
                tags: tagsCtr.text.split(","),
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
                rightText: "Save",
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
