import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/giao_dich/giao_dich_controller.dart';
import 'package:qlhanghoa/src/controller/lo_hang/lo_hang_controller.dart';
import 'package:qlhanghoa/src/controller/account/login/login_controller.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/loai_hang/loai_hang_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/chi_tiet_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/controller/thuong_hieu/thuong_hieu.controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => BottomNavigationController(), fenix: true);
    Get.lazyPut(() => ThemHangHoaController(), fenix: true);
    Get.lazyPut(() => LoaiHangController(), fenix: true);
    Get.lazyPut(() => ThuongHieuController(), fenix: true);
    Get.lazyPut(() => HangHoaController(), fenix: true);
    Get.lazyPut(() => LoHangController(), fenix: true);
    Get.lazyPut(() => CuaHangController(), fenix: true);
    Get.lazyPut(() => GiaoDichController(), fenix: true);
    Get.lazyPut(() => PhieuNhapController(), fenix: true);
    Get.lazyPut(() => ChiTietPhieuNhapController(), fenix: true);
    Get.lazyPut(() => NhanVienController(), fenix: true);
  }

  void onDelete() async {
    await Get.delete<LoginController>();
  }
}
