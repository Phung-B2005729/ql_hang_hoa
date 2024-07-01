import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/them_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/lo_hang.model.dart';

class NhapLoController extends GetxController {
  var chiTietPhieuNhap = ChiTietPhieuNhapModel(hangHoa: HangHoaModel())
      .obs; // lưu list chi tiết để nữa thêm nào data

  RxBool loading = false.obs;
  RxInt index = (-1).obs;

  var loHangModel = LoHangModel().obs;

  // Danh sách các TextEditingController
  List<TextEditingController> textEditingControllers = [];
  //
  TextEditingController donGiaController = TextEditingController();
  TextEditingController giaGiamController = TextEditingController();
  //
  TextEditingController soLuongNhapController = TextEditingController();
  TextEditingController ghiChuController = TextEditingController();

  // TextController cho thêm lô hàng
  final formKey = GlobalKey<FormState>();
  TextEditingController hanSuDungControler = TextEditingController();
  TextEditingController soLoController = TextEditingController();
  TextEditingController soLuongController = TextEditingController();

  RxList<LoHangModel> filteredList = <LoHangModel>[].obs;
  RxBool chonLo = false.obs;
  // không cho giá giảm

  // widget thể hiện phân cấp theo từng hàng hoá, hàng hoá -> các lô hoặc số lượng được thêm, 1 hàng hoá coá nhiều lô được thêm vào trong 1 list chi tiết

  @override
  void onInit() {
    super.onInit();
    reSetData();
    reSetDataThemLo();
    soLoController.addListener(() {
      if (soLoController.text.isEmpty) {
        filteredList.value = [];
        update();
      } else {
        // gọi hàm lộc fiter
        filterListLoHang(soLoController.text);
      }
    });
  }

  void reSetData() {
    chiTietPhieuNhap.value = ChiTietPhieuNhapModel(
        hangHoa: HangHoaModel(), loNhap: [], soLuong: 0, donGiaNhap: 0);
    ghiChuController.text = '';
    donGiaController.text = '0';
    giaGiamController.text = '0';
    soLuongNhapController.text = '0';
    textEditingControllers = [];
    index.value = -1;
    loHangModel.value = LoHangModel();

    update();
  }

  void setUpData(
      {required ChiTietPhieuNhapModel chiTiet,
      required HangHoaModel hangHoa,
      required int indext}) {
    print('gọi get update');
    index.value = indext;
    ChiTietPhieuNhapModel chiTietPhieuNhapModel = ChiTietPhieuNhapModel(
      maHangHoa: chiTiet.maHangHoa ?? hangHoa.maHangHoa,
      sId: chiTiet.sId,
      loNhap: [],
      ghiChu: chiTiet.ghiChu,
      giaGiam: chiTiet.giaGiam,
      donGiaNhap: chiTiet.donGiaNhap ?? hangHoa.giaVon,
      soLuong: chiTiet.soLuong,
      hangHoa: HangHoaModel(
        maHangHoa: hangHoa.maHangHoa,
        tenHangHoa: hangHoa.tenHangHoa,
        donGiaBan: hangHoa.donGiaBan,
        giaVon: chiTiet.donGiaNhap ?? hangHoa.giaVon,
        loHang: hangHoa.loHang,
        quanLyTheoLo: hangHoa.quanLyTheoLo,
        hinhAnh: hangHoa.hinhAnh,
        donViTinh: hangHoa.donViTinh,
      ),
    );
    if (chiTiet.loNhap != null && chiTiet.loNhap!.isNotEmpty) {
      for (var lo in chiTiet.loNhap!) {
        chiTietPhieuNhapModel.loNhap!.add(lo);
        textEditingControllers.add(TextEditingController(
            text: lo.soLuongNhap != null ? lo.soLuongNhap.toString() : '0'));
      }
    }
    chiTietPhieuNhap.value = chiTietPhieuNhapModel;
    ghiChuController.text = chiTietPhieuNhapModel.ghiChu ?? '';
    donGiaController.text = chiTietPhieuNhapModel.donGiaNhap != null
        ? FunctionHelper.formNum(chiTietPhieuNhapModel.donGiaNhap.toString())
        : '0';
    giaGiamController.text = chiTietPhieuNhapModel.giaGiam != null
        ? FunctionHelper.formNum(chiTietPhieuNhapModel.giaGiam.toString())
        : '0';
    soLuongNhapController.text = chiTietPhieuNhapModel.soLuong != null
        ? FunctionHelper.formNum(chiTietPhieuNhapModel.soLuong.toString())
        : '0';
    update();
  }

  void changeGiaVon(String giaVon) {
    var va = giaVon.toString().replaceAll(',', '');
    chiTietPhieuNhap.value.hangHoa!.giaVon = int.parse(va);
    chiTietPhieuNhap.value.donGiaNhap = int.parse(va);
    // ignore: avoid_print
    print('gọi change ${chiTietPhieuNhap.value.hangHoa!.giaVon}');

    ThemPhieuNhapController themPhieuNhapController = Get.find();
    // ignore: avoid_print
    var phieuNhap = themPhieuNhapController.listChiTietPhieuNhap.firstWhere(
        (item) => item.maHangHoa == chiTietPhieuNhap.value.hangHoa!.maHangHoa,
        orElse: () => ChiTietPhieuNhapModel(hangHoa: HangHoaModel(giaVon: 0)));
    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print('Hàng hoá bên kia ' + phieuNhap.hangHoa!.giaVon.toString());
    update();
  }

  void changeGiaGiam(String giaGiam) {
    var va = giaGiam.toString().replaceAll(',', '');
    chiTietPhieuNhap.value.giaGiam = int.parse(va);
    update();
  }

  void tangSoLuongHang() {
    chiTietPhieuNhap.value.soLuong ??= 0;
    print((chiTietPhieuNhap.value.soLuong! + 1).toString());
    chiTietPhieuNhap.value.soLuong = chiTietPhieuNhap.value.soLuong! + 1;
    soLuongNhapController.text =
        FunctionHelper.formNum(chiTietPhieuNhap.value.soLuong);
    print(soLuongNhapController.text);
    update();
  }

  void giamSoLuongHang() {
    if (chiTietPhieuNhap.value.soLuong != null &&
        chiTietPhieuNhap.value.soLuong! > 0) {
      chiTietPhieuNhap.value.soLuong = chiTietPhieuNhap.value.soLuong! - 1;
      update();
    } else {
      chiTietPhieuNhap.value.soLuong = 0;
      update();
    }
    soLuongNhapController.text =
        FunctionHelper.formNum(chiTietPhieuNhap.value.soLuong);
    update();
  }

  void tangSoLuongLoHang(int index) {
    // ignore: unnecessary_null_comparison
    if (index >= 0) {
      // ignore: unnecessary_null_comparison
      if (chiTietPhieuNhap.value.loNhap![index] != null) {
        chiTietPhieuNhap.value.loNhap![index].soLuongNhap ??= 0;

        chiTietPhieuNhap.value.loNhap![index].soLuongNhap =
            chiTietPhieuNhap.value.loNhap![index].soLuongNhap! + 1;
        // tăng trong tổng
        tangSoLuongHang();
        // ignore: unnecessary_null_comparison
        if (textEditingControllers[index] != null) {
          textEditingControllers[index] = TextEditingController(
              text: FunctionHelper.formNum(chiTietPhieuNhap.value.soLuong));
        }
        textEditingControllers[index].text =
            FunctionHelper.formNum(chiTietPhieuNhap.value.soLuong);
        print(soLuongNhapController.text);
        update();
      }
    } else {
      loHangModel.value.soLuongNhap ??= 0;
      loHangModel.value.soLuongNhap = loHangModel.value.soLuongNhap! + 1;

      soLuongController.text =
          FunctionHelper.formNum(loHangModel.value.soLuongNhap);
      update();
    }
  }

  void giamSoLuongLoHang(int index) {
    // ignore: unnecessary_null_comparison
    if (index >= 0) {
      // ignore: unnecessary_null_comparison
      if (chiTietPhieuNhap.value.loNhap![index] != null) {
        chiTietPhieuNhap.value.loNhap![index].soLuongNhap ??= 0;
        if (chiTietPhieuNhap.value.loNhap![index].soLuongNhap! > 0) {
          chiTietPhieuNhap.value.loNhap![index].soLuongNhap =
              chiTietPhieuNhap.value.loNhap![index].soLuongNhap! - 1;
          // giảm luôn trong tổng số lượng
          giamSoLuongHang();
        } else {
          chiTietPhieuNhap.value.loNhap![index].soLuongNhap = 0;
        }
        // ignore: unnecessary_null_comparison
        if (textEditingControllers[index] != null) {
          textEditingControllers[index] = TextEditingController(
              text: FunctionHelper.formNum(chiTietPhieuNhap.value.soLuong));
        }
        textEditingControllers[index].text =
            FunctionHelper.formNum(chiTietPhieuNhap.value.soLuong);
        print(soLuongNhapController.text);
        update();
      }
    } else {
      loHangModel.value.soLuongNhap ??= 0;
      if (loHangModel.value.soLuongNhap! > 0) {
        loHangModel.value.soLuongNhap = loHangModel.value.soLuongNhap! - 1;
      } else {
        loHangModel.value.soLuongNhap = 0;
      }
      soLuongController.text =
          FunctionHelper.formNum(loHangModel.value.soLuongNhap);
      update();
    }
  }

  void changeGhiChu(String ghiChu) {
    chiTietPhieuNhap.value.ghiChu = ghiChu;
    update();
  }

  void changeSoLuong(String soLuong) {
    var va = soLuong.toString().replaceAll(',', '');
    chiTietPhieuNhap.value.soLuong = double.parse(va);
    update();
  }

  void changeSoLuongLo({required int index, required String soLuong}) {
    // ignore: unused_local_variable
    var va = soLuong.toString().replaceAll(',', '');
    if (index >= 0) {
      if (chiTietPhieuNhap.value.loNhap != null &&
          // ignore: unnecessary_null_comparison
          chiTietPhieuNhap.value.loNhap![index] != null) {
        if (index >= 0) {
          chiTietPhieuNhap.value.loNhap![index].soLuongNhap = double.parse(va);
          // update lại tổng số lượng nhập
          chiTietPhieuNhap.value.soLuong = tongSoLuongNhap();
          update();
        }
        // ignore: prefer_is_empty
      }
    }
    if (index < 0) {
      loHangModel.value.soLuongNhap = double.parse(va);
      update();
    }
  }

  double tongTonKho() {
    double kq = 0.0;
    AuthController auth = Get.find();
    print('Cửa hàng ');
    //print(maCH);
    var maCH = auth.maCuaHang.value;
    if (chiTietPhieuNhap.value.hangHoa!.loHang != null) {
      for (var lo in chiTietPhieuNhap.value.hangHoa!.loHang!) {
        if (lo.tonKho != null) {
          for (var tonKhoItem in lo.tonKho!) {
            print('mã cửa hàng');
            print(maCH);

            if (maCH != 'Tất cả' && maCH != '') {
              if (tonKhoItem.maCuaHang == maCH &&
                  tonKhoItem.soLuongTon != null) {
                // Nếu ma_cua_hang là "CN000001", cộng dồn vào tổng
                kq += tonKhoItem.soLuongTon!;
              }
            } else {
              if (tonKhoItem.soLuongTon != null) {
                kq += tonKhoItem.soLuongTon!;
              }
            }
          }
        }
      }
    }
    return kq;
  }

  double tongSoLuongNhap() {
    double kq = 0.0;
    for (var chiTiet in chiTietPhieuNhap.value.loNhap!) {
      kq += chiTiet.soLuongNhap ?? 0.0;
    }
    chiTietPhieuNhap.value.soLuong = kq;
    //update();
    return kq;
  }

  Future<void> saveChiTiet() async {
    ThemPhieuNhapController themPhieuNhapController = Get.find();
    themPhieuNhapController.addChiTietPhieuNhap(
        chiTiet: chiTietPhieuNhap.value, index: index.value);
  }

  // thêm lô

  setUpDataThemLo(LoHangModel loHang) {
    loHangModel.value = LoHangModel(
      sId: loHang.sId ?? '',
      soLo: loHang.soLo ?? '',
      maHangHoa: loHang.maHangHoa ?? '',
      ngaySanXuat: loHang.ngaySanXuat ?? '',
      ngayTaoLo: loHang.ngayTaoLo ?? '',
      tonKho: loHang.tonKho ?? [],
      soLuongNhap:
          (loHang.soLuongNhap ?? 0) + (loHangModel.value.soLuongNhap ?? 0),
      hanSuDung: loHang.hanSuDung ?? '',
      // trangThai: loHang.trangThai ?? ''
    );

    setUpControllerThemLo();

    update();
  }

  changeChonLo(bool value) {
    chonLo.value = value;
    update();
  }

  setUpControllerThemLo() {
    soLoController.text =
        loHangModel.value.soLo != null ? loHangModel.value.soLo.toString() : '';
    hanSuDungControler.text = loHangModel.value.hanSuDung.toString();
    soLuongController.text =
        FunctionHelper.formNum(loHangModel.value.soLuongNhap);
    donGiaController.text =
        FunctionHelper.formNum(chiTietPhieuNhap.value.donGiaNhap.toString());
    giaGiamController.text =
        FunctionHelper.formNum(chiTietPhieuNhap.value.giaGiam.toString());
    ghiChuController.text = '';
    update();
  }

  reSetDataThemLo({bool? reSetThemMoi}) {
    loHangModel.value = LoHangModel(
      soLuongNhap: 0,
    );
    soLoController.text = '0';
    hanSuDungControler.text = '';
    soLoController.text = '';
    if (reSetThemMoi == true) {
      ghiChuController.text = '';
      giaGiamController.text = '';
      donGiaController.text = '';
    }
    chonLo.value = false;
    update();
  }

  double tongTonKhoLoHang() {
    double kq = 0.0;
    if (loHangModel.value.tonKho != null) {
      AuthController auth = Get.find();
      print('Cửa hàng ');
      //print(maCH);
      var maCH = auth.maCuaHang.value;
      for (var tonKhoItem in loHangModel.value.tonKho!) {
        print('mã cửa hàng');

        if (maCH != 'Tất cả' && maCH != '') {
          if (tonKhoItem.maCuaHang == maCH && tonKhoItem.soLuongTon != null) {
            // Nếu ma_cua_hang là "CN000001", cộng dồn vào tổng
            kq += tonKhoItem.soLuongTon!;
          }
        } else {
          if (tonKhoItem.soLuongTon != null) {
            kq += tonKhoItem.soLuongTon!;
          }
        }
      }
    }
    return kq;
  }

  void filterListLoHang(String value) {
    // Kiểm tra null cho chiTietPhieuNhap và các thuộc tính liên quan
    // ignore: unnecessary_null_comparison
    if (chiTietPhieuNhap.value != null &&
        chiTietPhieuNhap.value.hangHoa != null &&
        chiTietPhieuNhap.value.hangHoa!.loHang != null) {
      // Lấy danh sách loHang
      List<LoHangModel> list = chiTietPhieuNhap.value.hangHoa!.loHang!;
      // Kiểm tra phần tử null trong danh sách
      filteredList.value = list
          .where((item) =>
              (item.soLo != null) &&
              item.soLo!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      // Gọi phương thức update để cập nhật trạng thái
      if (chiTietPhieuNhap.value.loNhap != null) {
        for (var chitiet in chiTietPhieuNhap.value.loNhap!) {
          int index = filteredList
              .indexWhere((element) => element.soLo == chitiet.soLo);
          if (index >= 0) {
            filteredList[index].soLuongNhap = chitiet.soLuongNhap;
            filteredList[index].hanSuDung = chitiet.hanSuDung;
          } else {
            filteredList.add(chitiet);
          }
        }
      }
      update();
    } else {
      filteredList.value = [];
    }
  }

  loaiBoSoLo() {
    loHangModel.value.soLo = '';
    loHangModel.value.ngaySanXuat = '';
    loHangModel.value.sId = '';
    loHangModel.value.ngayTaoLo = '';
    loHangModel.value.hanSuDung = '';
    soLoController.text = '';
    chonLo.value = false;
    update();
  }

  setHanSuDung(DateTime date) {
    loHangModel.value.hanSuDung = FunctionHelper.formatDatetVNtoDateVN(date);
    update();
  }

  addUpdateLoHang(LoHangModel loHang) {
    // tìm lô hàng sau đó update
    chiTietPhieuNhap.value.loNhap ??= [];

    int index = chiTietPhieuNhap.value.loNhap!
        .indexWhere((element) => element.soLo == loHang.soLo);

    if (index >= 0) {
      // gọi update
      chiTietPhieuNhap.value.loNhap![index] = LoHangModel(
        sId: loHang.sId,
        soLo: loHang.soLo,
        ngaySanXuat: loHang.ngaySanXuat,
        maHangHoa: loHang.maHangHoa,
        ngayTaoLo: loHang.ngayTaoLo,
        soLuongNhap: loHang.soLuongNhap,
        tongSoLuong: loHang.tongSoLuong,
        hanSuDung: loHang.hanSuDung,
        //  trangThai: loHang.trangThai,
        tonKho: loHang.tonKho,
      );
      textEditingControllers[index].text = loHang.soLuongNhap.toString();
    } else {
      // gọi thêm
      textEditingControllers
          .add(TextEditingController(text: loHang.soLuongNhap.toString()));
      chiTietPhieuNhap.value.loNhap!.add(loHang);
    }
    // gọi tính lại soluong trong chi tiết
    chiTietPhieuNhap.value.soLuong = tongSoLuongNhap();
    update();
  }
}
