import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/lo_hang.model.dart';
import 'package:qlhanghoa/src/service/hang_hoa_service.dart';
import 'package:qlhanghoa/src/service/upload_service.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog_try_again.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class HangHoaController extends GetxController {
  RxList<HangHoaModel> filteredList = <HangHoaModel>[].obs;

  // list lấy từ service
  List<HangHoaModel> listHangHoa = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController themHangHoaController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;
  RxBool onsubmit = false.obs;
  RxBool giaBan = true.obs;
  RxBool thuLai = false.obs;
  Rx<String?> maCuaHang = Rx<String?>(null);
  @override
  void onInit() async {
    super.onInit();
    // await getlistHangHoa();

    thuLai.value = false;
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterListHangHoa();
    });
    AuthController auth = Get.find();
    print('Cửa hàng ');
    //print(maCH);
    maCuaHang.value = auth.maCuaHang.value;
    print(maCuaHang.value);
  }

  void setOnSubmit(bool value) {
    onsubmit.value = value;
  }

  void changeHienThiGia(bool gia) {
    print(gia);
    giaBan.value = gia;
  }

  Future<void> getlistHangHoa(
      {String? tenHangHoa,
      String? maHangHoa,
      String? idLoaiHang,
      String? idThuongHieu,
      String? maCuaHang,
      String? trangthaiHSD,
      String? trangthaitonkho,
      String? ngaybatdau,
      String? trangThai,
      String? ngayketthuc}) async {
    print('gọi get all list');
    loading.value = true;
    try {
      String? maCuaHang = await AuthUtil.getMaCuaHang();
      // Lấy danh sách từ API
      Response res = await HangHoaService().findAll(maCuaHang: maCuaHang);
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
        print('gọi thành công');
        print(listHangHoa.length);
        loading.value = false;
        thuLai.value = false;
      } else {
        print(res.statusCode);
        if (res.statusCode == 500 || res.statusCode == null) {
          loading.value = false;
          thuLai.value = true;
          Get.dialog(
              ErrorDialogTryAgain(
                onClose: () {},
                onRetry: () async {
                  await getlistHangHoa();
                  CuaHangController cuaHangController = Get.find();
                  if (cuaHangController.listCuaHang.isEmpty) {
                    await cuaHangController.getlistCuaHang();
                  }
                },
                message: "Lỗi server trong quá trình xử lý",
              ),
              // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
              barrierDismissible: false);
        } else {
          // Hiển thị dialog lỗi
          loading.value = false;
          thuLai.value = true;
          GetShowSnackBar.errorSnackBar(
              (res.body != null && res.body['message'] != null)
                  ? res.body['message']
                  : "Lỗi trong quá trình xử lý");
        }
      }
      filterListHangHoa();
    } catch (e) {
      filterListHangHoa();
      print("lỗi  " + e.toString());
      loading.value = false;
      thuLai.value = true;
      Get.dialog(
          ErrorDialogTryAgain(
            onClose: () {},
            onRetry: () {
              getlistHangHoa();
            },
            message: "Lỗi trong quá trình xử lý",
          ),
          // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
          barrierDismissible: false);
    }
  }

  int checkIndexHangHoa(String maHangHoa) {
    return listHangHoa.indexWhere((element) => element.maHangHoa == maHangHoa);
  }

  void filterListHangHoa() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      //print('gọi');
      filteredList.value = listHangHoa
          .where((element) =>
              element.tenHangHoa!.toLowerCase().contains(query.toLowerCase()) ||
              element.maHangHoa!.toLowerCase().contains(query.toLowerCase()) ||
              element.loaiHang!.tenLoai!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.thuongHieu!.tenThuongHieu!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    } else {
      filteredList.value = listHangHoa;
    }
    update(); // Cập nhật GetBuilder
  }

  Future<void> addHangHoa(HangHoaModel hangHoa) async {
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    int index = checkIndexHangHoa(hangHoa.maHangHoa!);
    if (index < 0) {
      listHangHoa.add(hangHoa);
      update();
    }
  }

  Future<void> updateHangHoa(HangHoaModel hangHoa) async {
    // nếu trả về 200 thì add vào list danh sách
    // lấy ra id
    print('gọi update');
    int index = checkIndexHangHoa(hangHoa.maHangHoa!);
    print(index);
    if (index >= 0) {
      listHangHoa[index] = hangHoa;
      filterListHangHoa();
      update();
    }
  }

  double tongsoLuongTonKhoTrongListLoHang(
      {required HangHoaModel hangHoa, String? cuaHang}) {
    double kq = 0.0;
    var maCH = cuaHang ?? maCuaHang.value;
    if (hangHoa.loHang != null) {
      for (var lo in hangHoa.loHang!) {
        if (lo.tonKho != null) {
          for (var tonKhoItem in lo.tonKho!) {
            print('mã cửa hàng');
            print(maCH);

            if (maCH != 'Tất cả' && maCH != '') {
              if (tonKhoItem.maCuaHang == maCH &&
                  tonKhoItem.soLuongTon != null) {
                // Nếu ma_cua_hang là "CN000001", cộng dồn vào tổng
                kq += tonKhoItem.soLuongTon!;
              }
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

  double tongsoLuongTungLoHang(
      {required LoHangModel loHangModel, String? cuaHang}) {
    double kq = 0.0;
    var maCH = cuaHang ?? maCuaHang.value;
    if (loHangModel.tonKho != null) {
      for (var tonKhoItem in loHangModel.tonKho!) {
        if (maCH != 'Tất cả' && maCH != '') {
          if (tonKhoItem.maCuaHang == maCH && tonKhoItem.soLuongTon != null) {
            // Nếu ma_cua_hang là "CN000001", cộng dồn vào tổng
            kq += tonKhoItem.soLuongTon!;
          }
        } else {
          if (tonKhoItem.soLuongTon != null) {
            kq += tonKhoItem.soLuongTon!;
          }
        }
      }
    }
    return kq;
  }

  double tongsoLuong({String? cuaHang}) {
    double kq = 0.0;
    var maCH = cuaHang ?? maCuaHang.value;
    for (var hangHoa in filteredList) {
      if (hangHoa.loHang != null) {
        for (var lo in hangHoa.loHang!) {
          if (lo.tonKho != null) {
            for (var tonKhoItem in lo.tonKho!) {
              print('mã cửa hàng');
              print(maCH);

              if (maCH != 'Tất cả' && maCH != '') {
                if (tonKhoItem.maCuaHang == maCH &&
                    tonKhoItem.soLuongTon != null) {
                  // Nếu ma_cua_hang là "CN000001", cộng dồn vào tổng
                  kq += tonKhoItem.soLuongTon!;
                }
              } else {
                if (tonKhoItem.soLuongTon != null) {
                  kq += tonKhoItem.soLuongTon!;
                }
              }
            }
          }
        }
      }
    }
    return kq;
  }

  /* dynamic tongsoLuongTonKho(HangHoaModel hangHoa) async {
    double kq = 0.0;
    if (hangHoa.tonKho != null) {
      for (var tonKhoItem in hangHoa.tonKho!) {
        if (tonKhoItem != null) {
          if (maCuaHang.value != 'Tất cả' && maCuaHang.value != '') {
            if (tonKhoItem.maCuaHang == maCuaHang.value &&
                tonKhoItem.soLuongTon != null) {
              kq += tonKhoItem.soLuongTon! ?? 0.0;
            }
          } else {
            if (tonKhoItem.soLuongTon != null) {
              kq += tonKhoItem.soLuongTon! ?? 0.0;
            }
          }
        }
      }
    }
    return kq;
  } */

  Future<void> getFindOne(String maHangHoa) async {
    Response res = await HangHoaService().getById(id: maHangHoa);

    if (res.statusCode == 200) {
      HangHoaModel hangHoaModel = await HangHoaModel.fromJson(res.body);
      ThemHangHoaController controller = Get.find();
      controller.setUpDateData(hangHoaModel);
    } else {
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

  Future<void> delete(HangHoaModel hanghoa) async {
    loading.value = true;
    Response res = await HangHoaService().deleteOne(id: hanghoa.maHangHoa!);
    if (res.statusCode == 200) {
      if (hanghoa.hinhAnh != null) {
        for (var hinhanh in hanghoa.hinhAnh!) {
          await UpLoadService.delete(hinhanh);
        }
      }
      int index = checkIndexHangHoa(hanghoa.maHangHoa!);
      if (index >= 0) {
        listHangHoa.remove(hanghoa);
        filterListHangHoa();
        loading.value = false;
        // xoá ảnh

        GetShowSnackBar.successSnackBar('${hanghoa.tenHangHoa} đã được xóa');
      } else {
        loading.value = false;
        GetShowSnackBar.errorSnackBar(
            'Hàng hoá ${hanghoa.tenHangHoa} không tồn tại');
      }
      update();
    } else {
      loading.value = false;
      // xoá lỗi
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
}
