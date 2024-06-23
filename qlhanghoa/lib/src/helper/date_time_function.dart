import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatetimeFunction {
  final DateTime? time;
  DatetimeFunction({this.time});

  static String getStringFormDateTime(DateTime timeDate) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timeDate);
  }

  static DateTime getDateTimeFormString(String time) {
    DateFormat format = DateFormat('dd/MM/yyyy HH:mm');
    return format.parse(time);
  }

  static TimeOfDay getTimeOfDay(DateTime time) {
    return TimeOfDay.fromDateTime(time);
  }

  static bool sosanhTwoStringDatime(String date1, String date2) {
    DateTime timet1 = getDateTimeFormString(date1);
    DateTime timet2 = getDateTimeFormString(date2);
    if (timet1.isBefore(timet2)) {
      return true;
    } else {
      return false;
    }
  }

  static bool sosanhDatimeWithDateNow(String date1, String date2) {
    // ignore: unused_local_variable
    DateTime timeNow = DateTime.now();
    DateTime timetmo = getDateTimeFormString(date1); // mở đề
    DateTime timetdong = getDateTimeFormString(date2); // đóng đề
    if (timeNow.isAfter(timetmo) && timeNow.isBefore(timetdong)) {
      // timenow nằm giữa mở và đống
      return true;
    } else {
      return false;
    }
  }
}
