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
}
