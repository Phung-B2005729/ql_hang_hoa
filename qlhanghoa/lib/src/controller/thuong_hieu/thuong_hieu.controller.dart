import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/model/thuong_hieu_model.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class ThuongHieuController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<ThuongHieuModel> filteredList = <ThuongHieuModel>[].obs;

  // list lấy từ service
  List<ThuongHieuModel> listThuongHieu = [
    ThuongHieuModel(sId: '1', tenThuongHieu: 'GrennFix'),
    ThuongHieuModel(sId: '2', tenThuongHieu: 'GrennFix2'),
    ThuongHieuModel(sId: '3', tenThuongHieu: 'GrennFix3'),
    ThuongHieuModel(sId: '4', tenThuongHieu: 'GrennFix4')
  ];

  TextEditingController searchController = TextEditingController();
  TextEditingController themThuongHieuController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getlistThuongHieu();
    filteredList.value = listThuongHieu;
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterlistThuongHieu();
    });
  }

  void changSelected(int index) {
    selected.value = index;
  }

  void filterlistThuongHieu() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listThuongHieu
          .where(
              (element) => element.tenThuongHieu!.toLowerCase().contains(query))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listThuongHieu;
    }
    update(); // Cập nhật GetBuilder
  }

  Future<void> addThuongHieu(String tenThuongHieu) async {
    // gọi service thêm loại hàng
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    if (tenThuongHieu.isNotEmpty) {
      loading.value = true;
      var id = listThuongHieu.length + 1;
      // ignore: unused_local_variable
      ThuongHieuModel thuongHieu =
          ThuongHieuModel(sId: id.toString(), tenThuongHieu: tenThuongHieu);
      listThuongHieu.add(thuongHieu);
      filterlistThuongHieu();
      // update loại hàng cho hàng
      ThemHangHoaController controller = Get.find();
      controller.saveThuongHieu(thuongHieu);
      themThuongHieuController.text = '';
      Get.back();
      loading.value = false;
    } else {
      GetShowSnackBar.errorSnackBar('Vui lòng nhập vào tên thương hiệu');
    }
  }

  Future<void> getlistThuongHieu() async {
    //lấy danh sách từ api
  }
}
