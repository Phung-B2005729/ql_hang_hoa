import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/account/login/login_controller.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/loai_hang/loai_hang_controller.dart';
import 'package:qlhanghoa/src/controller/thuong_hieu/thuong_hieu.controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => BottomNavigationController(), fenix: true);
    Get.lazyPut(() => ThemHangHoaController(), fenix: true);
    Get.lazyPut(() => LoaiHangController(), fenix: true);
    Get.lazyPut(() => ThuongHieuController(), fenix: true);
  }

  void onDelete() async {
    await Get.delete<LoginController>();
  }
}
