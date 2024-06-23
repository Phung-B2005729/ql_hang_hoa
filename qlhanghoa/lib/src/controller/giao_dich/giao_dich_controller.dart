import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/model/giao_dich_model.dart';
import 'package:qlhanghoa/src/service/giao_dich_service.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class GiaoDichController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa

  RxList<GiaoDichModel> filteredList = <GiaoDichModel>[].obs;

  // list lấy từ service
  List<GiaoDichModel> listGiaoDich = [];

  TextEditingController searchController = TextEditingController();
  //TextEditingController themGiaoDichController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;
  //Rx<String> trangThai = 'Còn hàng'.obs;

  @override
  void onInit() async {
    super.onInit();

    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      CuaHangController controller = Get.find();
      filterlistGiaoDich(
          maCuaHang: controller.cuaHangModel.value.maCuaHang ?? 'Tất cả');
    });
  }

  void setlistGiaoDich(List<GiaoDichModel>? list) {
    listGiaoDich = list ?? [];
    filterlistGiaoDich();
    update();
  }

  void reSet() {
    searchController.text = '';

    listGiaoDich = [];
    filterlistGiaoDich();
    update();
  }

  void filterlistGiaoDich({String? maCuaHang}) {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi lộc giao dịch');
      filteredList.value = listGiaoDich
          .where((element) =>
              element.soLo!.toLowerCase().contains(query.toLowerCase()) ||
              element.thoiGianGiaoDich!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.loaiGiaoDich!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listGiaoDich;
    }
    print('gọi lộc');
    if (maCuaHang != null && maCuaHang != 'Tất cả') {
      print('gọi mã cửa hàng ' + maCuaHang);
      filteredList.value =
          filteredList.where((p0) => p0.maCuaHang == maCuaHang).toList();
    }

    update(); // Cập nhật GetBuilder
  }

  Future<void> addGiaoDich(GiaoDichModel giaoDichModel) async {
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id

    loading.value = true;

    Response res = await GiaoDichService().create(giaoDichModel);
    if (res.statusCode == 200) {
      print(res.body);
      var id = res.body.toString();
      // ignore: unused_local_variable
      GiaoDichModel giaoDich = giaoDichModel.copyWith(sId: id);
      listGiaoDich.add(giaoDich);
      filteredList();

      loading.value = false;
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
    }
  }

  Future<void> getListGiaoDich(
      {String? so_lo,
      String? maHangHoa,
      String? maCuaHang,
      String? maCuaHangChuyenDen,
      String? maNhanVien,
      String? loaiGiaoDich,
      String? maCuaHangLoc}) async {
    print('gọi list giao dịch');
    // Lấy danh sách từ API
    Response res = await GiaoDichService().findAll(
      soLo: so_lo,
      maCuaHang: maCuaHang,
      maHangHoa: maHangHoa,
      maCuaHangChuyenDen: maCuaHangChuyenDen,
      maNhanVien: maNhanVien,
      loaiGiaoDich: loaiGiaoDich,
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

      // Chuyển đổi JSON list thành list of GiaoDichModel
      listGiaoDich = await jsonList
          .map((json) => GiaoDichModel.fromJson(json))
          .toList()
          .cast<GiaoDichModel>();
      filterlistGiaoDich(maCuaHang: maCuaHangLoc);
      update();
      loading.value = false;
      // Bạn có thể sử dụng listGiaoDich ở đây
    } else {
      loading.value = false;
      // Hiển thị dialog lỗi
      filterlistGiaoDich(maCuaHang: maCuaHangLoc);
      update();
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
    }
  }

  int findIndexById(String id) {
    print(id);
    return listGiaoDich.indexWhere((element) => element.sId == id);
  }
}
