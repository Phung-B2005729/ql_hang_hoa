import 'package:intl/intl.dart';

class FunctionHelper {
  static String formNum(dynamic s) {
    try {
      print('gọi');
      // Kiểm tra xem giá trị đầu vào có phải là một số không
      if (s is num) {
        return NumberFormat.decimalPattern().format(s);
      } else {
        // print('gọi double');
        // print(NumberFormat.decimalPattern().format(double.parse('20.5')));
        return NumberFormat.decimalPattern().format(double.parse(s));
      }
    } catch (e) {
      print('Error formatting number: $e');
      return ''; // Trả về chuỗi rỗng nếu không thể chuyển đổi thành số kiểu double
    }
  }

  static dynamic replacePice(String s) {
    return s.replaceAll(',', '');
  }

  // đổi định dạng của string thành dd/mm/yyyy
  static String formatDateString(String dateString) {
    // Parse the input date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);
    DateTime vietnamDatetime = dateTime.add(Duration(hours: 7));

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('dd/MM/yyyy').format(vietnamDatetime);

    return formattedDate;
  }

  static String formatDateString2(String dateString) {
    // Parse the input date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);
    DateTime vietnamDatetime = dateTime.add(Duration(hours: 7));

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('yyyy-mm-dd').format(vietnamDatetime);

    return formattedDate;
  }

  // đổi định trạng của string dề dd/mm/yyyy hh:mm
  static String formatDateTimeString(String dateTimeString) {
    // Parse the input date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);
    // Convert UTC datetime to Vietnam time (UTC+7)
    DateTime vietnamDatetime = dateTime.add(Duration(hours: 7));

    // Format the DateTime object into the desired format
    String formattedDateTime =
        DateFormat('dd/MM/yyyy HH:mm').format(vietnamDatetime);

    return formattedDateTime;
  }

  // chuyển date time về string múi giờ utc
  static String getStringUTCFromDateVN(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  // chuyển string về date múi giờ việt nam
  static DateTime getDataTimeVnFormStringUTC(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime vietnamDatetime = dateTime.add(const Duration(hours: 7));
    return vietnamDatetime;
  }

  static DateTime getDateTimeFromStringUTC(String time) {
    DateFormat format = DateFormat('dd/MM/yyyy');
    return format.parse(time);
  }

  static bool soSanhTwoStringUTCWithToDay(String date1, String date2) {
    try {
      print(date1);
      print(date2);
      String timeNow =
          formatDateString(DateTime.now().toUtc().toIso8601String());

      String time2 = formatDateString(date2);
      String time1 = formatDateString(date1);
      print(('so sánh'));
      print(time1);
      print(time2);
      print(timeNow);

      if (time1 == time2 && time1 == timeNow) {
        print(true);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error parsing date: $e');
      return false;
    }
  }

  static int sosanhTwoStringUTC(String date1, String date2) {
    String time2 = formatDateString(date2);
    String time1 = formatDateString(date1);
    return time1.compareTo(time2); // âm nhỏ, dương lớn , 0 = bằng
  }

  static bool sosanhBang(String date1, String date2) {
    DateTime timet1 = DateTime.parse(date1);
    DateTime timet2 = DateTime.parse(date2);
    if ((timet1.isAtSameMomentAs(timet2))) {
      return true;
    } else {
      return false;
    }
  }

  //

  static DateTime getDateTimeBatDauFromDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getDateTimeKetThucFromDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static int soSanhTwoDateTime(DateTime date1, DateTime date2) {
    if (date1.isBefore(date2)) {
      // nhỏ hơn
      return -1;
    } else if (date1.isAtSameMomentAs(date2)) {
      // bằng
      return 0;
    } else {
      return 1;
    }
  }

  // từ string UTC to DateTimeVN
  // Chọn xong từ DateTiemVN so sánh => thông báo => chuyển về String UTC
  // từ dateTimeVN đưa về thời gian bắt đâù kể thúc sau đó chuyển về String UTC
}
