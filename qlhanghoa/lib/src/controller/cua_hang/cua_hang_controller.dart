import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/model/cua_hang_model.dart';
import 'package:qlhanghoa/src/service/cua_hang_service.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class CuaHangController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<CuaHangModel> filteredList = <CuaHangModel>[].obs;

  // list lấy từ service
  List<CuaHangModel> listCuaHang = [];
  var cuaHangModel = CuaHangModel().obs;

  TextEditingController searchController = TextEditingController();
  //TextEditingController themCuaHangController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    print('gọi');
    searchController.text = '';
    await getlistCuaHang();

    filterlistCuaHang();
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterlistCuaHang();
    });
  }

  void reSetCuaHangModel() {
    cuaHangModel.value = CuaHangModel();
    update();
  }

  void changSelected(int index) {
    selected.value = index;
  }

  void filterlistCuaHang() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listCuaHang
          .where((element) => element.tenCuaHang!.toLowerCase().contains(query))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listCuaHang;
    }
    update(); // Cập nhật GetBuilder
  }

  Future<void> addcuaHang(CuaHangModel cuaHang) async {
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    loading.value = true;
    // gọi service thêm loại hàng
    Response res = await CuaHangService().create(cuaHang);
    if (res.statusCode == 200) {
      print(res.body);
      var id = res.body.toString();
      // ignore: unused_local_variable
      cuaHang = cuaHang.copyWith(maCuaHang: id);
      print(id);
      listCuaHang.add(cuaHang);
      filterlistCuaHang();
      // update loại hàng cho hàng
      Get.back();

      loading.value = false;
      GetShowSnackBar.successSnackBar('Đã thêm cửa hàng thành công');
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý danh sách thêm cửa hàng");
    }
  }

  void findByMaCuaHang(String maCuaHang) {
    print('gọi find mã cửa ' + maCuaHang);
    if (listCuaHang.isNotEmpty) {
      cuaHangModel.value = listCuaHang.firstWhere(
        (element) => element.maCuaHang == maCuaHang,
        orElse: () => CuaHangModel(), // xử lý trường hợp không tìm thấy
      );
      update();
    }
  }

  Future<void> getOneCuaHang(String maCuaHang) async {
    print('gọi');
    loading.value = true;
    Response res = await CuaHangService().getById(id: maCuaHang);
    if (res.statusCode == 200) {
      // In ra body của response

      cuaHangModel =
          (await CuaHangModel.fromJson(res.body)) as Rx<CuaHangModel>;
      update();
      loading.value = false;
      // Bạn có thể sử dụng listCuaHang ở đây
    } else {
      loading.value = false;
      filterlistCuaHang();
      // Hiển thị dialog lỗi
    }
  }

  Future<void> getlistCuaHang() async {
    // Lấy danh sách từ API
    print('gọi');
    loading.value = true;
    Response res = await CuaHangService().findAll();
    if (res.statusCode == 200) {
      // In ra body của response
      List<dynamic> jsonList;
      if (res.body is List) {
        jsonList = res.body;
      } else {
        jsonList = jsonDecode(res.body);
      }
      print(jsonList);

      // Chuyển đổi JSON list thành list of CuaHangModel
      listCuaHang = await jsonList
          .map((json) => CuaHangModel.fromJson(json))
          .toList()
          .cast<CuaHangModel>();
      filterlistCuaHang();
      update();
      loading.value = false;
      // Bạn có thể sử dụng listCuaHang ở đây
    } else {
      loading.value = false;
      filterlistCuaHang();
      update();
      // Hiển thị dialog lỗi
      GetShowSnackBar.errorSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý danh sách cửa hàng");
    }
  }

  Future<void> delete(CuaHangModel cuaHang) async {
    Response res = await CuaHangService().deleteOne(id: cuaHang.maCuaHang!);
    if (res.statusCode == 200) {
      listCuaHang.remove(cuaHang);
      // update lại cuaHang của list nếu nó bằng loại hàng này
      filterlistCuaHang();
      GetShowSnackBar.successSnackBar('${cuaHang.tenCuaHang} đã được xóa');
      update();
    } else {
      getlistCuaHang();
      filterlistCuaHang();
      GetShowSnackBar.errorSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý xoá");
      // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
    }
  }

  int findIndexById(String id) {
    print(id);
    return listCuaHang.indexWhere((element) => element.maCuaHang == id);
  }

  CuaHangModel findCuaHang(String? maCuaHang) {
    return maCuaHang != null
        ? listCuaHang.firstWhere((element) => element.maCuaHang == maCuaHang,
            orElse: () => CuaHangModel())
        : CuaHangModel();
  }
}
