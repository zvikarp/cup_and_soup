import 'package:intl/intl.dart';

class DateTimeUtil {
  DateTime stringToDate(String string) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(int.parse(string));
    return date;
  }

  String time(DateTime time) {
    return DateFormat('kk:mm').format(time);
  }

  String date(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }
}

final DateTimeUtil dateTimeUtil = DateTimeUtil();
