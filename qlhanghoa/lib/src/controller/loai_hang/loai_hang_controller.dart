import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/model/loai_hang_model.dart';
import 'package:qlhanghoa/src/service/loai_hang_service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class LoaiHangController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<LoaiHangModel> filteredList = <LoaiHangModel>[].obs;

  // list lấy từ service
  List<LoaiHangModel> listLoaiHang = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController themLoaiHangController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await getListLoaiHang();
    filteredList.value = listLoaiHang;
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterListLoaiHang();
    });
  }

  void changSelected(int index) {
    selected.value = index;
  }

  void filterListLoaiHang() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listLoaiHang
          .where((element) => element.tenLoai!.toLowerCase().contains(query))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listLoaiHang;
    }
    update(); // Cập nhật GetBuilder
  }

  Future<void> addLoaiHang(String tenloai) async {
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    if (tenloai.isNotEmpty) {
      loading.value = true;
      // gọi service thêm loại hàng
      LoaiHangModel loaiHang = LoaiHangModel(tenLoai: tenloai);
      Response res = await LoaiHangService().create(loaiHang);
      if (res.statusCode == 200) {
        print(res.body);
        var id = res.body.toString();
        // ignore: unused_local_variable
        LoaiHangModel loaiHang =
            LoaiHangModel(sId: id.toString(), tenLoai: tenloai);
        print(id);
        listLoaiHang.add(loaiHang);
        filterListLoaiHang();
        // update loại hàng cho hàng
        ThemHangHoaController controller = Get.find();
        controller.saveLoaiHang(loaiHang);
        themLoaiHangController.text = '';
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
      GetShowSnackBar.errorSnackBar('Vui lòng nhập vào tên loại hàng');
    }
  }

  Future<void> getListLoaiHang() async {
    // Lấy danh sách từ API
    ThemHangHoaController controller = Get.find();
    controller.loading.value = true;
    Response res = await LoaiHangService().findAll();
    if (res.statusCode == 200) {
      // In ra body của response
      List<dynamic> jsonList;
      if (res.body is List) {
        jsonList = res.body;
      } else {
        jsonList = jsonDecode(res.body);
      }
      print(jsonList);

      // Chuyển đổi JSON list thành list of LoaiHangModel
      listLoaiHang = await jsonList
          .map((json) => LoaiHangModel.fromJson(json))
          .toList()
          .cast<LoaiHangModel>();
      controller.loading.value = false;
      // Bạn có thể sử dụng listLoaiHang ở đây
    } else {
      controller.loading.value = false;
      // Hiển thị dialog lỗi
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
    }
  }

  Future<void> delete(LoaiHangModel loaiHang) async {
    Response res = await LoaiHangService().deleteOne(id: loaiHang.sId!);
    if (res.statusCode == 200) {
      listLoaiHang.remove(loaiHang);
      // update lại loaihang của list nếu nó bằng loại hàng này
      ThemHangHoaController controller = Get.find();
      if (controller.getIdLoaiHang() == loaiHang.sId!) {
        controller.deleteLoaiHang();
      }
      filterListLoaiHang();
      GetShowSnackBar.successSnackBar('${loaiHang.tenLoai} đã được xóa');
      update();
    } else {
      getListLoaiHang();
      filterListLoaiHang();
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
    }
  }

  int findIndexById(String id) {
    // ignore: avoid_print
    print(id);
    return listLoaiHang.indexWhere((element) => element.sId == id);
  }
}
