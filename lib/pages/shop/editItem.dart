import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/page.dart';

class EditItemPage extends StatefulWidget {
  EditItemPage({
    @required this.item,
  });

  final Map<String, dynamic> item;

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {

  TextEditingController nameCtr = TextEditingController();
  TextEditingController descCtr = TextEditingController();
  TextEditingController priceCtr = TextEditingController();
  TextEditingController tagsCtr = TextEditingController();
  TextEditingController stockCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
     nameCtr.text = widget.item['name'];
     descCtr.text = widget.item['desc'];
     priceCtr.text = widget.item['price'].toString();
     tagsCtr.text = widget.item['tags'];
     stockCtr.text = widget.item['stock'].toString();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWidget(
        title: "edit ${widget.item['name']}",
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nameCtr,
            ), // name
            TextFormField(
              controller: descCtr,
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
          ],
        )
      ),
    );
  }
}