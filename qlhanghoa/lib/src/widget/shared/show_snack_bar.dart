/*
các thuộc tính chính bạn có thể sử dụng khi gọi Get.snackbar:
title: Tiêu đề của Snackbar, thường là một chuỗi.
message: Nội dung của Snackbar, cũng là một chuỗi.
backgroundColor: Màu nền của Snackbar.
colorText: Màu của văn bản trong Snackbar.
icon: Biểu tượng hoặc hình ảnh được thêm vào Snackbar.
shouldIconPulse: Có cho biểu tượng nhấp nháy hay không.
barBlur: Độ mờ của phần nền xung quanh Snackbar.
overlayBlur: Độ mờ của phần nền toàn màn hình khi Snackbar xuất hiện.
snackPosition: Vị trí xuất hiện của Snackbar trên màn hình.
duration: Thời gian hiển thị Snackbar trước khi tự đóng.
leftBarIndicatorColor: Màu của thanh chỉ báo bên trái (chỉ áp dụng khi có leftBarIndicatorIcon).
leftBarIndicatorIcon: Biểu tượng hoặc hình ảnh chỉ báo bên trái.
mainButton: Nút chính trong Snackbar.
onTap: Hàm được gọi khi nhấn vào Snackbar.
snackStyle: Kiểu của Snackbar (SnackbarStyle.CUSTOM hoặc SnackbarStyle.FLOATING).
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetShowSnackBar {
  static void errorSnackBar(String message) {
    Get.snackbar("Error", message,
        backgroundColor: const Color.fromARGB(255, 252, 224, 224),
        colorText: Colors.red,
        shouldIconPulse: false,
        icon: Image.asset('assets/images/error.png', width: 30, height: 30));
  }

  // ignore: non_constant_identifier_names
  static void errorSnackBarBottom(String message) {
    Get.snackbar("Error", message,
        backgroundColor: const Color.fromARGB(255, 252, 224, 224),
        colorText: Colors.red,
        shouldIconPulse: false,
        snackPosition: SnackPosition.BOTTOM,
        icon: Image.asset('assets/images/error.png', width: 30, height: 30));
  }

  static void successSnackBarBottom(String message) {
    Get.snackbar("Success", message,
        backgroundColor: const Color.fromARGB(255, 236, 251, 237),
        colorText: Colors.green,
        shouldIconPulse: false,
        snackPosition: SnackPosition.BOTTOM,
        icon: Image.asset('assets/images/success.png', width: 30, height: 30));
  }

  static void successSnackBar(String message) {
    Get.snackbar("Success", message,
        backgroundColor: const Color.fromARGB(255, 236, 251, 237),
        colorText: Colors.green,
        shouldIconPulse: false,
        icon: Image.asset('assets/images/success.png', width: 30, height: 30));
  }

  static void warningSnackBar(String message) {
    Get.snackbar("Warning", message,
        backgroundColor: const Color.fromARGB(255, 250, 239, 228),
        colorText: Colors.orangeAccent,
        shouldIconPulse: false,
        icon: Image.asset('assets/images/warning.png', width: 30, height: 30));
  }

  static void warningSnackBarBottom(String message) {
    Get.snackbar("Warning", message,
        backgroundColor: const Color.fromARGB(255, 250, 239, 228),
        colorText: Colors.orangeAccent,
        shouldIconPulse: false,
        snackPosition: SnackPosition.BOTTOM,
        icon: Image.asset('assets/images/warning.png', width: 30, height: 30));
  }
}
