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

  final Function(String, DateTime, int, bool, int) onAmountSubmit;

  @override
  _AmountInputWidgetState createState() => _AmountInputWidgetState();
}

class _AmountInputWidgetState extends State<AmountInputWidget> {
  final TextEditingController _amountInputCtr = TextEditingController();
  TextEditingController _scansCtr = TextEditingController();
  TextEditingController _usageLimitCtr = TextEditingController();
  DateTime _dateTime;
  bool _userLimit;

  @override
  void initState() {
    super.initState();
    setState(() {
      _scansCtr.text = '1';
      _usageLimitCtr.text = '1';
      _userLimit = true;
      _dateTime = DateTime.now().add(Duration(minutes: 5));
    });
  }

  List<Widget> _dateTimeInput() {
    return [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Expiring date: ",
          style: Theme.of(context).textTheme.body2,
        ),
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

  List<Widget> _userLimitInput() {
    return [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "User limit: ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Every user can scan the barcode only once.",
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Switch(
              value: _userLimit,
              onChanged: (v) {
                setState(() {
                  _userLimit = v;
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _scansInput() {
    return [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Number of scans: ",
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      Container(
        child: TextField(
          style: Theme.of(context).textTheme.body1,
          controller: _scansCtr,
          keyboardType: TextInputType.numberWithOptions(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
          ),
        ),
      ),
    ];
  }

  List<Widget> _usageLimitInput() {
    return [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text("Uses per user: ", style: Theme.of(context).textTheme.body2),
      ),
      Container(
        child: TextField(
          style: Theme.of(context).textTheme.body1,
          controller: _usageLimitCtr,
          keyboardType: TextInputType.numberWithOptions(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
          ),
        ),
      ),
    ];
  }

  void _onCreateBarcodePressed() {
    int scans = int.tryParse(_scansCtr.text);
    int usageLimit = int.tryParse(_usageLimitCtr.text);
    String msg = "no error";
    if (double.tryParse(_amountInputCtr.text) == null) {
      msg = "Please enter a valid persentage";
    } else if (DateTime.tryParse(_dateTime.toString()) == null) {
      msg = "Please enter a valid date and time.";
    } else if ((scans < 1)) {
      msg = "Please enter a valid number of scans";
    } else if ((usageLimit < 1)) {
      msg = "Please enter a valid number of uses per user";
    } else {}
    if (msg != "no error") {
      SnackbarWidget.errorBar(context, msg);
      print("error");
      return;
    } else {
      if (scans == 1) scans = -1;
      widget.onAmountSubmit(
          _amountInputCtr.text, _dateTime, usageLimit, _userLimit, scans);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Text("Please enter the persentage discount you want to give:",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title),
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
            flex: [.3, .7],
            items: [
              _dateTimeInput(),
              _usageLimitInput(),
              _userLimitInput(),
              _scansInput(),
            ],
          ),
        ),
        SizedBox(height: 42),
      ],
    );
  }
}
