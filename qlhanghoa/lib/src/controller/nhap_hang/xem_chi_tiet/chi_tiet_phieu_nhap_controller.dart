import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/giao_dich_model.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/lo_hang.model.dart';
import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/ton_kho_model.dart';
import 'package:qlhanghoa/src/service/chi_tiet_phieu_nhap_service.dart';
import 'package:qlhanghoa/src/service/giao_dich_service.dart';
import 'package:qlhanghoa/src/service/phieu_nhap_service.dart';
import 'package:qlhanghoa/src/service/ton_kho.service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class ChiTietPhieuNhapController extends GetxController {
  // data hiển thị, thêm phiếu nhập
  var phieuNhap = PhieuNhapModel().obs;

  var chiTiet = ChiTietPhieuNhapModel().obs;

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
    listChiTietPhieuNhap.clear();

    update();
  }

  void reSetChiTiet() {
    chiTiet.value = ChiTietPhieuNhapModel();
    update();
  }

  Future<void> getOnePhieuNhap(String maPhieu) async {
    loading.value = true;
    print('Mẫ phiếu');
    print(maPhieu);
    try {
      print(maPhieu);
      Response res = await PhieuNhapService().getById(id: maPhieu);
      print(res.body != null);
      print(res.statusCode);
      if (res.statusCode == 200 && res.body != null) {
        print(res.body);
        phieuNhap.value = PhieuNhapModel.fromJson(res.body);

        print('list chi tiết');

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
        print('list chi tiết');
        print(listChiTietPhieuNhap);
        update();
      } else {
        _showErrorDialog(res.body['message'] ?? "Lỗi trong quá trình xử lý");
      }
    } catch (e) {
      _showErrorDialog("Lỗi trong quá trình xử lý");
    } finally {
      loading.value = false;
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      ErrorDialog(
        callback: () {},
        message: message,
      ),
      barrierDismissible: false,
    );
  }

  double tongSoLuongNhapTheoHangHoa(String maHangHoa) {
    double kq = 0.0;
    for (var chitiet in listChiTietPhieuNhap) {
      if (chitiet.maHangHoa == maHangHoa) {
        kq += chitiet.soLuong ?? 0.0;
      }
    }
    return kq;
  }

  Future<bool> deletePhieuNhap() async {
    print('gọi xoá phiểu');
    loading.value = true;
    if (phieuNhap.value.maPhieuNhap != null &&
        phieuNhap.value.trangThai == 'Phiếu tạm') {
      Response res =
          await PhieuNhapService().deleteOne(id: phieuNhap.value.maPhieuNhap!);
      bool ktr = checkResponGetConnect(res);
      if (!ktr) {
        loading.value = false;
        return false;
      }
      // xoá chi tiết
      Response res2 = await ChiTietPhieuNhapService()
          .deleteMany(maPhieuNhap: phieuNhap.value.maPhieuNhap!);
      ktr = checkResponGetConnect(res2);
      if (!ktr) {
        loading.value = false;
        return false;
      }
      PhieuNhapController phieuNhapController = Get.find();
      //phieuNhapController.listPhieuNhap.value ??= [];
      int index = phieuNhapController.listPhieuNhap.indexWhere(
          (element) => element.maPhieuNhap == phieuNhap.value.maPhieuNhap);
      if (index >= 0) {
        phieuNhapController.listPhieuNhap.removeAt(index);
      }
      loading.value = false;
      return true;
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar('Trạng thái phiếu nhập không hợp lệ');
      return false;
    }
  }

  Future<bool> huyPhieuNhap() async {
    loading.value = true;
    if (phieuNhap.value.maPhieuNhap != null &&
        phieuNhap.value.trangThai == 'Đã nhập hàng') {
      // kiểm tra ngày tạo phiếu phải trước ngày hiện tại 3 ngày
      String threeDaysAgo = DateTime.now()
          .subtract(const Duration(days: 3))
          .toUtc()
          .toIso8601String();

      int sosanh1 = FunctionHelper.sosanhTwoStringUTC(
          phieuNhap.value.ngayLapPhieu!,
          threeDaysAgo); // lập phiểu >= 3 ngày trước hiện tại
      if (sosanh1 < 0) {
        loading.value = true;
        GetShowSnackBar.errorSnackBar(
            'Bạn chỉ có thể huỷ phiếu khi phiếu được lập trong thời gian 3 ngày');
        return false;
      }

      // cập nhật phiếu
      phieuNhap.value.trangThai = 'Đã huỷ';
      Response res = await PhieuNhapService()
          .update(id: phieuNhap.value.maPhieuNhap!, phieuNhap: phieuNhap.value);
      bool ktr = checkResponGetConnect(res);
      if (!ktr) {
        loading.value = false;
        return false;
      }
      // trừ lại các số lượng
      for (var chiTiet in listChiTietPhieuNhap) {
        HangHoaController hangHoaController = Get.find();
        //hangHoaController.listHangHoa ??= [];
        // ignore: unused_local_variable
        int index = hangHoaController.listHangHoa
            .indexWhere((element) => element.maHangHoa == chiTiet.maHangHoa);
        // gọi lô hàng trừ số lượng trong lô hàng
        chiTiet.loNhap ??= [];
        for (var lo in chiTiet.loNhap!) {
          print('Duyệt qua từng lô nhập');
          print(lo.soLo);

          ktr = await _updateTonKho(
              lo: lo, maCuaHang: phieuNhap.value.maCuaHang!, chiTiet: chiTiet);
          if (!ktr) {
            loading.value = false;
            return false;
          }
          ktr = await _updateHangHoa(
              maCuaHang: phieuNhap.value.maCuaHang!,
              chiTiet: chiTiet,
              maPhieu: phieuNhap.value.maPhieuNhap!);
          if (!ktr) {
            loading.value = false;
            return false;
          }
        }
      }
      PhieuNhapController phieuNhapController = Get.find();
      // phieuNhapController.listPhieuNhap.value ??= [];
      int index = phieuNhapController.listPhieuNhap.indexWhere(
          (element) => element.maPhieuNhap == phieuNhap.value.maPhieuNhap);
      if (index >= 0) {
        phieuNhapController.listPhieuNhap[index] = phieuNhap.value;
      }
      loading.value = false;
      update();
      return true;
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar('Trạng thái phiếu nhập không hợp lệ');
      return false;
    }
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

    Response res3 = await TonKhoService().giamSoLuongTonKho(
        soLo: lo.soLo!,
        maCuaHang: maCuaHang,
        maHangHoa: chiTiet.maHangHoa!,
        tonkho: tonKhoModel);
    print('Gọi giảm tồn kho');

    bool ktr = checkResponGetConnect(res3);
    if (!ktr) {
      return false;
    }

    LoHangModel loHangModel = LoHangModel.fromJson(res3.body);
    HangHoaController hangHoaController = Get.find();
    int index = hangHoaController.listHangHoa
        .indexWhere((element) => element.maHangHoa == chiTiet.maHangHoa);
    chiTiet.hangHoa = chiTiet.hangHoa ?? HangHoaModel();
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
      hangHoaController.listHangHoa[index] = hangHoaController
          .listHangHoa[index]
          .copyWith(loHang: chiTiet.hangHoa!.loHang);
    }

    double tonKho = hangHoaController.tongsoLuongTonKhoTrongListLoHang(
        hangHoa: chiTiet.hangHoa!, cuaHang: maCuaHang);

    GiaoDichModel giaoDichModel = GiaoDichModel(
        loaiGiaoDich: 'Huỷ nhập hàng',
        soLuongGiaoDich: chiTiet.soLuong ?? 0,
        soLuongTon: tonKho,
        giaVon: chiTiet.donGiaNhap,
        maHangHoa: chiTiet.maHangHoa,
        maCuaHang: maCuaHang,
        maNhanVien: phieuNhap.value.maNhanVien,
        maPhieuNhap: maPhieu);
    giaoDichModel.soLuongGiaoDich = 0.0 - giaoDichModel.soLuongGiaoDich!;

    Response res5 = await GiaoDichService().create(giaoDichModel);
    print('Gọi thêm giao dịch');

    bool ktr = checkResponGetConnect(res5);
    if (!ktr) {
      return false;
    }

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
}
