import 'dart:io';
import 'package:flutter_tags/input_tags.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/widgets/core/doubleButton.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/widgets/store/editItem/imagePicker.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:cup_and_soup/widgets/core/textFieldWrapper.dart';

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
    String errorMessage = "no error";
    if ((barcodeCtr.text.trim() == null) || (barcodeCtr.text.trim() == ""))
      errorMessage = "Please enter a barcode.";
    else if ((nameCtr.text.trim() == null) || (nameCtr.text.trim() == ""))
      errorMessage = "Please enter a name.";
    else if ((priceCtr.text.trim() == null) || (priceCtr.text.trim() == ""))
      errorMessage = "Please enter a price.";
    else if (double.tryParse(priceCtr.text.trim()) == null)
      errorMessage = "Please enter a valid price.";
    else if (double.tryParse(priceCtr.text.trim()) < 0)
      errorMessage = "The price can't be negative.";
    else if ((stockCtr.text.trim() == null) || (stockCtr.text.trim() == ""))
      errorMessage = "Please enter the stock.";
    else if (int.tryParse(stockCtr.text.trim()) == null)
      errorMessage = "Please enter a valid stock.";
    else if (double.tryParse(stockCtr.text.trim()) < 0)
      errorMessage = "The stock can't be negative.";
    else {}
    if (errorMessage != "no error") {
      SnackbarWidget.errorBar(context, errorMessage);
      setState(() {
        _loading = false;
      });
      return;
    }
    Item item = Item(
      barcode: barcodeCtr.text.trim(),
      name: nameCtr.text.trim(),
      desc: descCtr.text,
      image: widget.newItem ? "no image" : widget.item.image,
      price: double.parse(priceCtr.text.trim()),
      stock: int.parse(stockCtr.text.trim()),
      tags: _tags.join(","),
      hechsherim: hechsherimCtr.text.trim(),
    );
    String res = await cloudFirestoreService.updateItem(item, _imageFile,
        _imageChanged, !widget.newItem ? widget.item.barcode : "");
    setState(() {
      _loading = false;
    });
    if (res == "ok") {
      Navigator.pop(context);
    } else {
      SnackbarWidget.errorBar(context, res);
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

  Widget _nameInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text(
          "Name: ",
          style: TextStyle(
            fontFamily: "BrandFont",
            fontSize: 65,
          ),
        ),
        textField: TextFormField(
          controller: nameCtr,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
            fontFamily: "BrandFont",
            fontSize: 65,
          ),
        ),
      ),
    );
  }

  Widget _hechsherInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("Hechsher: "),
        textField: TextFormField(
          controller: hechsherimCtr,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _descInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("Description: "),
        textField: TextFormField(
          controller: descCtr,
          maxLines: 7,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _priceInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("Price: "),
        textField: TextFormField(
          controller: priceCtr,
          decoration: InputDecoration(border: InputBorder.none),
          keyboardType: TextInputType.numberWithOptions(),
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  _stockInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("Stock: "),
        textField: TextFormField(
          controller: stockCtr,
          decoration: InputDecoration(border: InputBorder.none),
          keyboardType: TextInputType.numberWithOptions(),
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _barcodeInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("Barcode: "),
        textField: TextFormField(
          controller: barcodeCtr,
          decoration: InputDecoration(border: InputBorder.none),
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _tagsInput() {
    return InputTags(
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
    );
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
                    currantImage:
                        !widget.newItem ? widget.item.image : "no image",
                    onImageChanged: _onImageChanged,
                  )),
              _nameInput(),
              _hechsherInput(),
              _descInput(),
              _priceInput(),
              _stockInput(),
              _barcodeInput(),
              _tagsInput(),
              SizedBox(height: 24),
              DoubleButtonWidget(
                leftText: "Cancel",
                leftOnPressed: () {
                  Navigator.pop(context);
                },
                rightText: _loading ? "Saving..." : "Save",
                rightOnPressed: _saveChanges,
              ),
              !widget.newItem ? ButtonWidget(
                primary: false,
                size: "small",
                text: "Delete Item",
                onPressed: () async {
                  await cloudFirestoreService.deleteItem(widget.item.barcode);
                  Navigator.pop(context);
                },
              ) : Container(),
              SizedBox(height: 42),
            ],
          ),
        ),
      ),
    );
  }
}
