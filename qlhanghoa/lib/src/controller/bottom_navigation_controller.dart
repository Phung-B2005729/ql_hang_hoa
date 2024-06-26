import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/phieu_nhap_screen.dart';
import 'package:qlhanghoa/src/widget/nhieu_hon_screen.dart';
import 'package:qlhanghoa/src/widget/tong_quan_screen.dart';

class BottomNavigationController extends GetxController {
  RxInt selected = 0.obs;
// Specify the type of widgetOptions list
  static List<Widget> widgetOptions = [
    TongQuanScreen(),
    HangHoaScreen(),
    PhieuNhapScreen(),
    NhieuHonScreen(),
  ];
  void changeItem(int index) {
    selected.value = index;
  }
}
