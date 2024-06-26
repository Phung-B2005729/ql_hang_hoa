import 'package:get/get.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';
import 'package:qlhanghoa/src/service/phieu_nhap_service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';

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
}
