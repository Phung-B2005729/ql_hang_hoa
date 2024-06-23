import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/helper/template/app_theme.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';

class TongQuanScreen extends StatelessWidget {
  final AuthController controller = Get.find();

  TongQuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ArCH-TP',
          textAlign: TextAlign.start,
        ),
        leading: FractionallySizedBox(
            widthFactor: 0.6,
            child: Image.asset('assets/logo/logo_xanh_vang_x2.png')),
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        titleTextStyle: AppTheme.lightTextTheme.titleLarge,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20.0, top: 10),
            child: const Stack(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: ColorClass.color_outline_icon,
                  size: 30,
                ),
                Positioned(
                  left: 15,
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Obx(() => TextButton(
                onPressed: () => controller.logout(),
                child: Text(controller.hoTen.value != null
                    ? controller.hoTen.value!
                    : ''),
              )),
        ),
      ),
    );
  }
}
