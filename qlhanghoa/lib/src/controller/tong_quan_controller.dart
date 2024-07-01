import 'dart:convert';

import 'package:get/get.dart';

import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/ton_kho_model.dart';
import 'package:qlhanghoa/src/service/phieu_nhap_service.dart';
import 'package:qlhanghoa/src/service/ton_kho.service.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class TongQuanController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa

  // list lấy từ service
  RxList<PhieuNhapModel> listPhieuNhap = <PhieuNhapModel>[].obs;
  RxList<TonKhoModel> listLoHangDenHan = <TonKhoModel>[].obs;
  RxDouble tongTonKho = 0.0.obs;
  RxString soNgay = '30'.obs;

  RxString ngayBatDau = ''.obs;
  RxString ngayKetThuc = ''.obs;

  RxBool loading = false.obs;
  RxString maCuaHang = 'Tất cả'.obs; // cho chọn select

  @override
  void onInit() async {
    super.onInit();
    setNgayMaDinhToDay();
    reSetUpData();
    print('gọi int');
    await setUpData();
  }

  Future<void> setUpData() async {
    maCuaHang.value = AuthUtil.getMaCuaHang() ?? 'Tất cả';
    await getlistPhieuNhap(
        ngayBatDau: ngayBatDau.value,
        ngayKetThuc: ngayKetThuc.value,
        trangThai: 'Đã nhập hàng',
        maCuaHang: maCuaHang.value);
    await getListLoSapDenHan();
    await getTongTonKho();
  }

  void setNgayMaDinhToDay() async {
    DateTime now = DateTime.now().toUtc();
    ngayBatDau.value =
        DateTime(now.year, now.month, now.day).toUtc().toIso8601String();
    ngayKetThuc.value = DateTime(now.year, now.month, now.day, 23, 59, 59)
        .toUtc()
        .toIso8601String();
  }

  void reSetUpData() {
    setNgayMaDinhToDay();
    maCuaHang.value = AuthUtil.getMaCuaHang() ?? 'Tất cả';
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

  double tinhTongSoLuongHangNhapTrongListPhieuNhap(
      List<PhieuNhapModel>? listPhieuNhap) {
    double kq = 0.0;
    if (listPhieuNhap != null && listPhieuNhap.isNotEmpty) {
      for (var item in listPhieuNhap) {
        // ignore: unnecessary_null_in_if_null_operators
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

  int tongMatHangNhap(List<PhieuNhapModel>? listPhieuNhap) {
    int kq = 0;

    if (listPhieuNhap != null && listPhieuNhap.isNotEmpty) {
      for (var item in listPhieuNhap) {
        kq += item.chiTietPhieuNhap != null ? item.chiTietPhieuNhap!.length : 0;
      }
    }
    return kq;
  }

// get data base nhập hàng
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

    Response res = await PhieuNhapService().findTongQuan(
      trangThai: trangThai,
      ngayBatDau: ngayBatDau,
      ngayKetThuc: ngayKetThuc,
      maCuaHang: maCuaHang,
    );
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
      // ignore: await_only_futures
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

  // lấy tổng tồn kho tồn kho
  Future<bool> getTongTonKho({String? maCH}) async {
    Response res = await TonKhoService()
        .findTongTonKho(maCuaHang: maCH ?? maCuaHang.value);
    // ignore: unnecessary_null_comparison
    if (res.statusCode != 200 || res == null) {
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
      return false;
    }
    List<dynamic> jsonList;
    if (res.body is List) {
      jsonList = res.body;
    } else {
      jsonList = jsonDecode(res.body);
    }
    // ignore: prefer_is_empty
    tongTonKho.value = jsonList.length > 0
        ? double.parse(jsonList[0]['so_luong'].toString())
        : 0.0;
    update();
    return true;
  }

  // tới tồn kho lô hàng
  Future<void> getListLoSapDenHan({
    String? songay,
    String? maCH,
  }) async {
    loading.value = true;
    print(ngayBatDau);
    print(ngayKetThuc);

    Response res = await TonKhoService().findAll(
        maCuaHang: maCH ?? maCuaHang.value, soNgay: songay ?? soNgay.value);
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
      // ignore: await_only_futures
      listLoHangDenHan.value = await jsonList
          .map((json) => TonKhoModel.fromJson(json))
          .toList()
          .cast<TonKhoModel>();
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

  double tongSanPhamTrongDenHan() {
    double kq = 0.0;
    if (listLoHangDenHan.length > 0) {
      for (var ton in listLoHangDenHan) {
        kq += ton.soLuongTon ?? 0.0;
      }
    }

    return kq;
  }
}
