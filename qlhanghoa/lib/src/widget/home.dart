import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/widget/shared/bottom_navgation.dart';

class Home extends StatelessWidget {
  final AuthController controller = Get.find();
  final BottomNavigationController bottomController = Get.find();

  Home({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      body: Obx(() => Center(
            child: BottomNavigationController
                .widgetOptions[bottomController.selected.value],
          )),
      bottomNavigationBar:
          BottomNavigationShare(bottomController: bottomController),
    );
  }
}
