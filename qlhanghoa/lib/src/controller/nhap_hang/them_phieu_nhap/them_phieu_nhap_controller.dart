import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/giao_dich_model.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/lo_hang.model.dart';
import 'package:qlhanghoa/src/model/nha_cung_cap_model.dart';
import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/ton_kho_model.dart';
import 'package:qlhanghoa/src/service/chi_tiet_phieu_nhap_service.dart';
import 'package:qlhanghoa/src/service/giao_dich_service.dart';
import 'package:qlhanghoa/src/service/hang_hoa_service.dart';
import 'package:qlhanghoa/src/service/phieu_nhap_service.dart';
import 'package:qlhanghoa/src/service/ton_kho.service.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';

class ThemPhieuNhapController extends GetxController {
  // data hiển thị, thêm phiếu nhập
  var phieuNhap = PhieuNhapModel().obs;

  var chiTiet = ChiTietPhieuNhapModel().obs;
  TextEditingController giaGiamController = TextEditingController();
  TextEditingController daTraNCCController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxList<ChiTietPhieuNhapModel> listChiTietPhieuNhap =
      <ChiTietPhieuNhapModel>[].obs; // lưu list chi tiết để nữa thêm nào data
  RxBool loading = false.obs;

  // widget thể hiện phân cấp theo từng hàng hoá, hàng hoá -> các lô hoặc số lượng được thêm, 1 hàng hoá coá nhiều lô được thêm vào trong 1 list chi tiết
  @override
  void onInit() {
    super.onInit();
    reSetData();
  }

  void reSetData() {
    phieuNhap.value = PhieuNhapModel();
    chiTiet.value = ChiTietPhieuNhapModel();
    giaGiamController.text = phieuNhap.value.giaGiam != null
        ? FunctionHelper.formNum(phieuNhap.value.giaGiam)
        : '0';
    daTraNCCController.text = '0';
    listChiTietPhieuNhap.clear();
    update();
  }

  void reSetChiTiet() {
    chiTiet.value = ChiTietPhieuNhapModel();
    giaGiamController.text = '0';
    daTraNCCController.text = '0';
    update();
  }

// get phiếu tạm

  List<ChiTietPhieuNhapModel>? findListChiTietTheoHangHoa(String maHangHoa) {
    return listChiTietPhieuNhap
        .where((p0) => p0.maHangHoa == maHangHoa)
        .toList();
  }

  void chonNhaCungCap(NhaCungCapModel nhaCungCap) {
    phieuNhap.value.maNhaCungCap = nhaCungCap.maNhaCungCap;
    phieuNhap.value.nhaCungCap ??= NhaCungCapModel();
    phieuNhap.value.nhaCungCap!.tenNhaCungCap = nhaCungCap.tenNhaCungCap;
    // ignore: prefer_interpolation_to_compose_strings
    print('thay đổi nhà cung cấp ' + phieuNhap.value.maNhaCungCap.toString());
    update();
  }

  Future<void> chonLoaiHang(String idLoaiHang) async {
    print('gọi chọn loại hàng');
    print(idLoaiHang);
    HangHoaController hangHoaController = Get.find();
    if (hangHoaController.listHangHoa.isEmpty) {
      await hangHoaController.getlistHangHoa();
    }
    for (var hangHoa in hangHoaController.listHangHoa) {
      // print(hangHoa.loaiHang);
      if (hangHoa.loaiHang != null && hangHoa.loaiHang!.sId == idLoaiHang) {
        print('thêm vào');
        int index = listChiTietPhieuNhap
            .indexWhere((element) => element.maHangHoa == hangHoa.maHangHoa);
        if (index < 0) {
          ChiTietPhieuNhapModel chiTiet = ChiTietPhieuNhapModel(
              maHangHoa: hangHoa.maHangHoa,
              soLuong: 0,
              giaGiam: 0,
              loNhap: [],
              donGiaNhap: hangHoa.giaVon,
              hangHoa: HangHoaModel(
                  maHangHoa: hangHoa.maHangHoa,
                  giaVon: hangHoa.giaVon,
                  tenHangHoa: hangHoa.tenHangHoa,
                  donGiaBan: hangHoa.donGiaBan,
                  donViTinh: hangHoa.donViTinh,
                  hinhAnh: hangHoa.hinhAnh,
                  quanLyTheoLo: hangHoa.quanLyTheoLo));
          listChiTietPhieuNhap.add(chiTiet);
          update();
        }
      }
    }
    phieuNhap.value.tongTien = tinhTongTien();
    print(listChiTietPhieuNhap);
    update();
  }

  void upDateGiaBan(String maHangHoa, int giaBan) {
    int index = listChiTietPhieuNhap
        .indexWhere((element) => element.maHangHoa == maHangHoa);
    if (index >= 0) {
      print('gọi update giá bán');
      listChiTietPhieuNhap[index].hangHoa!.donGiaBan = giaBan;
      update();
    }
  }

  void deleteHangHoa(String maHangHoa) {
    int index = listChiTietPhieuNhap
        .indexWhere((element) => element.maHangHoa == maHangHoa);
    if (index >= 0) {
      listChiTietPhieuNhap.removeAt(index);
      phieuNhap.value.tongTien = tinhTongTien();
      update();
    }
  }

  void deleteLoHang({required String soLo, required String? maHangHoa}) {
    int index = listChiTietPhieuNhap
        .indexWhere((element) => element.maHangHoa == maHangHoa);
    if (index >= 0) {
      if (listChiTietPhieuNhap[index].loNhap != null) {
        index = listChiTietPhieuNhap[index]
            .loNhap!
            .indexWhere((element) => element.soLo == soLo);
        if (index >= 0) {
          listChiTietPhieuNhap[index].loNhap!.removeAt(index);
          listChiTietPhieuNhap[index].soLuong =
              tinhTongSoLuongTungHangHoa(listChiTietPhieuNhap[index]);
          update();
        }
      }
      phieuNhap.value.tongTien = tinhTongTien();
      update();
    }
  }

  void addHangHoa(HangHoaModel hangHoa) {
    // ignore: unused_local_variable
    ChiTietPhieuNhapModel chiTietPhieuNhapModel = ChiTietPhieuNhapModel(
        maHangHoa: hangHoa.maHangHoa,
        soLuong: 0,
        giaGiam: 0,
        loNhap: [],
        donGiaNhap: hangHoa.giaVon,
        hangHoa: HangHoaModel(
          maHangHoa: hangHoa.maHangHoa,
          tenHangHoa: hangHoa.tenHangHoa,
          donGiaBan: hangHoa.donGiaBan,
          giaVon: hangHoa.giaVon,
          loHang: hangHoa.loHang,
          quanLyTheoLo: hangHoa.quanLyTheoLo,
          hinhAnh: hangHoa.hinhAnh,
          donViTinh: hangHoa.donViTinh,
        ));
    print('gọi add hàng hoá');
    listChiTietPhieuNhap.add(chiTietPhieuNhapModel);
    phieuNhap.value.tongTien = tinhTongTien();
    update();
  }

  void addChiTietPhieuNhap(
      {required ChiTietPhieuNhapModel chiTiet, required int index}) {
    if (index >= 0) {
      // gọi update
      ChiTietPhieuNhapModel chiTietPhieuNhapModel =
          listChiTietPhieuNhap[index].copyWith(
        loNhap: [],
        ghiChu: chiTiet.ghiChu,
        giaGiam: chiTiet.giaGiam,
        donGiaNhap: chiTiet.donGiaNhap ?? chiTiet.hangHoa!.giaVon,
        soLuong: chiTiet.soLuong,
      );

      chiTietPhieuNhapModel.hangHoa = chiTietPhieuNhapModel.hangHoa!.copyWith(
        donGiaBan: chiTiet.hangHoa!.donGiaBan,
        giaVon: chiTiet.hangHoa!.giaVon,
        donViTinh: chiTiet.hangHoa!.donViTinh,
      );
      if (chiTiet.loNhap != null && chiTiet.loNhap!.isNotEmpty) {
        for (var lo in chiTiet.loNhap!) {
          chiTietPhieuNhapModel.loNhap!.add(lo);
        }
      }

      print(phieuNhap.value.tongTien);
      listChiTietPhieuNhap[index] = chiTietPhieuNhapModel;
      phieuNhap.value.tongTien = tinhTongTien();
      update();
    } else {
      listChiTietPhieuNhap.add(chiTiet);

      phieuNhap.value.tongTien = tinhTongTien();
      update();
    }
  }

  // ignore: unused_element
  void _showErrorDialog(String message) {
    Get.dialog(
      ErrorDialog(
        callback: () {},
        message: message,
      ),
      barrierDismissible: false,
    );
  }

  int tinhTongTien({bool? truTongGiam}) {
    int kq = 0;
    for (var chiTiet in listChiTietPhieuNhap) {
      kq = (chiTiet.donGiaNhap! * chiTiet.soLuong! - (chiTiet.giaGiam ?? 0))
              .toInt() +
          kq;
    }
    if (truTongGiam == true) {
      kq = kq - (phieuNhap.value.giaGiam ?? 0);
    }
    return kq;
  }

  double tinhTongSoLuongTungHangHoa(
      ChiTietPhieuNhapModel chiTietPhieuNhapModel) {
    double kq = 0.0;
    // ignore: prefer_conditional_assignment
    if (chiTietPhieuNhapModel.loNhap == null) chiTietPhieuNhapModel.loNhap = [];
    // ignore: unused_local_variable
    for (var chitiet in chiTietPhieuNhapModel.loNhap!) {
      kq += chitiet.soLuongNhap ?? 0.0;
    }
    return kq;
  }

  double tinhTongSoLuong() {
    double kq = 0.0;
    // ignore: prefer_conditional_assignment

    // ignore: unused_local_variable
    for (var chitiet in listChiTietPhieuNhap) {
      kq += chitiet.soLuong ?? 0.0;
    }
    return kq;
  }

  int getIndexHangHoaTrongChiTiet(String maHangHoa) {
    return listChiTietPhieuNhap
        .indexWhere((element) => element.maHangHoa == maHangHoa);
  }

  void changeGiaGiam(String giaGiam) {
    var va = giaGiam.toString().replaceAll(',', '');
    phieuNhap.value.giaGiam = int.parse(va);
    update();
  }

  void changeDaTraNhaCungCap(String traNCC) {
    var va = traNCC.toString().replaceAll(',', '');
    phieuNhap.value.daTraNCC = int.parse(va);
    update();
  }

  // xử lý với service
  Future<bool> updatePhieuTam({required bool phieuTam}) async {
    loading.value = true;
    if (phieuTam != true) {
      final state = formKey.currentState;

      if (state == null || !state.validate()) {
        loading.value = false;
        return false;
      }

      state.save(); // save giá giảm nhà cung cấp
    }
    // qua bắt lỗi dữ liệu
    print('gọi mã cửa hàng');
    String? maCuaHang = AuthUtil.getMaCuaHang();
    String? maNhanVien = AuthUtil.getUserName();
    // ignore: avoid_print
    print(maCuaHang);
    // ignore: avoid_print
    print(maNhanVien);

    phieuNhap.value.maCuaHang = maCuaHang;
    phieuNhap.value.maNhanVien = maNhanVien;
    if (phieuTam == true) {
      // tiếp tuc lưu với tạm
      phieuNhap.value.trangThai = 'Phiếu tạm';
    }
    if (phieuTam != true) {
      phieuNhap.value.trangThai = 'Đã nhập hàng';
    }
    // tính lại tổng tiền
    phieuNhap.value.tongTien = tinhTongTien(truTongGiam: true);
    phieuNhap.value.ngayLapPhieu =
        FunctionHelper.getStringUTCFromDateVN(DateTime.now());
    //1. save phiếu nhập lấy mã phiếu
    // ignore: unused_local_variable
    Response res = await PhieuNhapService()
        .update(id: phieuNhap.value.maPhieuNhap!, phieuNhap: phieuNhap.value);

    bool ktr = checkResponGetConnect(res);
    if (!ktr) {
      loading.value = false;
      return false;
    }
    // delete chi tiết với mã phiếu
    Response res2 = await ChiTietPhieuNhapService()
        .deleteMany(maPhieuNhap: phieuNhap.value.maPhieuNhap!);

    ktr = checkResponGetConnect(res2);
    if (!ktr) {
      loading.value = false;
      return false;
    }
    //3. save chi tiết phiếu với mã phiếu vừa lấy được
    ktr = await updateCreateCacChiTiet(
        maCuaHang: phieuNhap.value.maCuaHang!,
        phieuTam: phieuTam,
        maPhieu: phieuNhap.value.maPhieuNhap!);

    if (!ktr) {
      loading.value = false;
      return false;
    }
    PhieuNhapController phieuNhapController = Get.find();
    if (FunctionHelper.soSanhTwoStringUTCWithToDay(
            phieuNhapController.ngayBatDau.value.toString(),
            phieuNhapController.ngayKetThuc.value.toString()) ==
        true) {
      // ignore: unnecessary_null_comparison
      if (phieuNhapController.listPhieuNhap != null) {
        int ind = phieuNhapController.listPhieuNhap.indexWhere(
            (element) => element.maPhieuNhap == phieuNhap.value.maPhieuNhap);
        if (ind >= 0) {
          phieuNhapController.listPhieuNhap[ind] = phieuNhap.value;
        } else {
          if (phieuNhap.value.trangThai == 'Đã nhập hàng') {
            phieuNhapController.listPhieuNhap.add(phieuNhap.value);
          }
        }
        phieuNhapController.sortListByNgayLapPhieu();
      }
    }
    loading.value = false;
    return true;

    //cuoi. kiểm tra xem ngày bắt đầu, kết thúc của phieunhapController có phải hôm nay hay không, nếu phải thì add nó vào
  }

  Future<bool> create({required bool phieuTam}) async {
    loading.value = true;

    if (phieuTam != true) {
      final state = formKey.currentState;

      if (state == null || !state.validate()) {
        loading.value = false;
        return false;
      }

      state.save(); // save giá giảm nhà cung cấp
    } // Save giá giảm nhà cung cấp
    print('Gọi mã cửa hàng');

    String? maCuaHang = AuthUtil.getMaCuaHang();
    String? maNhanVien = AuthUtil.getUserName();
    print(maCuaHang);
    print(maNhanVien);

    phieuNhap.value.maCuaHang = maCuaHang;
    phieuNhap.value.maNhanVien = maNhanVien;
    phieuNhap.value.ngayLapPhieu =
        FunctionHelper.getStringUTCFromDateVN(DateTime.now());

    if (phieuTam) {
      phieuNhap.value.trangThai = 'Phiếu tạm';
    } else {
      phieuNhap.value.trangThai = 'Đã nhập hàng';
    }

    phieuNhap.value.tongTien = tinhTongTien(truTongGiam: true);

    Response res = await PhieuNhapService().create(phieuNhap.value);
    bool ktr = checkResponGetConnect(res);

    if (!ktr) {
      loading.value = false;
      return false;
    }

    String maPhieu = res.body;
    phieuNhap.value.maPhieuNhap = maPhieu;

    bool updateResult = await updateCreateCacChiTiet(
        maCuaHang: maCuaHang!, phieuTam: phieuTam, maPhieu: maPhieu);

    if (!updateResult) {
      loading.value = false;
      return false;
    }

    PhieuNhapController phieuNhapController = Get.find();

    if (FunctionHelper.soSanhTwoStringUTCWithToDay(
            phieuNhapController.ngayBatDau.value,
            phieuNhapController.ngayKetThuc.value) ==
        true) {
      phieuNhap.value.chiTietPhieuNhap = listChiTietPhieuNhap;
      //  phieuNhapController.listPhieuNhap.add(phieuNhap.value);
      // ignore: unnecessary_null_comparison
      if (phieuNhapController.listPhieuNhap != null) {
        int ind = phieuNhapController.listPhieuNhap.indexWhere(
            (element) => element.maPhieuNhap == phieuNhap.value.maPhieuNhap);
        if (ind >= 0) {
          phieuNhapController.listPhieuNhap[ind] = phieuNhap.value;
        } else {
          if (phieuNhap.value.trangThai != 'Phiếu tạm') {
            phieuNhapController.listPhieuNhap.add(phieuNhap.value);
          }
        }
        phieuNhapController.sortListByNgayLapPhieu();
      }
    }

    loading.value = false;

    return true;
  }

  bool checkResponGetConnect(Response res) {
    if (res.statusCode == 200) {
      return true;
    } else {
      loading.value = false;
      Get.dialog(
          ErrorDialog(
            callback: () {},
            message: (res.body != null && res.body['message'] != null)
                ? res.body['message']
                : "Lỗi trong quá trình xử lý",
          ),
          // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
          barrierDismissible: false);
      return false;
    }
  }

  Future<bool> updateCreateCacChiTiet(
      {required String maPhieu,
      required String maCuaHang,
      required bool phieuTam}) async {
    print('Gọi update chi tiết');
    print(listChiTietPhieuNhap);

    // ignore: unnecessary_null_comparison
    if (listChiTietPhieuNhap == null || listChiTietPhieuNhap.isEmpty) {
      return true;
    }

    for (var chiTiet in listChiTietPhieuNhap) {
      print('Duyệt qua chi tiết');

      if (chiTiet.soLuong != null && chiTiet.soLuong! > 0) {
        print(chiTiet.soLuong!);

        if (chiTiet.hangHoa!.quanLyTheoLo != true) {
          print('Không quản lý theo lô');
          chiTiet.loNhap = [
            LoHangModel(
                maHangHoa: chiTiet.maHangHoa,
                soLo: 'L1',
                soLuongNhap: chiTiet.soLuong)
          ];
        }

        chiTiet.maPhieuNhap = maPhieu;

        Response res2 = await ChiTietPhieuNhapService().create(chiTiet);
        print('Thêm chi tiết');

        bool ktr = checkResponGetConnect(res2);
        if (!ktr) {
          return false;
        }

        if (!phieuTam) {
          if (chiTiet.loNhap == null || chiTiet.loNhap!.isEmpty) {
            return true;
          }

          for (var lo in chiTiet.loNhap!) {
            print('Duyệt qua từng lô nhập');
            print(lo.soLo);

            ktr = await _updateTonKho(
                lo: lo, maCuaHang: maCuaHang, chiTiet: chiTiet);
            if (!ktr) {
              return false;
            }
            ktr = await _updateHangHoa(
                maCuaHang: maCuaHang, chiTiet: chiTiet, maPhieu: maPhieu);
            if (!ktr) {
              return false;
            }
          }
        }
      }
    }

    return true;
  }

  Future<bool> _updateTonKho(
      {required LoHangModel lo,
      required String maCuaHang,
      required ChiTietPhieuNhapModel chiTiet}) async {
    // ignore: unnecessary_null_comparison
    if (!(lo.soLo != null && maCuaHang != null && chiTiet.maHangHoa != null)) {
      return true;
    }

    TonKhoModel tonKhoModel = TonKhoModel(
        soLo: lo.soLo,
        hanSuDung: lo.hanSuDung,
        maCuaHang: maCuaHang,
        maHangHoa: chiTiet.maHangHoa,
        soLuongTon: lo.soLuongNhap);

    Response res3 = await TonKhoService().themSoLuongTonKho(
        soLo: lo.soLo!,
        maCuaHang: maCuaHang,
        maHangHoa: chiTiet.maHangHoa!,
        tonkho: tonKhoModel);
    print('Gọi thêm tồn kho');

    bool ktr = checkResponGetConnect(res3);
    if (!ktr) {
      return false;
    }

    LoHangModel loHangModel = LoHangModel.fromJson(res3.body);
    HangHoaController hangHoaController = Get.find();
    int index = hangHoaController.listHangHoa
        .indexWhere((element) => element.maHangHoa == chiTiet.maHangHoa);
    if (chiTiet.hangHoa!.loHang == null) {
      chiTiet.hangHoa!.loHang = [];
      if (index >= 0) {
        chiTiet.hangHoa!.loHang = hangHoaController.listHangHoa[index].loHang!;
      }
    }

    int indexLoHang = chiTiet.hangHoa!.loHang!
        .indexWhere((element) => element.soLo == lo.soLo);
    if (indexLoHang >= 0) {
      chiTiet.hangHoa!.loHang![indexLoHang] = loHangModel;
    } else {
      chiTiet.hangHoa!.loHang!.add(loHangModel);
    }
    return true;
  }

  Future<bool> _updateHangHoa(
      {required String maCuaHang,
      required ChiTietPhieuNhapModel chiTiet,
      required String maPhieu}) async {
    HangHoaController hangHoaController = Get.find();
    int index = hangHoaController.listHangHoa
        .indexWhere((element) => element.maHangHoa == chiTiet.maHangHoa);

    if (index >= 0) {
      print('Cập nhật lại thông tin hàng hóa');
      print(chiTiet.donGiaNhap);
      hangHoaController.listHangHoa[index] =
          hangHoaController.listHangHoa[index].copyWith(
              loHang: chiTiet.hangHoa!.loHang, giaVon: chiTiet.donGiaNhap);
    }

    double tonKho = hangHoaController.tongsoLuongTonKhoTrongListLoHang(
        hangHoa: chiTiet.hangHoa!, cuaHang: maCuaHang);

    GiaoDichModel giaoDichModel = GiaoDichModel(
        loaiGiaoDich: 'Nhập hàng',
        soLuongGiaoDich: chiTiet.soLuong,
        soLuongTon: tonKho,
        giaVon: chiTiet.donGiaNhap,
        maHangHoa: chiTiet.maHangHoa,
        maCuaHang: maCuaHang,
        maNhanVien: phieuNhap.value.maNhanVien,
        maPhieuNhap: maPhieu);

    Response res5 = await GiaoDichService().create(giaoDichModel);
    print('Gọi thêm giao dịch');

    bool ktr = checkResponGetConnect(res5);
    if (!ktr) {
      return false;
    }

    HangHoaModel hang = chiTiet.hangHoa!.copyWith(giaVon: chiTiet.donGiaNhap);

    Response res4 =
        await HangHoaService().update(id: chiTiet.maHangHoa!, hangHoa: hang);
    print('Update lại trong database');

    ktr = checkResponGetConnect(res4);
    if (!ktr) {
      return false;
    }
    return true;
  }

  Future<bool> getPhieuTamGanDay() async {
    String? maCuaHang = AuthUtil.getMaCuaHang();
    Response res =
        await PhieuNhapService().getPhieuTamGanDay(maCuaHang: maCuaHang);
    bool ktr = checkResponGetConnect(res);
    if (!ktr) {
      return false;
    }
    List<dynamic> jsonList;
    if (res.body is List) {
      jsonList = res.body;
    } else {
      jsonList = jsonDecode(res.body);
    }
    print(jsonList);

    // Chuyển đổi JSON list thành list of PhieuNhapModel
    if (jsonList.isEmpty) {
      return false;
    }
    phieuNhap.value = PhieuNhapModel.fromJson(jsonList[0]);
    update();
    var chiTietList = jsonList[0]['chi_tiet_phieu_nhap_info'] as List;
    // ignore: unnecessary_null_comparison
    if (chiTietList != null) {
      print('list chi tiết');
      listChiTietPhieuNhap.value = chiTietList
          .map((json) => ChiTietPhieuNhapModel.fromJson(json))
          .toList()
          .cast<ChiTietPhieuNhapModel>();
    } else {
      listChiTietPhieuNhap.clear();
    }
    update();
    return true;
  }

  Future<bool> getOnePhieuNhap(String maPhieu) async {
    loading.value = true;

    try {
      print(maPhieu);
      Response res = await PhieuNhapService().getById(id: maPhieu);
      //  print(res.body != null);
      // print(res.statusCode);
      bool ktr = checkResponGetConnect(res);
      if (!ktr) {
        loading.value = false;
        return false;
      }
      phieuNhap.value = PhieuNhapModel.fromJson(res.body);
      update();
      var chiTietList = res.body['chi_tiet_phieu_nhap_info'] as List;
      // ignore: unnecessary_null_comparison
      if (chiTietList != null) {
        print('list chi tiết');
        listChiTietPhieuNhap.value = chiTietList
            .map((json) => ChiTietPhieuNhapModel.fromJson(json))
            .toList()
            .cast<ChiTietPhieuNhapModel>();
      } else {
        listChiTietPhieuNhap.clear();
      }

      update();
      loading.value = false;
      return true;
    } catch (e) {
      loading.value = false;
      return false;
    }
  }
}
