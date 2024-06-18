import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/service/loai_hang_service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class HangHoaController extends GetxController {
  RxList<HangHoaModel> filteredList = <HangHoaModel>[].obs;

  // list lấy từ service
  List<HangHoaModel> listHangHoa = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController themHangHoaController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getlistHangHoa();
    filteredList.value = listHangHoa;
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterlistHangHoa();
    });
  }

  void changSelected(int index) {
    selected.value = index;
  }

  void filterlistHangHoa() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listHangHoa
          .where((element) => element.tenLoai!.toLowerCase().contains(query))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listHangHoa;
    }
    update(); // Cập nhật GetBuilder
  }

  Future<void> addLoaiHang(String tenloai) async {
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    if (tenloai.isNotEmpty) {
      loading.value = true;
      // gọi service thêm loại hàng
      HangHoaModel loaiHang = HangHoaModel(tenLoai: tenloai);
      Response res = await LoaiHangService().create(loaiHang);
      if (res.statusCode == 200) {
        print(res.body);
        var id = res.body.toString();
        // ignore: unused_local_variable
        HangHoaModel loaiHang =
            HangHoaModel(sId: id.toString(), tenLoai: tenloai);
        print(id);
        listHangHoa.add(loaiHang);
        filterlistHangHoa();
        // update loại hàng cho hàng
        ThemHangHoaController controller = Get.find();
        controller.saveLoaiHang(loaiHang);
        themHangHoaController.text = '';
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

  Future<void> getlistHangHoa() async {
    // Lấy danh sách từ API
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

      // Chuyển đổi JSON list thành list of HangHoaModel
      listHangHoa = await jsonList
          .map((json) => HangHoaModel.fromJson(json))
          .toList()
          .cast<HangHoaModel>();

      // Bạn có thể sử dụng listHangHoa ở đây
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

  Future<void> delete(HangHoaModel loaiHang) async {
    Response res = await LoaiHangService().deleteOne(id: loaiHang.sId!);
    if (res.statusCode == 200) {
      listHangHoa.remove(loaiHang);
      // update lại loaihang của list nếu nó bằng loại hàng này
      ThemHangHoaController controller = Get.find();
      if (controller.getIdLoaiHang() == loaiHang.sId!) {
        controller.deleteLoaiHang();
      }
      filterlistHangHoa();
      GetShowSnackBar.successSnackBar('${loaiHang.tenLoai} đã được xóa');
      update();
    } else {
      getlistHangHoa();
      filterlistHangHoa();
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
    return listHangHoa.indexWhere((element) => element.sId == id);
  }
}
