import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/model/lo_hang.model.dart';
import 'package:qlhanghoa/src/service/lo_hang.service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class LoHangController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa

  RxList<LoHangModel> filteredList = <LoHangModel>[].obs;

  // list lấy từ service
  List<LoHangModel> listLoHang = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController themLoHangController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;
  Rx<String> trangThai = 'Còn hàng'.obs;

  @override
  void onInit() async {
    super.onInit();

    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      CuaHangController controller = Get.find();
      filterListLoHang(
          maCuaHang: controller.cuaHangModel.value.maCuaHang ?? 'Tất cả');
    });
  }

  void setListLoHang(List<LoHangModel>? list) {
    listLoHang = list ?? [];
    filterListLoHang();
    update();
  }

  void reSet() {
    searchController.text = '';
    trangThai.value = 'Còn hàng'.toString();
    listLoHang = [];
    filterListLoHang();
    update();
  }

  void changeTrangThai({required String value, String? maCuaHang}) {
    trangThai.value = value;
    filterListLoHang(maCuaHang: maCuaHang);
    update();
  }

  void filterListLoHang({String? maCuaHang}) {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listLoHang
          .where((element) =>
              element.soLo!.toLowerCase().contains(query.toLowerCase()) ||
              (element.hanSuDung != null &&
                  FunctionHelper.formatDateString(element.hanSuDung!)
                      .toLowerCase()
                      .contains(query.toLowerCase())) ||
              element.maHangHoa!
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listLoHang;
    }
    if (trangThai.value != 'Tất cả') {
      filteredList.value = filteredList
          .where((element) =>
              (trangThai.value == 'Còn hàng' &&
                  tongsoLuongTungLoHang(
                          loHangModel: element, maCuaHang: maCuaHang) >
                      0) ||
              (trangThai.value == 'Hết hàng' &&
                  tongsoLuongTungLoHang(
                          loHangModel: element, maCuaHang: maCuaHang) ==
                      0))
          .toList();
    }
    update(); // Cập nhật GetBuilder
  }

  double tongsoLuongTungLoHang(
      {required LoHangModel loHangModel, String? maCuaHang}) {
    double kq = 0.0;
    AuthController auth = Get.find();
    var maCH = maCuaHang ?? auth.maCuaHang;

    print('Cửa');
    print(maCH);

    if (loHangModel.tonKho != null) {
      for (var tonKhoItem in loHangModel.tonKho!) {
        if (maCH != 'Tất cả' && maCH != '') {
          print('tính');
          print(tonKhoItem.soLuongTon ?? 'yy');
          print(tonKhoItem.maCuaHang);
          print(maCH);
          print(tonKhoItem.maCuaHang.toString() == maCH.toString());

          if (tonKhoItem.maCuaHang.toString() == maCH.toString() &&
              tonKhoItem.soLuongTon != null) {
            // Nếu ma_cua_hang là "CN000001", cộng dồn vào tổng
            kq += tonKhoItem.soLuongTon!;
            print(kq.toString());
          }
          print('tính 2');
        } else {
          if (tonKhoItem.soLuongTon != null) {
            kq += tonKhoItem.soLuongTon!;
          }
        }
      }
    }
    return kq;
  }

  double tongsoLuong(
      {required List<LoHangModel> listLoHang, String? maCuaHang}) {
    double kq = 0.0;
    AuthController auth = Get.find();
    var maCH = maCuaHang ?? auth.maCuaHang;

    print('Cửa');
    print(maCH);
    if (listLoHang.isNotEmpty) {
      for (var loHangModel in listLoHang) {
        if (loHangModel.tonKho != null) {
          for (var tonKhoItem in loHangModel.tonKho!) {
            if (maCH != 'Tất cả' && maCH != '') {
              print('tính');
              print(tonKhoItem.soLuongTon ?? 'yy');
              print(tonKhoItem.maCuaHang);
              print(maCH);
              print(tonKhoItem.maCuaHang.toString() == maCH.toString());

              if (tonKhoItem.maCuaHang.toString() == maCH.toString() &&
                  tonKhoItem.soLuongTon != null) {
                // Nếu ma_cua_hang là "CN000001", cộng dồn vào tổng
                kq += tonKhoItem.soLuongTon!;
                print(kq.toString());
              }
              print('tính 2');
            } else {
              if (tonKhoItem.soLuongTon != null) {
                kq += tonKhoItem.soLuongTon!;
              }
            }
          }
        }
      }
    }
    return kq;
  }

  Future<void> addLoHang(LoHangModel loHangModel) async {
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id

    loading.value = true;

    Response res = await LoHangService().create(loHangModel);
    if (res.statusCode == 200) {
      print(res.body);
      var id = res.body.toString();
      // ignore: unused_local_variable
      LoHangModel loHang = loHangModel.copyWith(sId: id);
      listLoHang.add(loHang);
      filteredList();

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

    Future<void> getListLoHang(
        {String? so_lo,
        String? maHangHoa,
        String? maCuaHang,
        String? hanSuDung,
        String? ngayBatDau,
        String? ngayKetThuc,
        String? trangThai}) async {
      // Lấy danh sách từ API
      Response res = await LoHangService().findAll(
          so_lo: so_lo,
          maCuaHang: maCuaHang,
          maHangHoa: maHangHoa,
          hanSuDung: hanSuDung,
          ngayBatDau: ngayBatDau,
          ngayKetThuc: ngayKetThuc,
          trangThai: trangThai);
      if (res.statusCode == 200) {
        // In ra body của response
        List<dynamic> jsonList;
        if (res.body is List) {
          jsonList = res.body;
        } else {
          jsonList = jsonDecode(res.body);
        }
        print(jsonList);

        // Chuyển đổi JSON list thành list of LoHangModel
        listLoHang = await jsonList
            .map((json) => LoHangModel.fromJson(json))
            .toList()
            .cast<LoHangModel>();
        loading.value = false;
        // Bạn có thể sử dụng listLoHang ở đây
      } else {
        loading.value = false;
        // Hiển thị dialog lỗi
        GetShowSnackBar.errorSnackBar((res.body != null &&
                res.body['message'] != null)
            ? res.body['message']
            : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
      }
    }

    // ignore: unused_element
    int findIndexById(String id) {
      print(id);
      return listLoHang.indexWhere((element) => element.sId == id);
    }
  }
}
