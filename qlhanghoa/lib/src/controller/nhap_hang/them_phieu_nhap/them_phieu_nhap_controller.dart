import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';

class ThemPhieuNhapController extends GetxController {
  // data hiển thị, thêm phiếu nhập
  var phieuNhap = PhieuNhapModel().obs;

  var chiTiet = ChiTietPhieuNhapModel().obs;
  TextEditingController giaGiamController = TextEditingController();
  TextEditingController daTraNCCController = TextEditingController();

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

  void chonNhaCungCap(String maNhaCungCap) {
    phieuNhap.value.maNhaCungCap = maNhaCungCap;
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
}
