import 'dart:io';
import 'package:cup_and_soup/utils/themes.dart';
import 'package:flutter_tags/input_tags.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/utils/transparentRoute.dart';
import 'package:cup_and_soup/models/item.dart';
import 'package:cup_and_soup/dialogs/action.dart';
import 'package:cup_and_soup/widgets/core/doubleButton.dart';
import 'package:cup_and_soup/widgets/core/button.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:cup_and_soup/widgets/core/textFieldWrapper.dart';
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
  TextEditingController enNameCtr = TextEditingController();
  TextEditingController heNameCtr = TextEditingController();
  TextEditingController barcodeCtr = TextEditingController();
  TextEditingController enDescCtr = TextEditingController();
  TextEditingController heDescCtr = TextEditingController();
  TextEditingController priceCtr = TextEditingController();
  TextEditingController stockCtr = TextEditingController();
  TextEditingController positionCtr = TextEditingController();
  TextEditingController enHechsherimCtr = TextEditingController();
  TextEditingController heHechsherimCtr = TextEditingController();

  File _imageFile;
  String _imageChanged = "no image";
  List<String> _tags = ["setting:visible"];
  bool _loading = false;

  void _saveChanges() async {
    setState(() {
      _loading = true;
    });
    String errorMessage = "no error";
    if ((barcodeCtr.text.trim() == null) || (barcodeCtr.text.trim() == ""))
      errorMessage = "Please enter a barcode.";
    else if ((enNameCtr.text.trim() == null) || (enNameCtr.text.trim() == ""))
      errorMessage = "Please enter a EN name.";
    else if ((heNameCtr.text.trim() == null) || (heNameCtr.text.trim() == ""))
      errorMessage = "Please enter a HE name.";
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
      barcode: widget.newItem ? barcodeCtr.text.trim() : widget.item.barcode,
      name: {"en": enNameCtr.text.trim(), "he": heNameCtr.text.trim()},
      desc: {"en": enDescCtr.text.trim(), "he": heDescCtr.text.trim()},
      remoteImage: _imagePath(),
      price: double.parse(priceCtr.text.trim()),
      stock: int.parse(stockCtr.text.trim()),
      tags: _tags,
      hechsherim: {"en": enHechsherimCtr.text.trim(), "he": heHechsherimCtr.text.trim()},
      position: int.tryParse(positionCtr.text) ?? 0,
      lastUpdated: DateTime.now(),
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
        enNameCtr.text = widget.item.getName("en");
        heNameCtr.text = widget.item.getName("he");
        enDescCtr.text = widget.item.getDesc("en");
        heDescCtr.text = widget.item.getDesc("he");
        priceCtr.text = widget.item.price.toString();
        _tags = widget.item.tags;
        stockCtr.text = widget.item.stock.toString();
        positionCtr.text = widget.item.position.toString();
        barcodeCtr.text = widget.item.barcode;
        enHechsherimCtr.text = widget.item.getHechsherim("en");
        heHechsherimCtr.text = widget.item.getHechsherim("he");
      });
    }
  }

  Widget _enNameInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text(
          "EN Name: ",
          style: Theme.of(context).textTheme.headline.merge(TextStyle(color: themes.load("title"))),
        ),
        textField: TextFormField(
          controller: enNameCtr,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.words,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }

  Widget _heNameInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text(
          "HE Name: ",
          style: Theme.of(context).textTheme.headline.merge(TextStyle(color: themes.load("title"))),
        ),
        textField: TextFormField(
          controller: heNameCtr,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.words,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }

  Widget _enHechsherInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("EN Hechsher: "),
        textField: TextFormField(
          controller: enHechsherimCtr,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.sentences,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }

  Widget _heHechsherInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("HE Hechsher: "),
        textField: TextFormField(
          controller: heHechsherimCtr,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.sentences,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }

  Widget _enDescInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("EN Description: "),
        textField: TextFormField(
          controller: enDescCtr,
          maxLines: null,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.sentences,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }
  Widget _heDescInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("HE Description: "),
        textField: TextFormField(
          controller: heDescCtr,
          maxLines: null,
          decoration: InputDecoration(border: InputBorder.none),
          textCapitalization: TextCapitalization.sentences,
          style: Theme.of(context).textTheme.body1,
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
          style: Theme.of(context).textTheme.body1,
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
          style: Theme.of(context).textTheme.body1,
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
          enabled: widget.newItem,
          decoration: InputDecoration(border: InputBorder.none),
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }

  _positionInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFieldWrapperWidget(
        prefix: Text("Position: "),
        textField: TextFormField(
          controller: positionCtr,
          decoration: InputDecoration(border: InputBorder.none),
          keyboardType: TextInputType.numberWithOptions(),
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }

  Widget _tagsInput() {
    return InputTags(
      backgroundContainer: Theme.of(context).canvasColor,
      color: Colors.black,
      textStyle: Theme.of(context).textTheme.body1.merge(TextStyle(color: Colors.white)),
      tags: _tags,
      columns: 3,
      onDelete: (tag) => print(tag),
      onInsert: (tag) => print(tag),
    );
  }

  String _imagePath() {
    if (widget.newItem)
      return "no image";
    else if ((widget.item.remoteImage != null) && (widget.item.remoteImage != ""))
      return widget.item.remoteImage;
    else
      return "no image";
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
                    currantImage: widget.newItem ? "no image" : (widget.item.remoteImage != null) && (widget.item.remoteImage != "") && (widget.item.remoteImage != "no image") ? widget.item.remoteImage : "no image",
                    onImageChanged: _onImageChanged,
                  )),
              _enNameInput(),
              _heNameInput(),
              _enHechsherInput(),
              _heHechsherInput(),
              _enDescInput(),
              _heDescInput(),
              _priceInput(),
              _stockInput(),
              _barcodeInput(),
              _positionInput(),
              _tagsInput(),
              SizedBox(height: 24),
              DoubleButtonWidget(
                leftText: "CANCEL",
                leftOnPressed: () => Navigator.pop(context),
                rightText: _loading ? "SAVING..." : "SAVE",
                rightOnPressed: _saveChanges,
              ),
              !widget.newItem
                  ? ButtonWidget(
                      primary: false,
                      text: "DELETE ITEM",
                      onPressed: () async {
                        bool res = await Navigator.of(context).push(
                          TransparentRoute(
                            builder: (BuildContext context) =>
                                ActionDialog(type: "delete"),
                          ),
                        );
                        if (res) {
                          await cloudFirestoreService
                              .deleteItem(widget.item.barcode);
                          Navigator.pop(context);
                        }
                      },
                    )
                  : Container(),
              SizedBox(height: 42),
            ],
          ),
        ),
      ),
    );
  }
}
