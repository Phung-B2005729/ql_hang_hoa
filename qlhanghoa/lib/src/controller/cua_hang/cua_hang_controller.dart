// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/model/cua_hang_model.dart';
import 'package:qlhanghoa/src/service/cua_hang_service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class CuaHangController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<CuaHangModel> filteredList = <CuaHangModel>[].obs;

  // list lấy từ service
  List<CuaHangModel> listCuaHang = [];
  var cuaHangModel = CuaHangModel(loaiCuaHang: 'Chi nhánh').obs;
  var cuaHangModelTam = CuaHangModel().obs;

// tìm kiếm
  TextEditingController searchController = TextEditingController();
  RxBool onsubmit = false.obs;

  //TextEditingController themCuaHangController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;
  // thêm, edit
  final formKey = GlobalKey<FormState>();
  TextEditingController tenCuaHangController = TextEditingController();
  TextEditingController diaChiCuaHangController = TextEditingController();
  TextEditingController sdtCuaHangController = TextEditingController();
  TextEditingController loaiCuaHangController = TextEditingController();
  TextEditingController maCuaHangController = TextEditingController();
  TextEditingController ghiChuController = TextEditingController();

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

  setOnSubmit(bool value) {
    onsubmit.value = value;
    update();
  }

  void reSetDataChiTiet() {
    cuaHangModel.value = CuaHangModel(
      maCuaHang: cuaHangModelTam.value.maCuaHang,
      tenCuaHang: cuaHangModelTam.value.tenCuaHang,
      sdt: cuaHangModelTam.value.sdt,
      diaChi: cuaHangModelTam.value.diaChi,
      tonKho: cuaHangModelTam.value.tonKho,
      loaiCuaHang: cuaHangModelTam.value.loaiCuaHang,
      ghiChu: cuaHangModelTam.value.ghiChu,
      listNhanVien: cuaHangModelTam.value.listNhanVien,
    );
    update();
  }

  void reSetDataThem() async {
    iconClose.value = false;
    loading.value = false;
    cuaHangModel.value = CuaHangModel(loaiCuaHang: 'Chi nhánh');
    tenCuaHangController.text = '';
    sdtCuaHangController.text = '';
    maCuaHangController.text = '';
    loaiCuaHangController.text = 'Chi nhánh';
    diaChiCuaHangController.text = '';
    searchController.text = '';
    ghiChuController.text = '';

    update();
  }

  void reSetTimKiem() {
    searchController.text = '';
    filterlistCuaHang();
  }

  void setUpDataEdit() async {
    loading.value = false;
    tenCuaHangController.text = cuaHangModel.value.tenCuaHang ?? '';
    sdtCuaHangController.text = cuaHangModel.value.sdt ?? '';
    maCuaHangController.text = cuaHangModel.value.maCuaHang ?? '';
    loaiCuaHangController.text = cuaHangModel.value.loaiCuaHang ?? 'Chi nhánh';
    diaChiCuaHangController.text = cuaHangModel.value.diaChi ?? '';
    ghiChuController.text = cuaHangModel.value.ghiChu ?? '';
    cuaHangModelTam.value = CuaHangModel(
      maCuaHang: cuaHangModel.value.maCuaHang,
      tenCuaHang: cuaHangModel.value.tenCuaHang,
      sdt: cuaHangModel.value.sdt,
      diaChi: cuaHangModel.value.diaChi,
      tonKho: cuaHangModel.value.tonKho,
      loaiCuaHang: cuaHangModel.value.loaiCuaHang,
      ghiChu: cuaHangModel.value.ghiChu,
      listNhanVien: cuaHangModel.value.listNhanVien,
    );
  }

  void reSetCuaHangModel() {
    cuaHangModel.value = CuaHangModel(loaiCuaHang: 'Chi nhánh');
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
          .where((element) =>
              element.tenCuaHang!.toLowerCase().contains(query) ||
              element.maCuaHang!.toLowerCase().contains(query) ||
              element.diaChi!.toLowerCase().contains(query) ||
              element.sdt!.toLowerCase().contains(query))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listCuaHang;
    }
    update(); // Cập nhật GetBuilder
  }

  changeLoaiChiNhanh(String chiNhanh) {
    cuaHangModel.value.loaiCuaHang = chiNhanh;
    update();
  }

  Future<bool> createCuaHang() async {
    // lấy ra id
    if (formKey.currentState!.validate()) {
      loading.value = true;
      formKey.currentState!.save();
      // gọi service thêm

      Response res = await CuaHangService().create(cuaHangModel.value);
      if (res.statusCode == 200) {
        print(res.body);
        cuaHangModel.value.maCuaHang = res.body;
        listCuaHang.add(cuaHangModel.value);
        filterlistCuaHang();
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

  Future<bool> updateCuaHang() async {
    // lấy ra id
    if (formKey.currentState!.validate()) {
      loading.value = true;
      formKey.currentState!.save();
      // gọi service thêm

      Response res = await CuaHangService().update(
          id: cuaHangModel.value.maCuaHang!, cuaHang: cuaHangModel.value);
      if (res.statusCode == 200) {
        int index = listCuaHang.indexWhere(
            (element) => element.maCuaHang == cuaHangModel.value.maCuaHang);
        if (index >= 0) {
          listCuaHang[index] = cuaHangModel.value;
        }
        filterlistCuaHang();
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
      cuaHangModel.value = await CuaHangModel.fromJson(res.body);
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

  Future<bool> delete(CuaHangModel cuaHang) async {
    loading.value = true;
    if (cuaHang.tonKho != null && cuaHang.tonKho!.isNotEmpty) {
      GetShowSnackBar.errorSnackBar(
          'Cửa hàng đã có dữ liệu tồn kho không thể xoá');
      loading.value = false;
      return false;
    }
    if (cuaHang.listNhanVien != null && cuaHang.listNhanVien!.isNotEmpty) {
      loading.value = false;
      GetShowSnackBar.errorSnackBar(
          'Cửa hàng đã có thông tin nhân viên không thể xoá');
      return false;
    }
    Response res = await CuaHangService().deleteOne(id: cuaHang.maCuaHang!);
    if (res.statusCode == 200) {
      listCuaHang.remove(cuaHang);
      // update lại cuaHang của list nếu nó bằng loại hàng này
      filterlistCuaHang();
      loading.value = false;
      update();

      return true;
    } else {
      loading.value = false;
      getlistCuaHang();
      filterlistCuaHang();
      GetShowSnackBar.errorSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý xoá");
      return false;
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

  double tongSanPhamTungCuaHang(CuaHangModel cuaHangModel) {
    double kq = 0.0;
    print(cuaHangModel.tonKho);
    if (cuaHangModel.tonKho != null && cuaHangModel.tonKho!.isNotEmpty) {
      for (var kho in cuaHangModel.tonKho!) {
        print('lặp 1');
        kq += kho.soLuongTon ?? 0.0;
      }
    }
    return kq;
  }

  double tongSanPham(List<CuaHangModel> listCuaHang) {
    double kq = 0.0;
    if (listCuaHang != null && listCuaHang.isNotEmpty) {
      for (var cuaHang in listCuaHang) {
        kq += tongSanPhamTungCuaHang(cuaHang);
      }
    }
    return kq;
  }
}
