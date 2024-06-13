import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';

class BottomNavigationShare extends StatelessWidget {
  const BottomNavigationShare({
    super.key,
    required this.bottomController,
  });

  final BottomNavigationController bottomController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartLine),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.box),
            label: 'Hàng hoá',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Nhập hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Nhiều hơn',
          ),
        ],
        currentIndex: bottomController.selected.value,
        selectedItemColor: ColorClass.color_tap_active,
        unselectedItemColor: ColorClass.color_cancel,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) => bottomController.changeItem(index),
      ),
    );
  }
}
