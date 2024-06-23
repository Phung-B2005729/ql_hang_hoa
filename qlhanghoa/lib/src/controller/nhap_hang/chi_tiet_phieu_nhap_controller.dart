import 'package:get/get.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';
import 'package:qlhanghoa/src/service/phieu_nhap_service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';

class ChiTietPhieuNhapController extends GetxController {
  // data hiển thị, thêm phiếu nhập
  var phieuNhap = PhieuNhapModel().obs;

  RxList<ChiTietPhieuNhapModel> listChiTietPhieuNhap =
      <ChiTietPhieuNhapModel>[].obs; // lưu list chi tiết để nữa thêm nào data
  RxBool loading = false.obs;

  RxList<HangHoaModel> listHangHoa = <HangHoaModel>[]
      .obs; // list hàng hoá có trong chi tiết, từ đâu lộc ra các lô được thêm trong list chỉ tiết

  // widget thể hiện phân cấp theo từng hàng hoá, hàng hoá -> các lô hoặc số lượng được thêm, 1 hàng hoá coá nhiều lô được thêm vào trong 1 list chi tiết

  @override
  void onInit() {
    super.onInit();
    reSetData();
  }

  void reSetData() {
    phieuNhap.value = PhieuNhapModel();
    listChiTietPhieuNhap.clear();
    listHangHoa.clear();
  }

  Future<void> getOnePhieuNhap(String maPhieu) async {
    loading.value = true;
    try {
      Response res = await PhieuNhapService().getById(id: maPhieu);
      if (res.statusCode == 200 && res.body != null) {
        phieuNhap.value = PhieuNhapModel.fromJson(res.body);
        print(res.body);

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
}
