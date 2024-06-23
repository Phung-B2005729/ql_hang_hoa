import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';
import 'package:qlhanghoa/src/service/phieu_nhap_service.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class PhieuNhapController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa

  // list lấy từ service
  RxList<PhieuNhapModel> listPhieuNhap = <PhieuNhapModel>[].obs;
  RxString ngayDBOld = ''.obs;
  RxString ngayKTOld = ''.obs;
  // lộc tìm kiếm
  RxBool onSubmit = false.obs;
  RxString ngayBatDau = ''.obs;
  RxString ngayKetThuc = ''.obs;
  List<String> listTrangThai = [
    'Tất cả',
    'Đã nhập hàng',
    'Đã huỷ',
    'Phiếu tạm'
  ];

  //thông tin lộc
  RxString maCuaHang = 'Tất cả'.obs; // cho chọn select
  RxString maNhanVien = 'Tất cả'.obs; // cho chọn select
  RxString trangThai = 'Đã nhập hàng'.obs;
  // cho nhập
  TextEditingController thongTinHangHoa = TextEditingController();
  TextEditingController thongTinLoHang = TextEditingController();
  TextEditingController thongTinNhaCungCap = TextEditingController();
  TextEditingController thongTinPhieuNhap = TextEditingController();

  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    setNgayMaDinhToDay();
    reSetUpData();
    print('gọi int');
    await getlistPhieuNhap(
        ngayBatDau: ngayBatDau.value,
        ngayKetThuc: ngayKetThuc.value,
        trangThai: trangThai.value,
        maCuaHang: maCuaHang.value,
        maNhanVien: maNhanVien.value,
        thongTinHangHoa: thongTinHangHoa.text,
        thongTinLoHang: thongTinLoHang.text,
        thongTinPhieuNhap: thongTinPhieuNhap.text,
        thongTinNhaCungCap: thongTinNhaCungCap.text);
  }

  void setNgayMaDinhToDay() async {
    DateTime now = DateTime.now().toUtc();
    ngayBatDau.value =
        DateTime(now.year, now.month, now.day).toUtc().toIso8601String();
    ngayKetThuc.value = DateTime(now.year, now.month, now.day, 23, 59, 59)
        .toUtc()
        .toIso8601String();
    ngayDBOld.value = ngayBatDau.value;
    ngayKTOld.value = ngayKetThuc.value;
  }

  void setNgayBatDau(DateTime date) {
    print('gọi set ngày bắt đầu');
    if (ngayKetThuc.isNotEmpty) {
      // so sánh
      // chuyển ngayKetThuc về date
      if (FunctionHelper.sosanhTwoStringUTC(
              date.toIso8601String(), ngayKetThuc.value) >
          0) {
        // bằng bắt đầu lớn hơn kết thúc
        GetShowSnackBar.warningSnackBar(
            'Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc');
        // ngayBatDau.value = ''; không cập nhật ngày bắt đầu
      } else {
        ngayDBOld.value = ngayBatDau.value;
        print(ngayDBOld.value);
        ngayBatDau.value = FunctionHelper.getStringUTCFromDateVN(date);
      }
    } else {
      ngayDBOld.value = ngayBatDau.value;
      print(ngayDBOld.value);
      ngayBatDau.value = FunctionHelper.getStringUTCFromDateVN(date);
    }
    print('ngày bd củ' + ngayDBOld.value);
    print('ngày kt củ' + ngayKTOld.value);
  }

  void setNgayKetThuc(DateTime date) {
    print('gọi set ngày kết thúc');
    if (ngayBatDau.isNotEmpty) {
      // so sánh
      // chuyển ngayKetThuc về date

      if (FunctionHelper.sosanhTwoStringUTC(
              date.toIso8601String(), ngayBatDau.value) <
          0) {
        // bằng bắt đầu lớn hơn kết thúc
        GetShowSnackBar.warningSnackBar(
            'Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu');
        // ngayBatDau.value = ''; không cập nhật ngày bắt đầu
      } else {
        ngayKTOld.value = ngayKetThuc.value;
        ngayKetThuc.value = FunctionHelper.getStringUTCFromDateVN(date);
      }
    } else {
      ngayKTOld.value = ngayKetThuc.value;
      ngayKetThuc.value = FunctionHelper.getStringUTCFromDateVN(date);
    }
    print('ngày kt củ' + ngayKTOld.value);
    print(ngayDBOld.value);
  }

  void soSanhVaSetLaiNgayKetThuc() {
    // xem 2 thằng này có bằng nhau không ?

    if (FunctionHelper.sosanhTwoStringUTC(
            ngayBatDau.value, ngayKetThuc.value) ==
        0) {
      ngayKTOld.value = ngayKetThuc.value;
      ngayDBOld.value = ngayBatDau.value;
      // chuyển về vn lấy

      DateTime timeVN = FunctionHelper.getDateTimeKetThucFromDate(
          FunctionHelper.getDataTimeVnFormStringUTC(ngayKetThuc.value));
      ngayKetThuc.value = FunctionHelper.getStringUTCFromDateVN(timeVN);

      //
      DateTime timeVN2 = FunctionHelper.getDateTimeBatDauFromDate(
          FunctionHelper.getDataTimeVnFormStringUTC(ngayBatDau.value));
      ngayBatDau.value = FunctionHelper.getStringUTCFromDateVN(timeVN2);
    }
  }

  void reSetUpData() {
    setNgayMaDinhToDay();
    maCuaHang.value = AuthUtil.getMaCuaHang() ?? 'Tất cả';
    maNhanVien.value = 'Tất cả';
    trangThai.value = 'Đã nhập hàng';
    thongTinHangHoa.text = '';
    thongTinLoHang.text = '';
    thongTinNhaCungCap.text = '';
    thongTinPhieuNhap.text = '';
    thongTinLoHang.text = '';
    onSubmit.value = false;
  }

  void reSetTimKiem() {
    maCuaHang.value = AuthUtil.getMaCuaHang() ?? 'Tất cả';
    maNhanVien.value = 'Tất cả';

    trangThai.value = 'Đã nhập hàng';
    thongTinHangHoa.text = '';
    thongTinLoHang.text = '';
    thongTinNhaCungCap.text = '';
    thongTinPhieuNhap.text = '';
    thongTinLoHang.text = '';
    onSubmit.value = false;
  }

  void traVeNgayCu() {
    print('gọi trả về ngày củ');
    ngayBatDau.value = ngayDBOld.value;
    ngayKetThuc.value = ngayKTOld.value;
    print(ngayDBOld.value);
    print(ngayKTOld.value);
  }

  void setNgayCu() {
    ngayDBOld.value = ngayBatDau.value;
    ngayKTOld.value = ngayKTOld.value;
  }

  double tinhTongSoLuongHangNhap(List<ChiTietPhieuNhapModel>? listChiTiet) {
    double kq = 0.0;
    if (listChiTiet != null && listChiTiet.isNotEmpty) {
      for (var item in listChiTiet) {
        kq += item.soLuong ?? 0.0;
      }
    }
    return kq;
  }

  double tinhTongHangNhapTuListPhieuNhap(List<PhieuNhapModel>? listPhieuNhap) {
    double kq = 0.0;
    if (listPhieuNhap != null && listPhieuNhap.isNotEmpty) {
      for (var item in listPhieuNhap) {
        kq += tinhTongSoLuongHangNhap(item.chiTietPhieuNhap ?? null);
      }
    }
    return kq;
  }

  double tinhTongTienNhapHang(List<PhieuNhapModel>? list) {
    double kq = 0.0;
    if (list != null && list.isNotEmpty) {
      for (var item in list) {
        kq += item.tongTien ?? 0.0;
      }
    }
    return kq;
  }

  Future<void> getlistPhieuNhap(
      {String? thongTinHangHoa,
      String? thongTinNhaCungCap,
      String? thongTinLoHang,
      String? trangThai,
      String? ngayBatDau,
      String? ngayKetThuc,
      String? thongTinPhieuNhap,
      String? maCuaHang,
      String? maNhanVien}) async {
    loading.value = true;
    print(ngayBatDau);
    print(ngayKetThuc);

    Response res = await PhieuNhapService().findAll(
        thongTinHangHoa: thongTinHangHoa,
        thongTinNhaCungCap: thongTinNhaCungCap,
        thongTinLoHang: thongTinNhaCungCap,
        trangThai: trangThai,
        ngayBatDau: ngayBatDau,
        ngayKetThuc: ngayKetThuc,
        thongTinPhieuNhap: thongTinPhieuNhap,
        maCuaHang: maCuaHang,
        maNhanVien: maNhanVien);
    if (res.statusCode == 200) {
      // In ra body của response
      List<dynamic> jsonList;
      if (res.body is List) {
        jsonList = res.body;
      } else {
        jsonList = jsonDecode(res.body);
      }
      print(jsonList);

      // Chuyển đổi JSON list thành list of PhieuNhapModel
      listPhieuNhap.value = await jsonList
          .map((json) => PhieuNhapModel.fromJson(json))
          .toList()
          .cast<PhieuNhapModel>();
      update();
      loading.value = false;
      // Bạn có thể sử dụng listPhieuNhap ở đây
    } else {
      loading.value = false;
      // Hiển thị dialog lỗi
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
    }
  }

  Future<void> delete(PhieuNhapModel phieuNhap) async {
    if (phieuNhap.trangThai == 'Đã nhập hàng' ||
        phieuNhap.trangThai == 'Đã huỷ') {
      Response res =
          await PhieuNhapService().deleteOne(id: phieuNhap.maPhieuNhap!);
      if (res.statusCode == 200) {
        listPhieuNhap.remove(phieuNhap);

        GetShowSnackBar.successSnackBar('${phieuNhap.maPhieuNhap} đã được xóa');
        update();
      } else {
        getlistPhieuNhap();
        GetShowSnackBar.errorSnackBar((res.body != null &&
                res.body['message'] != null)
            ? res.body['message']
            : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
      }
    } else {
      GetShowSnackBar.errorSnackBar('Bạn chỉ có thể xoá những phiếu tạm');
    }
  }

  int findIndexById(String maPhieuNhap) {
    //  print(id);
    return listPhieuNhap
        .indexWhere((element) => element.maPhieuNhap == maPhieuNhap);
  }

  Future<void> huyPhieu(PhieuNhapModel phieuNhap) async {
    if (phieuNhap.trangThai == 'Đã nhập hàng') {
    } else {
      GetShowSnackBar.errorSnackBar('Trạng thái không hợp lệ');
    }
  }
}
