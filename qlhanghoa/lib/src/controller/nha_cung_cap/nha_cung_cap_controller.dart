// ignore_for_file: prefer_is_empty

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
  RxBool onsubmit = false.obs;
  //xem chi tiết
  var nhaCungCapModel = NhaCungCapModel().obs;
  RxInt indexTap = 0.obs;

  // thêm
  final formKey = GlobalKey<FormState>();
  TextEditingController tenNhaCungCapController = TextEditingController();
  TextEditingController diaChiNhaCungCapController = TextEditingController();
  TextEditingController sdtNhaCungCapController = TextEditingController();
  TextEditingController emailNhaCungCapController = TextEditingController();
  TextEditingController congTyNhaCungCapController = TextEditingController();
  TextEditingController maNhaCungCapController = TextEditingController();
  TextEditingController ghiChuCungCapController = TextEditingController();

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
    nhaCungCapModel.value = NhaCungCapModel();
    tenNhaCungCapController.text = '';
    sdtNhaCungCapController.text = '';
    maNhaCungCapController.text = '';
    emailNhaCungCapController.text = '';
    diaChiNhaCungCapController.text = '';
    congTyNhaCungCapController.text = '';
    ghiChuCungCapController.text = '';
    searchController.text = '';
  }

  setOnSubmit(bool value) {
    onsubmit.value = value;
    update();
  }

  void setUpDataEdit() async {
    loading.value = false;
    tenNhaCungCapController.text = nhaCungCapModel.value.tenNhaCungCap ?? '';
    sdtNhaCungCapController.text = nhaCungCapModel.value.sdt ?? '';
    maNhaCungCapController.text = nhaCungCapModel.value.maNhaCungCap ?? '';
    emailNhaCungCapController.text = nhaCungCapModel.value.email ?? '';
    diaChiNhaCungCapController.text = nhaCungCapModel.value.diaChi ?? '';
    congTyNhaCungCapController.text = nhaCungCapModel.value.congTy ?? '';
    ghiChuCungCapController.text = nhaCungCapModel.value.ghiChu ?? '';
  }

  bool checkResponGetConnect(Response res) {
    if (res.statusCode == 200) {
      return true;
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
      return false;
    }
  }

  Future<bool> getOneNCC(String maNhaCungCap) async {
    loading.value = true;
    indexTap.value = 0;
    Response res = await NhaCungCapService().getById(id: maNhaCungCap);
    bool ktr = checkResponGetConnect(res);
    if (!ktr) {
      loading.value = false;
      return false;
    }
    nhaCungCapModel.value = await NhaCungCapModel.fromJson(res.body);
    // print('gọi');
    update();
    loading.value = false;
    return true;
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
              element.maNhaCungCap!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.diaChi!.toLowerCase().contains(query.toLowerCase()) ||
              element.sdt!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      update();
    } else {
      print('gọi 2');
      filteredList.value = listNhaCungCap;
      update();
    }
    update(); // Cập nhật GetBuilder
  }

  Future<bool> createNCC() async {
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
        return true;
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
        return false;
      }
    } else {
      loading.value = false;
      //GetShowSnackBar.errorSnackBar('Vui lòng nhập đầu đủ dữ liệu bắt buộc');
      return false;
    }
  }

  Future<bool> updateNCC() async {
    // lấy ra id
    if (formKey.currentState!.validate()) {
      loading.value = true;
      formKey.currentState!.save();
      // gọi service thêm

      Response res = await NhaCungCapService().update(
          id: nhaCungCapModel.value.maNhaCungCap!,
          nhaCC: nhaCungCapModel.value);
      if (res.statusCode == 200) {
        int index = listNhaCungCap.indexWhere((element) =>
            element.maNhaCungCap == nhaCungCapModel.value.maNhaCungCap);
        if (index >= 0) {
          listNhaCungCap[index] = nhaCungCapModel.value;
        }
        filterlistNhaCungCap();
        update();
        loading.value = false;
        return true;
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
        return false;
      }
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar('Vui lòng nhập đầu đủ dữ liệu bắt buộc');
      return false;
    }
  }

  Future<void> getListNhaCungCap() async {
    loading.value = true;
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
      loading.value = false;
      searchController.text = '';
      filterlistNhaCungCap();
      update();
      // Bạn có thể sử dụng listNhaCungCap ở đây
    } else {
      controller.loading.value = false;
      searchController.text = '';
      loading.value = false;
      // Hiển thị dialog lỗi
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
    }
  }

  Future<bool> delete(NhaCungCapModel nhaCungCap) async {
    loading.value = true;
    if (nhaCungCap.listPhieuNhap != null &&
        nhaCungCap.listPhieuNhap!.length > 0) {
      print('đã có giap dịch');
      print(nhaCungCap.listPhieuNhap!.length);
      loading.value = false;
      GetShowSnackBar.errorSnackBar(
          'Nhà cung cấp đã có dữ liệu nhập hàng không thể xoá');

      return false;
    }
    // xoá phiếu nhập
    Response res =
        await NhaCungCapService().deleteOne(id: nhaCungCap.maNhaCungCap!);
    if (res.statusCode == 200) {
      listNhaCungCap.remove(nhaCungCap);
      filterlistNhaCungCap();
      loading.value = false;
      update();

      return true;
    } else {
      getListNhaCungCap();
      filterlistNhaCungCap();
      update();
      loading.value = false;
      GetShowSnackBar.errorSnackBar((res.body != null &&
              res.body['message'] != null)
          ? res.body['message']
          : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
      return false;
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

  int tinhTongMuaTungNhaCungCap(NhaCungCapModel nhaCungCap) {
    int kq = 0;
    if (nhaCungCap.listPhieuNhap != null &&
        // ignore:
        nhaCungCap.listPhieuNhap!.length >= 0) {
      for (var phieuNhap in nhaCungCap.listPhieuNhap!) {
        if (phieuNhap.tongTien != null &&
            phieuNhap.trangThai == 'Đã nhập hàng') {
          kq += phieuNhap.tongTien!.toInt();
        }
      }
    }
    return kq;
  }

  int tinhTongMua(List<NhaCungCapModel> listNhaCungCap) {
    int kq = 0;
    // ignore: unnecessary_null_comparison
    if (listNhaCungCap != null && listNhaCungCap.length >= 0) {
      for (var nhaCungCap in listNhaCungCap) {
        kq += tinhTongMuaTungNhaCungCap(nhaCungCap);
      }
    }
    return kq;
  }
}
