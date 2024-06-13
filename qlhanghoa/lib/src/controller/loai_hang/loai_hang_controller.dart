import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/model/loai_hang_model.dart';
import 'package:qlhanghoa/src/service/loai_hang_service.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class LoaiHangController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<LoaiHangModel> filteredList = <LoaiHangModel>[].obs;

  // list lấy từ service
  List<LoaiHangModel> listLoaiHang = [
    LoaiHangModel(sId: '1', tenLoai: 'GrennFix'),
    LoaiHangModel(sId: '2', tenLoai: 'GrennFix2'),
    LoaiHangModel(sId: '3', tenLoai: 'GrennFix3'),
    LoaiHangModel(sId: '4', tenLoai: 'GrennFix4')
  ];

  TextEditingController searchController = TextEditingController();
  TextEditingController themLoaiHangController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getListLoaiHang();
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
    // gọi service thêm loại hàng
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    if (tenloai.isNotEmpty) {
      loading.value = true;
      var id = listLoaiHang.length + 1;
      // ignore: unused_local_variable
      LoaiHangModel loaiHang =
          LoaiHangModel(sId: id.toString(), tenLoai: tenloai);
      listLoaiHang.add(loaiHang);
      filterListLoaiHang();
      // update loại hàng cho hàng
      ThemHangHoaController controller = Get.find();
      controller.saveLoaiHang(loaiHang);
      themLoaiHangController.text = '';
      Get.back();
      loading.value = false;
    } else {
      GetShowSnackBar.errorSnackBar('Vui lòng nhập vào tên loại hàng');
    }
  }

  Future<void> getListLoaiHang() async {
    //lấy danh sách từ api
    Response res = await LoaiHangService().findAll();
    if (res.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(res.body);
      listLoaiHang =
          jsonList.map((json) => LoaiHangModel.fromJson(json)).toList();
    } else {
      GetShowSnackBar.errorSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý");
    }
  }
}
