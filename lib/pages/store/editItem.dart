import 'dart:io';
import 'package:flutter_tags/input_tags.dart';
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

  /*void _getImage() async {
    var newImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = newImage;
    });
  }*/

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
                decoration: InputDecoration(
                labelText: 'Item Name:' ),
                
              ),
               TextFormField(
                controller: hechsherimCtr,
                decoration: InputDecoration(
                labelText: 'Hechsherim::'),// hechsherim
              ),  // name
              TextFormField(
                controller: descCtr,
                decoration: InputDecoration(
                labelText: 'Description:'),
              ), // description
              TextField(
                controller: barcodeCtr,
              ), // description
              
              InputTags(
      
                                  tags: ["a", "b"],
                                  columns: 8,
                                  fontSize: 14,
                                  symmetry: false,
                                  iconBackground: Colors.green[800],
                                  lowerCase: true,
                                  autofocus: false,
                                  
                                  // popupMenuBuilder: (String tag){
                                  //     return <PopupMenuEntry>[
                                  //         PopupMenuItem(
                                  //             child: Text(tag,
                                  //                 style: TextStyle(
                                  //                     color: Colors.black87,fontWeight: FontWeight.w800
                                  //                 ),
                                  //             ),
                                  //             enabled: false,
                                  //         ),
                                  //         PopupMenuDivider(),
                                  //         PopupMenuItem(
                                  //             value: 1,
                                  //             child: Row(
                                  //                 children: <Widget>[
                                  //                     Icon(Icons.content_copy,size: 18,),
                                  //                     Text(" Copy text"),
                                  //                 ],
                                  //             ),
                                  //         ),
                                  //         PopupMenuItem(
                                  //             value: 2,
                                  //             child: Row(
                                  //                 children: <Widget>[
                                  //                     Icon(Icons.delete,size: 18),
                                  //                     Text(" Remove"),
                                  //                 ],
                                  //             ),
                                  //         )
                                  //     ];
                                  // },
                                  // popupMenuOnSelected: (int id,String tag){
                                  //     switch(id){
                                  //         case 1:
                                  //             Clipboard.setData( ClipboardData(text: tag));
                                  //             break;
                                  //         case 2:
                                  //             setState(() {
                                  //                 _inputTags.remove(tag);
                                  //             });
                                  //     }
                                  // },
                                  //textFieldHidden: true,
                                  //boxShadow: [],
                                  //offset: -2,
                                  //padding: EdgeInsets.only(left: 11),
                                  //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                  //iconPadding: EdgeInsets.all(5),
                                  //iconMargin: EdgeInsets.only(right:5,left: 2),
                                  //borderRadius: BorderRadius.all(Radius.elliptical(50, 5)),
                                  onDelete: (tag) => print(tag),
                                  onInsert: (tag) => print(tag),

                              ),
              /*TextFormField(
                controller: tagsCtr,
              ),*/ // tags
              TextFormField(
                controller: stockCtr, 
                decoration: InputDecoration(
                labelText: 'Number in stock:'),
              ), // stock
             
              TextFormField(
                controller: priceCtr,
                decoration: InputDecoration(
                labelText: 'Price:'),
              ), // price
              /*ButtonWidget(
                text: "upload image",
                onPressed: _getImage,
              ),*/
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
