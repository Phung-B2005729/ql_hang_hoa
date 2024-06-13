import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qlhanghoa/src/binding/all_binding.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/helper/template/app_theme.dart';
import 'package:qlhanghoa/src/widget/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AllBinding().dependencies();

  // Lấy đường dẫn lưu trữ cho Hive
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path;

  // Khởi tạo Hive với đường dẫn lưu trữ đã lấy
  await Hive.initFlutter(path);
  await Hive.openBox(AppConfig.storageBox);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Quản Lý Hàng Hoá",
        initialBinding: AllBinding(),
        theme: AppTheme.light(),
        home:
            Home() /* Obx(() => controller.isLogon!.value ? Home() : const Login())*/
        );
  }
}
