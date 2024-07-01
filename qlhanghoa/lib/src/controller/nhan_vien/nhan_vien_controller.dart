import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/model/cua_hang_model.dart';

import 'package:qlhanghoa/src/model/nhan_vien_model.dart';

import 'package:qlhanghoa/src/service/nhan_vien_service.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class NhanVienController extends GetxController {
  // loại hàm chỉ có tìm, thêm và xoá, không cho chỉnh sửa
  RxInt selected = (-1).obs;

  RxList<NhanVienModel> filteredList = <NhanVienModel>[].obs;

  // list lấy từ service
  List<NhanVienModel> listNhanVien = [];
  var nhanVienModel = NhanVienModel().obs;
  var nhanVienModelTam = NhanVienModel().obs;

  TextEditingController searchController = TextEditingController();
  //TextEditingController themNhanVienController = TextEditingController();
  RxBool iconClose = false.obs;
  RxBool loading = false.obs;

  // thêm, edit
  final formKey = GlobalKey<FormState>();
  TextEditingController tenNhanVienController = TextEditingController();
  TextEditingController maNhanVienController = TextEditingController();
  TextEditingController diaChiNhanVienController = TextEditingController();
  TextEditingController sdtNhanVienController = TextEditingController();
  TextEditingController chuVuController = TextEditingController();
  TextEditingController emailNhanVienController = TextEditingController();

  TextEditingController ghiChuController = TextEditingController();

  // tìm kiếm
  TextEditingController thongTinChungController = TextEditingController();
  RxList<String> trangThai = ['Đang làm việc'].obs;
  RxList<String> chucVu = ['Nhân viên', 'Chủ cửa hàng', 'Quản lý'].obs;
  RxString maCuaHang = 'Tất cả'.obs;
  RxString chuaTaiKhoan = '1'.obs;
  RxString coTaiKhoan = '1'.obs;
  RxBool onsubmit = false.obs;

  @override
  void onInit() async {
    super.onInit();

    searchController.text = '';
    reSetTimKiem();
    await getListNhanVien();

    filterListNhanVien();
    searchController.addListener(() {
      // lắng nghe sự thay đổi controller
      iconClose.value = searchController.text.isNotEmpty;
      filterListNhanVien();
    });
  }

// tìm kiếm
  void reSetTimKiem() {
    String? maCH = AuthUtil.getMaCuaHang();
    thongTinChungController.text = '';
    trangThai.value = ['Đang làm việc'];
    chucVu.value = ['Nhân viên', 'Chủ cửa hàng', 'Quản lý'];
    maCuaHang.value = maCH ?? 'Tất cả';
    chuaTaiKhoan.value = '1';
    coTaiKhoan.value = '1';
    onsubmit.value = false;
    update();
  }

  void changeOnSubmit(bool value) {
    onsubmit.value = value;
    update();
  }

  void changeChuaCoTaiKhoan() {
    if (chuaTaiKhoan.value == '1') {
      chuaTaiKhoan.value = '0';
    } else {
      chuaTaiKhoan.value = '1';
    }
  }

  void changeCoTaiKhoan() {
    if (coTaiKhoan.value == '1') {
      coTaiKhoan.value = '0';
    } else {
      coTaiKhoan.value = '1';
    }
  }

  void changeMaCuaHang(String ma) {
    maCuaHang.value = ma;
  }

  bool kiemTraList(List<String> list, String value) {
    return list.contains(value);
  }

  void changeListChucVu(String value) {
    bool ktr = kiemTraList(chucVu, value);
    if (ktr) {
      chucVu.remove(value);
    } else {
      chucVu.add(value);
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

  void reSetDataThem() async {
    reSetTimKiem();
    iconClose.value = false;
    loading.value = false;
    String? maCuaHang = AuthUtil.getMaCuaHang();
    nhanVienModel.value = NhanVienModel(
        chucVu: 'Nhân viên', maCuaHang: maCuaHang, gioiTinh: true);
    tenNhanVienController.text = '';
    sdtNhanVienController.text = '';
    maNhanVienController.text = '';
    chuVuController.text = 'Nhân viên';
    diaChiNhanVienController.text = '';
    emailNhanVienController.text = '';
    searchController.text = '';
    ghiChuController.text = '';
  }

  void reSetDataChiTiet() {
    nhanVienModel.value = NhanVienModel(
      maCuaHang: nhanVienModelTam.value.maCuaHang,
      tenNhanVien: nhanVienModelTam.value.tenNhanVien,
      maNhanVien: nhanVienModelTam.value.tenNhanVien,
      sdt: nhanVienModelTam.value.sdt,
      diaChi: nhanVienModelTam.value.diaChi,
      gioiTinh: nhanVienModelTam.value.gioiTinh,
      email: nhanVienModelTam.value.email,
      chucVu: nhanVienModelTam.value.chucVu,
      taiKhoan: nhanVienModelTam.value.taiKhoan,
      trangThai: nhanVienModelTam.value.trangThai,
      ghiChu: nhanVienModelTam.value.ghiChu,
      cuaHang: nhanVienModelTam.value.cuaHang,
    );
    update();
  }

  void setUpDataEdit() async {
    reSetTimKiem();
    loading.value = false;
    tenNhanVienController.text = nhanVienModel.value.tenNhanVien ?? '';
    sdtNhanVienController.text = nhanVienModel.value.sdt ?? '';
    maNhanVienController.text = nhanVienModel.value.maNhanVien ?? '';
    chuVuController.text = nhanVienModel.value.chucVu ?? 'Nhân viên';
    diaChiNhanVienController.text = nhanVienModel.value.diaChi ?? '';
    ghiChuController.text = nhanVienModel.value.ghiChu ?? '';
    emailNhanVienController.text = nhanVienModel.value.email ?? '';
    nhanVienModelTam.value = NhanVienModel(
      maCuaHang: nhanVienModel.value.maCuaHang,
      tenNhanVien: nhanVienModel.value.tenNhanVien,
      maNhanVien: nhanVienModel.value.tenNhanVien,
      sdt: nhanVienModel.value.sdt,
      diaChi: nhanVienModel.value.diaChi,
      gioiTinh: nhanVienModel.value.gioiTinh,
      email: nhanVienModel.value.email,
      chucVu: nhanVienModel.value.chucVu,
      taiKhoan: nhanVienModel.value.taiKhoan,
      trangThai: nhanVienModel.value.trangThai,
      ghiChu: nhanVienModel.value.ghiChu,
      cuaHang: nhanVienModel.value.cuaHang,
    );
    update();
  }

  void filterListNhanVien() {
    String query = searchController.text.toLowerCase();
    if (searchController.text.isNotEmpty) {
      print('gọi');
      filteredList.value = listNhanVien
          .where((element) =>
              element.tenNhanVien!.toLowerCase().contains(query) ||
              element.maNhanVien!.toLowerCase().contains(query) ||
              element.sdt!.toLowerCase().contains(query))
          .toList();
    } else {
      print('gọi 2');
      filteredList.value = listNhanVien;
    }
    update(); // Cập nhật GetBuilder
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

  Future<bool> getOneNhanVien(String maNhanVien) async {
    loading.value = true;

    Response res = await NhanVienService().getById(id: maNhanVien);
    bool ktr = checkResponGetConnect(res);
    if (!ktr) {
      loading.value = false;
      return false;
    }
    nhanVienModel.value = await NhanVienModel.fromJson(res.body);
    // print('gọi');
    update();
    loading.value = false;
    return true;
  }

  Future<bool> createNhanVien() async {
    // lấy ra id
    if (formKey.currentState!.validate()) {
      loading.value = true;
      formKey.currentState!.save();
      // gọi service thêm

      Response res = await NhanVienService().create(nhanVienModel.value);
      if (res.statusCode == 200) {
        print(res.body);
        nhanVienModel.value.maNhanVien = res.body;
        listNhanVien.add(nhanVienModel.value);
        filterListNhanVien();
        update();
        loading.value = false;
        return true;
      } else {
        filterListNhanVien();
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

  Future<bool> updateNhanVien() async {
    // lấy ra id
    if (formKey.currentState!.validate()) {
      loading.value = true;
      formKey.currentState!.save();
      // gọi service thêm

      Response res = await NhanVienService().update(
          id: nhanVienModel.value.maNhanVien!, nhanVien: nhanVienModel.value);
      if (res.statusCode == 200) {
        int index = listNhanVien.indexWhere(
            (element) => element.maNhanVien == nhanVienModel.value.maNhanVien);
        if (index >= 0) {
          listNhanVien[index] = nhanVienModel.value;
        }
        filterListNhanVien();
        update();
        loading.value = false;
        return true;
      } else {
        filterListNhanVien();
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

  Future<void> getListNhanVien({bool? getChuaTaiKhoan}) async {
    // Lấy danh sách từ API
    // ignore: avoid_print
    print('gọi');
    loading.value = true;
    Response? res;
    if (getChuaTaiKhoan == true) {
      res = await NhanVienService().findAll(
        chuaTaiKhoan: '1',
      );
    } else {
      res = await NhanVienService().findAll(
          chucVu: chucVu,
          chuaTaiKhoan: chuaTaiKhoan.value,
          trangThai: trangThai,
          maCuaHang: maCuaHang.value,
          thongTinChung: thongTinChungController.text,
          coTaiKhoan: coTaiKhoan.value);
    }
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

  Future<bool> delete(NhanVienModel nhanVien) async {
    loading.value = true;
    Response res = await NhanVienService().deleteOne(id: nhanVien.maNhanVien!);
    if (res.statusCode == 200) {
      listNhanVien.remove(nhanVien);
      filterListNhanVien();
      loading.value = false;
      update();

      return true;
    } else {
      getListNhanVien();
      filterListNhanVien();
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
    print(id);
    return listNhanVien.indexWhere((element) => element.maNhanVien == id);
  }

  NhanVienModel findNhanVien(String? maNhanVien) {
    return listNhanVien.firstWhere(
        (element) => element.maNhanVien == maNhanVien,
        orElse: () => NhanVienModel());
  }

  int chuaCoTaiKhoan(List<NhanVienModel> nhanVien) {
    int kq = 0;
    if (nhanVien.isNotEmpty) {
      for (var nv in nhanVien) {
        if (nv.taiKhoan == null ||
            (nv.taiKhoan != null && nv.taiKhoan!.userName == null)) {
          kq += 1;
        }
      }
    }
    return kq;
  }

  changeChucVu(String chucVu) {
    nhanVienModel.value.chucVu = chucVu;
    update();
  }

  changeGioiTinh(bool gioiTinh) {
    nhanVienModel.value.gioiTinh = gioiTinh;
    update();
  }

  chonCuaHang(CuaHangModel cuaHang) {
    nhanVienModel.value.maCuaHang = cuaHang.maCuaHang;
    nhanVienModel.value.cuaHang = CuaHangModel(
        maCuaHang: cuaHang.maCuaHang, tenCuaHang: cuaHang.tenCuaHang);
  }
}
