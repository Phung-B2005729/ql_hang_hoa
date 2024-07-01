// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';
import 'package:qlhanghoa/src/model/nhan_vien_model.dart';
import 'package:qlhanghoa/src/model/tai_khoan_model.dart';
import 'package:qlhanghoa/src/service/nhan_vien_service.dart';
import 'package:qlhanghoa/src/service/tai_khoan_service.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class TaiKhoanController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa

  RxList<TaiKhoanModel> filteredList = <TaiKhoanModel>[].obs;

  // list lấy từ service
  List<TaiKhoanModel> listTaiKhoan = [];
  var taiKhoanModel = TaiKhoanModel().obs;

  TextEditingController searchController = TextEditingController();
  //TextEditingController themTaiKhoanController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;
  // xác nhận mật khẩu admin
  final formKeyAdmin = GlobalKey<FormState>();
  TextEditingController adminPasswordController = TextEditingController();
  // thêm, edit
  final formKey = GlobalKey<FormState>();
  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;
  RxBool showAdminPassword = false.obs;
  RxBool showOldPassword = false.obs;
  TextEditingController userNamController = TextEditingController();
  TextEditingController hoTenController = TextEditingController();
  TextEditingController sdtController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxInt phanQuyenController = 1.obs;
  RxString chucVuController = 'Nhân viên'.obs;
  // cấp mật khẩu
  TextEditingController oldPasswordController = TextEditingController();
  //TextEditingController emailTaiKhoanController = TextEditingController();

  TextEditingController ghiChuController = TextEditingController();

  // tìm kiếm
  TextEditingController thongTinChungController = TextEditingController();
  RxList<String> trangThai = ['1'].obs;
  RxList<String> phanQuyen = ['0', '1'].obs;
  RxBool onsubmit = false.obs;

  @override
  void onInit() async {
    super.onInit();

    searchController.text = '';
    reSetTimKiem();
    await getListTaiKhoan();

    filterListTaiKhoan();
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterListTaiKhoan();
    });
  }

// thêm
  void setUpDataControllerThemMoi() {
    chucVuController.value = taiKhoanModel.value.nhanVien != null &&
            taiKhoanModel.value.nhanVien!.chucVu != null
        ? taiKhoanModel.value.nhanVien!.chucVu!
        : 'Nhân viên';
    showAdminPassword.value = false;
    showConfirmPassword.value = false;
    showPassword.value = false;
    showOldPassword.value = false;
    userNamController.text = taiKhoanModel.value.userName ?? '';
    passwordController.text = taiKhoanModel.value.password ?? '';
    oldPasswordController.text = taiKhoanModel.value.oldPassword ?? '';
    adminPasswordController.text = taiKhoanModel.value.adminPassword ?? '';
    phanQuyenController.value = taiKhoanModel.value.phanQuyen != null
        ? taiKhoanModel.value.phanQuyen!
        : 1;
    hoTenController.text = taiKhoanModel.value.nhanVien != null &&
            taiKhoanModel.value.nhanVien!.tenNhanVien != null
        ? taiKhoanModel.value.nhanVien!.tenNhanVien!
        : '';
    sdtController.text = taiKhoanModel.value.nhanVien != null &&
            taiKhoanModel.value.nhanVien!.sdt != null
        ? taiKhoanModel.value.nhanVien!.sdt!
        : '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    update();
  }

  void setTaiKhoanThem(
      {required TaiKhoanModel taiKhoan, NhanVienModel? nhanVienModel}) {
    taiKhoanModel.value = TaiKhoanModel(
        sId: taiKhoan.sId,
        userName: taiKhoan.userName,
        confirmPassword: '',
        adminPassword: '',
        userNameAdmin: '',
        password: '',
        trangThai: taiKhoan.trangThai,
        oldPassword: '',
        nhanVien: taiKhoan.nhanVien ??
            NhanVienModel(chucVu: 'Nhân viên', trangThai: 'Đang làm việc'),
        phanQuyen: taiKhoan.phanQuyen != null ? taiKhoan.phanQuyen : 1);
    if (nhanVienModel != null) {
      taiKhoanModel.value.nhanVien!.tenNhanVien =
          nhanVienModel.tenNhanVien ?? '';
      taiKhoanModel.value.nhanVien!.maNhanVien = nhanVienModel.maNhanVien ?? '';
      taiKhoanModel.value.nhanVien!.sdt = nhanVienModel.sdt ?? '';
      taiKhoanModel.value.userName =
          taiKhoanModel.value.userName ?? nhanVienModel.maNhanVien;
    }
    update();
    setUpDataControllerThemMoi();
    update();
  }

  void reSetThem() {
    taiKhoanModel.value = TaiKhoanModel(
      nhanVien: NhanVienModel(),
      phanQuyen: 1,
    );
    setUpDataControllerThemMoi();
    update();
  }

  void changePhanQuyenThem(int value) {
    phanQuyenController.value = value;

    update();
  }

  void changeChucVuThem(String value) {
    chucVuController.value = value;

    update();
  }

// tìm kiếm
  void reSetTimKiem() {
    thongTinChungController.text = '';
    trangThai.value = ['1'];
    phanQuyen.value = ['0', '1'];
    onsubmit.value = false;
    update();
  }

  void changeOnSubmit(bool value) {
    onsubmit.value = value;
    update();
  }

  bool kiemTraList(List<String> list, String value) {
    return list.contains(value);
  }

  void changeListPhanQuyen(String value) {
    bool ktr = kiemTraList(phanQuyen, value);
    if (ktr) {
      phanQuyen.remove(value);
    } else {
      phanQuyen.add(value);
    }
    update();
  }

  void changeListTrangThai(String value) {
    bool ktr = kiemTraList(trangThai, value);
    if (ktr) {
      trangThai.remove(value);
    } else {
      trangThai.add(value);
    }
    update();
  }

  void filterListTaiKhoan() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listTaiKhoan
          .where((element) => element.userName!.toLowerCase().contains(query))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listTaiKhoan;
    }
    update(); // Cập nhật GetBuilder
  }

  void findByTaiKhoan(String userName) {
    if (listTaiKhoan.isNotEmpty) {
      taiKhoanModel.value = listTaiKhoan.firstWhere(
        (element) => element.userName == userName,
        orElse: () => TaiKhoanModel(), // xử lý trường hợp không tìm thấy
      );
      update();
    }
  }

  int getIndexTaiKhoan(String userName) {
    return listTaiKhoan.indexWhere((element) => element.userName == userName);
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

  Future<bool> createTaiKhoan({bool? themTuNhanVien}) async {
    if (formKeyAdmin.currentState!.validate()) {
      Get.back();

      loading.value = true;
      formKey.currentState!.save();
      formKeyAdmin.currentState!.save();
      String? adminUserName = AuthUtil.getUserName();
      taiKhoanModel.value.userNameAdmin = adminUserName;
      taiKhoanModel.value.phanQuyen = phanQuyenController.value;
      taiKhoanModel.value.trangThai = 1;
      Response res = await TaiKhoanService().create(taiKhoanModel.value);
      // thêm tài khoản
      if (res.statusCode == 200) {
        print(res.body);
        taiKhoanModel.value.sId = res.body;
        //
        if (themTuNhanVien != true) {
          // thêm mới hoàn toàn
          if (taiKhoanModel.value.nhanVien != null) {
            String? maCuaHang = AuthUtil.getMaCuaHang();
            NhanVienModel nhanVien = taiKhoanModel.value.nhanVien!;
            nhanVien.maNhanVien = taiKhoanModel.value.userName;
            nhanVien.maCuaHang = maCuaHang;
            nhanVien.trangThai = 'Đang làm việc';
            nhanVien.chucVu = chucVuController.value;
            nhanVien.taiKhoan = TaiKhoanModel(
              userName: taiKhoanModel.value.userName,
              trangThai: taiKhoanModel.value.trangThai,
              phanQuyen: taiKhoanModel.value.phanQuyen,
            );
            NhanVienController nhanVienController = Get.find();
            Response res2 = await NhanVienService().create(nhanVien);
            if (res2.statusCode != 200) {
              loading.value = false;
              Get.dialog(
                  ErrorDialog(
                    callback: () {},
                    message: (res2.body != null && res2.body['message'] != null)
                        ? res.body['message']
                        : "Lỗi trong quá trình xử lý",
                  ),
                  // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
                  barrierDismissible: false);
              return false;
            }

            print(res.body);
            nhanVien.maNhanVien = res2.body;
            taiKhoanModel.value.nhanVien!.maNhanVien = res2.body;
            nhanVienController.listNhanVien.add(nhanVien);
            nhanVienController.filterListNhanVien();
          }
        } else {
          // thêm từ nhân viên => update lại
          NhanVienController nhanVienController = Get.find();
          int index = nhanVienController
              .findIndexById(taiKhoanModel.value.userName ?? '');
          if (index >= 0) {
            nhanVienController.listNhanVien[index].taiKhoan = TaiKhoanModel(
              userName: taiKhoanModel.value.userName,
              trangThai: taiKhoanModel.value.trangThai,
              phanQuyen: taiKhoanModel.value.phanQuyen,
            );
            Response res2 = await NhanVienService().update(
                id: nhanVienController.listNhanVien[index].maNhanVien!,
                nhanVien: nhanVienController.listNhanVien[index]);
            if (res2.statusCode != 200) {
              loading.value = false;
              Get.dialog(
                  ErrorDialog(
                    callback: () {},
                    message: (res2.body != null && res2.body['message'] != null)
                        ? res.body['message']
                        : "Lỗi trong quá trình xử lý",
                  ),
                  // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
                  barrierDismissible: false);
              return false;
            }
            nhanVienController.filterListNhanVien();
          }
        }
        listTaiKhoan.add(taiKhoanModel.value);

        filterListTaiKhoan();
        update();
        loading.value = false;
        return true;
      } else {
        filterListTaiKhoan();
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

  Future<bool> updateTaiKhoan(
      {required TaiKhoanModel taiKhoan,
      bool? khoaTaiKhoan,
      bool? moTaiKhoan,
      bool? xoaQuyenAdmin,
      bool? capQuyenAdmin}) async {
    // lấy ra id
    if (formKeyAdmin.currentState!.validate()) {
      Get.back();
      Get.back();
      loading.value = true;
      formKeyAdmin.currentState!.save();
      // gọi update
      if (khoaTaiKhoan == true) {
        taiKhoan.trangThai = 0;
      }
      if (moTaiKhoan == true) {
        taiKhoan.trangThai = 1;
      }
      if (xoaQuyenAdmin == true) {
        taiKhoan.phanQuyen = 1;
      }
      if (capQuyenAdmin == true) {
        taiKhoan.phanQuyen = 0;
      }
      String? us = AuthUtil.getUserName();
      taiKhoan.userNameAdmin = us;
      taiKhoan.adminPassword = adminPasswordController.text;

      Response res = await TaiKhoanService()
          .update(id: taiKhoan.userName!, taiKhoan: taiKhoan);
      if (res.statusCode == 200) {
        // update lại trong nhân viên
        int indext = listTaiKhoan
            .indexWhere((element) => element.userName == taiKhoan.userName);
        if (indext >= 0) {
          listTaiKhoan[indext] = taiKhoan;
        }
        NhanVienController nhanVienController = Get.find();
        int index = nhanVienController.findIndexById(taiKhoan.userName ?? '');
        if (index >= 0) {
          nhanVienController.listNhanVien[index].taiKhoan = taiKhoan;
          Response res2 = await NhanVienService().update(
              id: nhanVienController.listNhanVien[index].maNhanVien!,
              nhanVien: nhanVienController.listNhanVien[index]);

          if (res2.statusCode != 200) {
            loading.value = false;
            Get.dialog(
                ErrorDialog(
                  callback: () {},
                  message: (res2.body != null && res2.body['message'] != null)
                      ? res.body['message']
                      : "Lỗi trong quá trình xử lý",
                ),
                // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
                barrierDismissible: false);
            return false;
          }
        }
        nhanVienController.filterListNhanVien();
        filterListTaiKhoan();
        update();
        loading.value = false;
        return true;
      } else {
        filterListTaiKhoan();
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

      return false;
    }
  }

  Future<void> getListTaiKhoan() async {
    // Lấy danh sách từ API
    print('gọi');
    loading.value = true;
    print('gọi get list account');
    print(trangThai);
    print(phanQuyen);
    Response res = await TaiKhoanService().findAll(
      trangThai: trangThai,
      phanQuyen: phanQuyen,
      thongTinChung: thongTinChungController.text,
    );
    if (res.statusCode == 200) {
      print(res.statusCode);
      // In ra body của response
      List<dynamic> jsonList;
      if (res.body is List) {
        jsonList = res.body;
      } else {
        jsonList = jsonDecode(res.body);
      }
      print(jsonList);

      // Chuyển đổi JSON list thành list of TaiKhoanModel
      listTaiKhoan = await jsonList
          .map((json) => TaiKhoanModel.fromJson(json))
          .toList()
          .cast<TaiKhoanModel>();
      filterListTaiKhoan();
      update();
      loading.value = false;
      // Bạn có thể sử dụng listTaiKhoan ở đây
    } else {
      loading.value = false;
      filterListTaiKhoan();
      update();
      // Hiển thị dialog lỗi
      GetShowSnackBar.errorSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý danh sách cửa hàng");
    }
  }

  // ignore: non_constant_identifier_names
  Future<bool> adminDeleteTaiKhoan(TaiKhoanModel taiKhoan) async {
    if (formKeyAdmin.currentState!.validate()) {
      loading.value = true;
      formKeyAdmin.currentState!.save();
      Get.back();
      Get.back();
      String? us = AuthUtil.getUserName();
      taiKhoan.userNameAdmin = us;
      taiKhoan.adminPassword = adminPasswordController.text;
      Response res = await TaiKhoanService()
          .adminDeleteTaiKhoan(id: taiKhoan.userName!, taiKhoan: taiKhoan);
      if (res.statusCode == 200) {
        listTaiKhoan.remove(taiKhoan);
        // update lại
        NhanVienController nhanVienController = Get.find();
        int index = nhanVienController.findIndexById(taiKhoan.userName ?? '');
        if (index >= 0) {
          nhanVienController.listNhanVien[index].taiKhoan = TaiKhoanModel();
          Response res2 = await NhanVienService().update(
              id: nhanVienController.listNhanVien[index].maNhanVien!,
              nhanVien: nhanVienController.listNhanVien[index]);

          if (res2.statusCode != 200) {
            loading.value = false;
            Get.dialog(
                ErrorDialog(
                  callback: () {},
                  message: (res2.body != null && res2.body['message'] != null)
                      ? res.body['message']
                      : "Lỗi trong quá trình xử lý",
                ),
                // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
                barrierDismissible: false);
            return false;
          }
        }

        filterListTaiKhoan();
        loading.value = false;
        update();
        return true;
      } else {
        getListTaiKhoan();
        filterListTaiKhoan();
        update();
        loading.value = false;
        GetShowSnackBar.errorSnackBar((res.body != null &&
                res.body['message'] != null)
            ? res.body['message']
            : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> adminChangePass() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
      formKey.currentState!.save();

      TaiKhoanModel taiKhoan = taiKhoanModel.value;
      String? us = AuthUtil.getUserName();
      taiKhoan.userNameAdmin = us;
      taiKhoan.adminPassword = adminPasswordController.text;
      Response res =
          await TaiKhoanService().adminChangePass(taiKhoan: taiKhoan);
      if (res.statusCode == 200) {
        filterListTaiKhoan();
        loading.value = false;
        update();
        return true;
      } else {
        getListTaiKhoan();
        filterListTaiKhoan();
        update();
        loading.value = false;
        GetShowSnackBar.errorSnackBar((res.body != null &&
                res.body['message'] != null)
            ? res.body['message']
            : "Lỗi trong quá trình xử lý hoặc kết nối internet không ổn định");
        return false;
      }
    } else {
      return false;
    }
  }

  TaiKhoanModel findTaiKhoan(String? userName) {
    return listTaiKhoan.firstWhere((element) => element.userName == userName,
        orElse: () => TaiKhoanModel());
  }

  int countTaiKhoanAdmin(List<TaiKhoanModel> list) {
    int kq = 0;
    // ignore: unnecessary_null_comparison
    if (list != null && list.isNotEmpty) {
      for (var taikhoan in list) {
        if (taikhoan.phanQuyen != null && taikhoan.phanQuyen == 0) {
          kq += 1;
        }
      }
    }
    return kq;
  }
}
