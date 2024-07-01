import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/account/tai_khoan_controller.dart';
import 'package:qlhanghoa/src/controller/giao_dich/giao_dich_controller.dart';
import 'package:qlhanghoa/src/controller/lo_hang/lo_hang_controller.dart';
import 'package:qlhanghoa/src/controller/account/login/login_controller.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/loai_hang/loai_hang_controller.dart';
import 'package:qlhanghoa/src/controller/nha_cung_cap/nha_cung_cap_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/nhap_lo_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/them_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/xem_chi_tiet/chi_tiet_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/controller/thuong_hieu/thuong_hieu.controller.dart';
import 'package:qlhanghoa/src/controller/tong_quan_controller.dart';

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
    Get.lazyPut(() => NhaCungCapController(), fenix: true);
    Get.lazyPut(() => ThemPhieuNhapController(), fenix: true);
    Get.lazyPut(() => NhapLoController(), fenix: true);
    Get.lazyPut(() => TaiKhoanController(), fenix: true);
    Get.lazyPut(() => TongQuanController(), fenix: true);
  }

  void onDelete() async {
    await Get.delete<LoginController>();
    Get.delete<AuthController>();
    Get.delete<BottomNavigationController>();
    Get.delete<ThemHangHoaController>();
    Get.delete<LoaiHangController>();
    Get.delete<ThuongHieuController>();
    Get.delete<HangHoaController>();
    Get.delete<LoHangController>();
    Get.delete<CuaHangController>();
    Get.delete<GiaoDichController>();
    Get.delete<PhieuNhapController>();
    Get.delete<ChiTietPhieuNhapController>();
    Get.delete<NhanVienController>();
    Get.delete<NhaCungCapController>();
    Get.delete<ThemPhieuNhapController>();
    Get.delete<NhapLoController>();
    Get.delete<TaiKhoanController>();
    Get.delete<TongQuanController>();
  }
}
