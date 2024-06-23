import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qlhanghoa/src/model/nhan_vien_model.dart';

import 'package:qlhanghoa/src/service/nhan_vien_service.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class NhanVienController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<NhanVienModel> filteredList = <NhanVienModel>[].obs;

  // list lấy từ service
  List<NhanVienModel> listNhanVien = [];
  var nhanVienModel = NhanVienModel().obs;

  TextEditingController searchController = TextEditingController();
  //TextEditingController themNhanVienController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    searchController.text = '';
    await getListNhanVien();

    filterListNhanVien();
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterListNhanVien();
    });
  }

  void reSetNhanVienModel() {
    nhanVienModel.value = NhanVienModel();
    update();
  }

  void changSelected(int index) {
    selected.value = index;
  }

  void filterListNhanVien() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listNhanVien
          .where(
              (element) => element.tenNhanVien!.toLowerCase().contains(query))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listNhanVien;
    }
    update(); // Cập nhật GetBuilder
  }

  Future<void> addNhanVien(NhanVienModel nhanVien) async {
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    loading.value = true;
    // gọi service thêm loại hàng
    Response res = await NhanVienService().create(nhanVien);
    if (res.statusCode == 200) {
      print(res.body);
      var id = res.body.toString();
      // ignore: unused_local_variable
      nhanVien = nhanVien.copyWith(maNhanVien: id);
      print(id);
      listNhanVien.add(nhanVien);
      filterListNhanVien();
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

  void findByMaNhanVien(String maNhanVien) {
    if (listNhanVien.isNotEmpty) {
      nhanVienModel.value = listNhanVien.firstWhere(
        (element) => element.maNhanVien == maNhanVien,
        orElse: () => NhanVienModel(), // xử lý trường hợp không tìm thấy
      );
      update();
    }
  }

  Future<void> getOnenhanVien(String manhanVien) async {
    print('gọi');
    loading.value = true;
    Response res = await NhanVienService().getById(id: manhanVien);
    if (res.statusCode == 200) {
      // In ra body của response

      nhanVienModel =
          (await NhanVienModel.fromJson(res.body)) as Rx<NhanVienModel>;
      update();
      loading.value = false;
      // Bạn có thể sử dụng listNhanVien ở đây
    } else {
      loading.value = false;
      filterListNhanVien();
      // Hiển thị dialog lỗi
    }
  }

  Future<void> getListNhanVien() async {
    // Lấy danh sách từ API
    print('gọi');
    loading.value = true;
    Response res = await NhanVienService().findAll();
    if (res.statusCode == 200) {
      // In ra body của response
      List<dynamic> jsonList;
      if (res.body is List) {
        jsonList = res.body;
      } else {
        jsonList = jsonDecode(res.body);
      }
      print(jsonList);

      // Chuyển đổi JSON list thành list of NhanVienModel
      listNhanVien = await jsonList
          .map((json) => NhanVienModel.fromJson(json))
          .toList()
          .cast<NhanVienModel>();
      filterListNhanVien();
      update();
      loading.value = false;
      // Bạn có thể sử dụng listNhanVien ở đây
    } else {
      loading.value = false;
      filterListNhanVien();
      update();
      // Hiển thị dialog lỗi
      GetShowSnackBar.errorSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý danh sách cửa hàng");
    }
  }

  Future<void> delete(NhanVienModel nhanVien) async {
    Response res = await NhanVienService().deleteOne(id: nhanVien.maNhanVien!);
    if (res.statusCode == 200) {
      listNhanVien.remove(nhanVien);
      // update lại nhanVien của list nếu nó bằng loại hàng này
      filterListNhanVien();
      GetShowSnackBar.successSnackBar('${nhanVien.tenNhanVien} đã được xóa');
      update();
    } else {
      getListNhanVien();
      filterListNhanVien();
      GetShowSnackBar.errorSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý xoá");
      // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
    }
  }

  int findIndexById(String id) {
    print(id);
    return listNhanVien.indexWhere((element) => element.maNhanVien == id);
  }

  NhanVienModel findNhanVien(String? maNhanVien) {
    return listNhanVien.firstWhere(
        (element) => element.maNhanVien == maNhanVien,
        orElse: () => NhanVienModel());
  }
}
