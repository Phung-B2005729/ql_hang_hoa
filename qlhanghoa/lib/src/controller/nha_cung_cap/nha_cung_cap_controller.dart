import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/model/nha_cung_cap_model.dart';
import 'package:qlhanghoa/src/service/nha_cung_cap_service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class NhaCungCapController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<NhaCungCapModel> filteredList = <NhaCungCapModel>[].obs;

  // list lấy từ service
  List<NhaCungCapModel> listNhaCungCap = [];

  TextEditingController searchController = TextEditingController();

  //
  var nhaCungCapModel = NhaCungCapModel().obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController tenNhaCungCapController = TextEditingController();
  TextEditingController diaChiNhaCungCapController = TextEditingController();
  TextEditingController sdtNhaCungCapController = TextEditingController();
  TextEditingController emailNhaCungCapController = TextEditingController();
  TextEditingController congTyNhaCungCapController = TextEditingController();
  TextEditingController maNhaCungCapController = TextEditingController();

  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getListNhaCungCap();
    filteredList.value = listNhaCungCap;
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterlistNhaCungCap();
    });
  }

  void reSetDataThem() async {
    iconClose.value = false;
    loading.value = false;
    tenNhaCungCapController.text = '';
    sdtNhaCungCapController.text = '';
    maNhaCungCapController.text = '';
    emailNhaCungCapController.text = '';
    diaChiNhaCungCapController.text = '';
    congTyNhaCungCapController.text = '';
    searchController.text = '';
  }

  void setDataXemChiTiet(NhaCungCapModel nhaCungCap) {
    nhaCungCapModel.value = nhaCungCap;
    update();
  }

  void filterlistNhaCungCap() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listNhaCungCap
          .where((element) =>
              element.tenNhaCungCap!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.maNhaCungCap!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listNhaCungCap;
    }
    update(); // Cập nhật GetBuilder
  }

  Future<void> addnhaCungCap() async {
    // lấy ra id
    if (formKey.currentState!.validate()) {
      loading.value = true;
      formKey.currentState!.save();
      // gọi service thêm

      Response res = await NhaCungCapService().create(nhaCungCapModel.value);
      if (res.statusCode == 200) {
        print(res.body);

        nhaCungCapModel.value.maNhaCungCap = res.body;
        listNhaCungCap.add(nhaCungCapModel.value);
        filterlistNhaCungCap();
        update();
        loading.value = false;
        Get.back();
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
      loading.value = false;
      GetShowSnackBar.errorSnackBar('Vui lòng nhập đầu đủ dữ liệu bắt buộc');
    }
  }

  Future<void> getListNhaCungCap() async {
    // Lấy danh sách từ API
    ThemHangHoaController controller = Get.find();
    controller.loading.value = true;
    Response res = await NhaCungCapService().findAll();
    if (res.statusCode == 200) {
      // In ra body của response
      List<dynamic> jsonList;
      if (res.body is List) {
        jsonList = res.body;
      } else {
        jsonList = jsonDecode(res.body);
      }
      print(jsonList);

      // Chuyển đổi JSON list thành list of NhaCungCapModel
      listNhaCungCap = await jsonList
          .map((json) => NhaCungCapModel.fromJson(json))
          .toList()
          .cast<NhaCungCapModel>();
      controller.loading.value = false;
      // Bạn có thể sử dụng listNhaCungCap ở đây
    } else {
      controller.loading.value = false;
      // Hiển thị dialog lỗi
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
    }
  }

  Future<void> delete(NhaCungCapModel nhaCungCap) async {
    Response res =
        await NhaCungCapService().deleteOne(id: nhaCungCap.maNhaCungCap!);
    if (res.statusCode == 200) {
      listNhaCungCap.remove(nhaCungCap);
      filterlistNhaCungCap();
      GetShowSnackBar.successSnackBar(
          '${nhaCungCap.tenNhaCungCap} đã được xóa');
      update();
    } else {
      getListNhaCungCap();
      filterlistNhaCungCap();
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
    }
  }

  int findIndexById(String id) {
    // ignore: avoid_print
    print(id);
    return listNhaCungCap.indexWhere((element) => element.maNhaCungCap == id);
  }

  NhaCungCapModel findNhaCungCap(String? maNhaCung) {
    return listNhaCungCap.firstWhere(
        (element) => element.maNhaCungCap == maNhaCung,
        orElse: () => NhaCungCapModel());
  }
}
