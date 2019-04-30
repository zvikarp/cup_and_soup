import 'package:cup_and_soup/widgets/core/divider.dart';
import 'package:cup_and_soup/widgets/core/table.dart';
import 'package:flutter/material.dart';

import 'package:cup_and_soup/widgets/core/center.dart';
import 'package:cup_and_soup/widgets/core/doubleButton.dart';
import 'package:cup_and_soup/widgets/core/snackbar.dart';
import 'package:cup_and_soup/utils/dateTime.dart';

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

  void _dateSelector() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 600)),
    );
    if (picked != null) {
      setState(() {
        _dateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _dateTime.hour,
          _dateTime.minute,
        );
      });
    }
  }

  void _timeSelector() async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute),
    );
    if (picked != null) {
      setState(() {
        _dateTime = DateTime(
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  List<Widget> _dateTimeInput() {
    return [
      Text(
        "Expiring date: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: _dateSelector,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 1))),
              child: Text(dateTimeUtil.date(_dateTime)),
            ),
          ),
          GestureDetector(
            onTap: _timeSelector,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black54, width: 1))),
              child: Text(dateTimeUtil.time(_dateTime)),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _dateTime = DateTime.now().add(Duration(minutes: 5));
              });
            },
            child: Icon(
              Icons.refresh,
              size: 20,
            ),
          )
        ],
      )
    ];
  }

  List<Widget> _userLimitInput() {
    return [
      Text(
        "User limit: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Every user can scan the barcode only once.",
                style: TextStyle(
                  fontFamily: "PrimaryFont",
                  color: Colors.black54,
                  fontSize: 16,
                ),
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
      Text(
        "Number of scans: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        child: TextField(
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
          ),
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
      Text(
        "Uses per user: ",
        style: TextStyle(
          fontFamily: "PrimaryFont",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        child: TextField(
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 18,
          ),
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
      widget.onAmountSubmit(_amountInputCtr.text, _dateTime, usageLimit, _userLimit, scans);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Please enter the persentage discount you want to give:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PrimaryFont",
              fontSize: 24,
            ),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "PrimaryFont",
                    fontSize: 30,
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
            rightText: "Create Barcode",
            leftOnPressed: () => Navigator.pop(context),
            leftText: "Cancel",
          ),
        ),
        DividerWidget(),
        Text(
          "Advanced Settings",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PrimaryFont",
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TableWidget(
            headings: [" ", " "],
            flex: [3, 5],
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
