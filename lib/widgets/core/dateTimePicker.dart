import 'package:cup_and_soup/utils/dateTime.dart';
import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  DateTimePicker({
    @required this.initDateTime,
    this.onDateTimeChange,
    this.firstDateTime,
    this.lastDateTime,
  });

  final DateTime initDateTime;
  final Function(DateTime) onDateTimeChange;
  final DateTime firstDateTime;
  final DateTime lastDateTime;

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime dateTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      dateTime = widget.initDateTime;
    });
  }

  void _datePicker(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: widget.firstDateTime != null
          ? widget.firstDateTime
          : widget.initDateTime.add(Duration(days: -30)),
      lastDate: widget.lastDateTime != null
          ? widget.lastDateTime
          : widget.initDateTime.add(Duration(days: 1000)),
    );
    if (picked != null) {
      setState(() {
        dateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          dateTime.hour,
          dateTime.minute,
        );
      });
      if (widget.onDateTimeChange != null) widget.onDateTimeChange(dateTime);
    }
  }

  void _timePicker(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
    );
    if (picked != null) {
      setState(() {
        dateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          picked.hour,
          picked.minute,
        );
      });
      if (widget.onDateTimeChange != null) widget.onDateTimeChange(dateTime);
    }
  }

  Widget _displayDate() {
    return GestureDetector(
      onTap: () => _datePicker(context),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black54, width: 1))),
        child: Text(dateTimeUtil.date(dateTime)),
      ),
    );
  }

  Widget _displayTime() {
    return GestureDetector(
      onTap: () => _timePicker(context),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black54, width: 1))),
        child: Text(dateTimeUtil.time(dateTime)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _displayDate(),
        SizedBox(width: 24),
        _displayTime(),
      ],
    );
  }
}
