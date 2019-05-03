import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/dateTimePicker.dart';
import 'package:cup_and_soup/widgets/core/center.dart';
import 'package:cup_and_soup/widgets/core/doubleButton.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/table.dart';

class AmountInputWidget extends StatefulWidget {
  AmountInputWidget({
    @required this.onAmountSubmit,
  });

  final Function(String, DateTime) onAmountSubmit;

  @override
  _AmountInputWidgetState createState() => _AmountInputWidgetState();
}

class _AmountInputWidgetState extends State<AmountInputWidget> {
  final TextEditingController _amountInputCtr = TextEditingController();
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dateTime = DateTime.now().add(Duration(minutes: 5));
    });
  }

  List<Widget> _dateTimeInput() {
    return [
      Text(
        "Expiring date: ",
        style: Theme.of(context).textTheme.body2,
      ),
      DateTimePicker(
        initDateTime: _dateTime,
        onDateTimeChange: (DateTime dateTime) {
          setState(() {
            _dateTime = dateTime;
          });
        },
      ),
    ];
  }

  void _onCreateBarcodePressed() {
    String msg = "no error";
    if (double.tryParse(_amountInputCtr.text) == null) {
      msg = "Please enter a valid amount to transfer";
    } else if (DateTime.tryParse(_dateTime.toString()) == null) {
      msg = "Please enter a valid date and time.";
    } else {}
    if (msg != "no error") {
      SnackbarWidget.errorBar(context, msg);
      print("error");
      return;
    } else {
      widget.onAmountSubmit(_amountInputCtr.text, _dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Please enter the new credit:",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: CenterWidget(
            child: Center(
              child: Container(
                width: 200,
                child: TextFormField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: _amountInputCtr,
                  textAlign: TextAlign.center,
                  onFieldSubmitted: (s) => _onCreateBarcodePressed(),
                  style: Theme.of(context).textTheme.display1.merge(
                        TextStyle(color: Colors.white),
                      ),
                  keyboardType: TextInputType.numberWithOptions(),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: DoubleButtonWidget(
            rightOnPressed: () => _onCreateBarcodePressed(),
            rightText: "CREATE BARCODE",
            leftOnPressed: () => Navigator.pop(context),
            leftText: "CANCEL",
          ),
        ),
        DividerWidget(),
        Text(
          "Advanced Settings",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TableWidget(
            headings: [" ", " "],
            flex: [3, 5],
            items: [
              _dateTimeInput(),
            ],
          ),
        ),
        SizedBox(height: 42),
      ],
    );
  }
}
