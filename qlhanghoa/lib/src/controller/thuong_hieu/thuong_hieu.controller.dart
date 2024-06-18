import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/model/thuong_hieu_model.dart';
import 'package:qlhanghoa/src/service/thuong_hieu_service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class ThuongHieuController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<ThuongHieuModel> filteredList = <ThuongHieuModel>[].obs;

  // list lấy từ service
  List<ThuongHieuModel> listThuongHieu = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController themThuongHieuController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getlistThuongHieu();
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
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    if (tenThuongHieu.isNotEmpty) {
      loading.value = true;
      // gọi service thêm loại hàng
      ThuongHieuModel thuongHieu =
          ThuongHieuModel(tenThuongHieu: tenThuongHieu);
      Response res = await ThuongHieuService().create(thuongHieu);
      if (res.statusCode == 200) {
        print(res.body);
        var id = res.body.toString();
        // ignore: unused_local_variable
        ThuongHieuModel thuongHieu =
            ThuongHieuModel(sId: id.toString(), tenThuongHieu: tenThuongHieu);
        print(id);
        listThuongHieu.add(thuongHieu);
        filterlistThuongHieu();
        // update loại hàng cho hàng
        ThemHangHoaController controller = Get.find();
        controller.saveThuongHieu(thuongHieu);
        themThuongHieuController.text = '';
        Get.back();
        loading.value = false;
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
      }
    } else {
      GetShowSnackBar.errorSnackBar('Vui lòng nhập vào tên thương hiệu');
    }
  }

  Future<void> getlistThuongHieu() async {
    // Lấy danh sách từ API
    Response res = await ThuongHieuService().findAll();
    if (res.statusCode == 200) {
      // In ra body của response
      List<dynamic> jsonList;
      if (res.body is List) {
        jsonList = res.body;
      } else {
        jsonList = jsonDecode(res.body);
      }
      print(jsonList);

      // Chuyển đổi JSON list thành list of ThuongHieuModel
      listThuongHieu = await jsonList
          .map((json) => ThuongHieuModel.fromJson(json))
          .toList()
          .cast<ThuongHieuModel>();

      // Bạn có thể sử dụng listThuongHieu ở đây
    } else {
      // Hiển thị dialog lỗi
      Get.dialog(
          ErrorDialog(
            callback: () {},
            message: (res.body != null && res.body['message'] != null)
                ? res.body['message']
                : "Lỗi trong quá trình xử lý",
          ),
          // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
          barrierDismissible: false);
    }
  }

  Future<void> delete(ThuongHieuModel thuongHieu) async {
    Response res = await ThuongHieuService().deleteOne(id: thuongHieu.sId!);
    if (res.statusCode == 200) {
      listThuongHieu.remove(thuongHieu);
      // update lại thuongHieu của list nếu nó bằng loại hàng này
      ThemHangHoaController controller = Get.find();
      if (controller.getIdThuongHieu() == thuongHieu.sId!) {
        controller.deleteThuongHieu();
      }
      filterlistThuongHieu();
      GetShowSnackBar.successSnackBar(
          '${thuongHieu.tenThuongHieu} đã được xóa');
      update();
    } else {
      getlistThuongHieu();
      filterlistThuongHieu();
      Get.dialog(
          ErrorDialog(
            callback: () {},
            message: (res.body != null && res.body['message'] != null)
                ? res.body['message']
                : "Lỗi trong quá trình xử lý",
          ),
          // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
          barrierDismissible: false);
    }
  }

  int findIndexById(String id) {
    print(id);
    return listThuongHieu.indexWhere((element) => element.sId == id);
  }
}
