// ignore_for_file: unnecessary_null_comparison, duplicate_ignore, avoid_print, unnecessary_overrides

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/them_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/hinh_anh_model.dart';
import 'package:qlhanghoa/src/model/loai_hang_model.dart';
import 'package:qlhanghoa/src/model/thuong_hieu_model.dart';
import 'package:qlhanghoa/src/service/hang_hoa_service.dart';
import 'package:qlhanghoa/src/service/upload_service.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class ThemHangHoaController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController maHangController = TextEditingController();
  TextEditingController tenHangController = TextEditingController();
  TextEditingController loaiHangController = TextEditingController();
  TextEditingController thuongHieuController = TextEditingController();
  TextEditingController giaBanController = TextEditingController();
  TextEditingController giaVonController = TextEditingController();
  TextEditingController donViTinhController = TextEditingController();
  TextEditingController tonItNhatController = TextEditingController();
  TextEditingController tonNhieuNhatController = TextEditingController();
  TextEditingController moTaController = TextEditingController();

  RxBool quanLyTheoLo = true.obs;
  RxBool edit = false.obs;

  var hangHoaModel = HangHoaModel(
      donGiaBan: 0,
      giaVon: 0,
      donViTinh: 'Kg',
      quanLyTheoLo: true,
      tonNhieuNhat: 999999999,
      hinhAnh: []).obs;
  var hangHoaModelTam = HangHoaModel(
      donGiaBan: 0,
      giaVon: 0,
      donViTinh: 'Kg',
      quanLyTheoLo: true,
      tonNhieuNhat: 999999999,
      hinhAnh: []).obs;

  RxInt indexImage = 0.obs;
  RxList<dynamic> listImage = [].obs;
  RxList<dynamic> listImageDeleted = [].obs;

  RxBool loading = false.obs;

  // ignore: unnecessary_overrides
  @override
  void onInit() {
    super.onInit();
  }

  void setUpTam() {
    hangHoaModelTam.value = HangHoaModel(
      maHangHoa: hangHoaModel.value.maHangHoa,
      tenHangHoa: hangHoaModel.value.tenHangHoa,
      moTa: hangHoaModel.value.moTa,
      donGiaBan: hangHoaModel.value.donGiaBan,
      loHang: hangHoaModel.value.loHang,
      giaVon: hangHoaModel.value.giaVon,
      tonNhieuNhat: hangHoaModel.value.tonNhieuNhat,
      donViTinh: hangHoaModel.value.donViTinh,
      hinhAnh: hangHoaModel.value.hinhAnh,
      trangThai: hangHoaModel.value.trangThai,
      loaiHang: hangHoaModel.value.loaiHang,
      thuongHieu: hangHoaModel.value.thuongHieu,
      quanLyTheoLo: hangHoaModel.value.quanLyTheoLo,
    );
    update();
  }

  void reSetTam() {
    hangHoaModel.value = HangHoaModel(
      maHangHoa: hangHoaModelTam.value.maHangHoa,
      tenHangHoa: hangHoaModelTam.value.tenHangHoa,
      moTa: hangHoaModelTam.value.moTa,
      donGiaBan: hangHoaModelTam.value.donGiaBan,
      loHang: hangHoaModelTam.value.loHang,
      giaVon: hangHoaModelTam.value.giaVon,
      tonNhieuNhat: hangHoaModelTam.value.tonNhieuNhat,
      donViTinh: hangHoaModelTam.value.donViTinh,
      hinhAnh: hangHoaModelTam.value.hinhAnh,
      trangThai: hangHoaModelTam.value.trangThai,
      loaiHang: hangHoaModelTam.value.loaiHang,
      thuongHieu: hangHoaModelTam.value.thuongHieu,
      quanLyTheoLo: hangHoaModelTam.value.quanLyTheoLo,
    );
    update();
  }

  void getUpData() async {
    print('gọi update');
    quanLyTheoLo.value = hangHoaModel.value.quanLyTheoLo ?? false;
    tenHangController.text = hangHoaModel.value.tenHangHoa ?? '';
    maHangController.text = hangHoaModel.value.maHangHoa ?? '';
    moTaController.text = hangHoaModel.value.moTa ?? '';
    print(moTaController.text);

    tonItNhatController.text = FunctionHelper.formNum(
        hangHoaModel.value.tonNhieuNhat.toString() ?? '999999999');
    giaBanController.text =
        FunctionHelper.formNum(hangHoaModel.value.donGiaBan.toString());
    donViTinhController.text = hangHoaModel.value.donViTinh.toString();
    giaVonController.text =
        FunctionHelper.formNum(hangHoaModel.value.giaVon.toString());
    loaiHangController.text = hangHoaModel.value.loaiHang?.tenLoai ?? '';
    thuongHieuController.text =
        hangHoaModel.value.thuongHieu?.tenThuongHieu ?? '';
    listImage.value = [];
    if (hangHoaModel.value.hinhAnh != null &&
        hangHoaModel.value.hinhAnh!.isNotEmpty) {
      for (var hinhanh in hangHoaModel.value.hinhAnh!) {
        addListImage(hinhanh);
      }
    }
    listImageDeleted.value = [];
    indexImage.value = listImage.length;
    update();
  }

  void setUpDateData(HangHoaModel hanghoa) {
    print('gọi set up');
    hangHoaModel.value = hanghoa;
    getUpData();
    update();
  }

  void reSetData() {
    print('gọi reset');
    hangHoaModel.value = HangHoaModel(
        donGiaBan: 0,
        giaVon: 0,
        donViTinh: 'Kg',
        quanLyTheoLo: true,
        tonNhieuNhat: 999999999,
        hinhAnh: []);
    getUpData();
    changEdit(false);
    update();
  }

  void changEdit(bool value) {
    print('gọi change edit');
    edit.value = value;
  }

  void saveQuanLyTheoLo(bool value) {
    quanLyTheoLo.value = value;

    hangHoaModel.value.quanLyTheoLo = value;
  }

  void saveThuongHieu(ThuongHieuModel thuongHieu) {
    hangHoaModel.value = hangHoaModel.value.copyWith(thuongHieu: thuongHieu);
    thuongHieuController.text = thuongHieu.tenThuongHieu!;
    update();
  }

  void deleteLoaiHang() {
    hangHoaModel.value.loaiHang = LoaiHangModel();
    loaiHangController.text = '';
    update();
  }

  void deleteThuongHieu() {
    hangHoaModel.value.thuongHieu = ThuongHieuModel();
    thuongHieuController.text = '';
    update();
  }

  String? getIdLoaiHang() {
    return hangHoaModel.value.loaiHang?.sId;
  }

  String? getIdThuongHieu() {
    return hangHoaModel.value.thuongHieu?.sId;
  }

  void saveLoaiHang(LoaiHangModel loaiHang) {
    hangHoaModel.value = hangHoaModel.value.copyWith(loaiHang: loaiHang);
    loaiHangController.text = loaiHang.tenLoai!;

    update();
  }

  void saveHinhAnh(List<HinhAnhModel> hinhAnh) {
    hangHoaModel.value = hangHoaModel.value.copyWith(hinhAnh: hinhAnh);
    update();
  }

  int getIndexLinkAnh(String linkanh, List<HinhAnhModel> list) {
    return list != null
        ? list.indexWhere((element) => element.linkAnh == linkanh)
        : -1;
  }

  void addListImage(dynamic image) {
    listImage.add(image);
    indexImage.value++;
  }

  void deleteImage(int index) {
    if (listImage[index] is! XFile) {
      listImageDeleted.add(listImage[index]);
      // xoá trong hanghoaModel
      int inde = getIndexLinkAnh(
          listImage[index].linkAnh, hangHoaModel.value.hinhAnh!);
      if (inde >= 0) {
        hangHoaModel.value.hinhAnh!.removeAt(inde);
      }
      //UpLoadService.delete(listImage[index]);
    }
    listImage.removeAt(index);
    indexImage.value--;
  }

  Future<void> pickImage(ImageSource imageSource) async {
    print('Gọi hàm image');
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: imageSource);
      print('gọi');
      if (pickedFile != null) {
        // Save vào list
        print('save ảnh');
        addListImage(pickedFile);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Lỗi image: ' + e.toString());
    }
  }

  Future<void> pickMulImage() async {
    print('Gọi hàm image');
    // ignore: duplicate_ignore
    try {
      final picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      // ignore: unnecessary_null_comparison
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        // Thử gọi upload
        for (var file in pickedFiles) {
          print('gọi');
          // ignore: unnecessary_type_check
          print(file is XFile);
          addListImage(file);
          // ignore: unnecessary_type_check
          print(file is XFile);
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Lỗi image: ' + e.toString());
    }
  }

  Future<dynamic> saveListImage() async {
    // lộc ra
    List<dynamic> list =
        // ignore: prefer_iterable_wheretype
        await listImage.where((elem) => elem is XFile).toList();
    if (list.isNotEmpty) {
      var response = await UpLoadService.uploadMultiple(list);

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        hangHoaModel.value.hinhAnh ??= [];
        // lưu hình ảnh
        for (var json in data) {
          hangHoaModel.value.hinhAnh!.add(HinhAnhModel.fromJson(json));
        }
        update();
        print(hangHoaModel.value.hinhAnh!.length);
        return true;
      } else {
        GetShowSnackBar.errorSnackBar((data['message'] != null)
            ? data['message']
            : "Lỗi trong quá trình xử lý");
        return false;
      }
    }
    return true;
  }

  Future<dynamic> deleteListImage(List<dynamic> list) async {
    try {
      for (var nameImage in list) {
        if (nameImage != null) {
          print('gọi xoá ảnh');
          var res = await UpLoadService.delete(nameImage);
          if (res.statusCode != 200) {
            return false;
          }
        }
      }
      return true;
    } catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      print('Error delete image ' + e.toString());
      return false;
    }
  }

  bool checkResponHttp(dynamic res) {
    if (res.statusCode == 200) {
      return true;
    } else {
      var data = jsonDecode(res.body);
      loading.value = false;
      Get.dialog(
          ErrorDialog(
            callback: () {},
            message: (data['message'] != null)
                ? data['message']
                : "Lỗi trong quá trình xử lý",
          ),
          // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
          barrierDismissible: false);
      return false;
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

  Future<void> save({bool? themPhieuNhap}) async {
    if (formKey.currentState!.validate()) {
      print(maHangController.text);
      print(tenHangController.text);
      formKey.currentState!.save();
      bool ktr = true;
      if (listImage.isNotEmpty) {
        print('Gọi save');
        loading.value = true;

        print(hangHoaModel.value.thuongHieu!.tenThuongHieu);
        print('gọi save ảnh');
        ktr = await saveListImage();
      }
      if (ktr == true) {
        var response = await HangHoaService().create(hangHoaModel.value);
        ktr = checkResponGetConnect(response);
        if (ktr == true) {
          print('gọi update mã hàng hoá');
          hangHoaModel.value.maHangHoa = response.body;
          // thêm hàng hoá vào list
          HangHoaController hangHoaController = Get.find();
          hangHoaController.addHangHoa(hangHoaModel.value);
          // thêm vào list của ThemPhieuNhapController
          if (themPhieuNhap != null && themPhieuNhap == true) {
            ThemPhieuNhapController themPhieuNhapController = Get.find();
            themPhieuNhapController.addHangHoa(hangHoaModel.value);
          }
          loading.value = false;
          Get.back();
          GetShowSnackBar.successSnackBar('Đã thêm thành công!');
        } else {
          loading.value = false;
          await deleteListImage(hangHoaModel.value.hinhAnh!);
          hangHoaModel.value.hinhAnh = [];
        }
      }

      loading.value = false;
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar('Vui lòng nhập đầy đủ dữ liệu bắt buộc');
    }
  }

  Future<void> upDate({bool? themPhieuNhap}) async {
    if (formKey.currentState!.validate()) {
      print(maHangController.text);
      print(tenHangController.text);
      print('Gọi save');
      loading.value = true;
      formKey.currentState!.save();
      print(hangHoaModel.value.thuongHieu!.tenThuongHieu);
      print('gọi save ảnh');
      bool ktr = true;
      if (listImage.isNotEmpty) {
        ktr = await saveListImage();
      }

      if (ktr == true) {
        print('gọi update hàng hoá');

        var response = await HangHoaService().update(
            id: hangHoaModel.value.maHangHoa!, hangHoa: hangHoaModel.value);
        ktr = checkResponGetConnect(response);
        if (ktr == true) {
          // gọi delete ảnh trên firebase
          await deleteListImage(listImageDeleted);
          listImageDeleted.value = [];
          // gọi update hàng hoá trong list Hàng Hoá
          HangHoaController hangHoaController = Get.find();
          print('gọi update hàng hoá');
          hangHoaController.updateHangHoa(hangHoaModel.value);
          if (themPhieuNhap != null && themPhieuNhap == true) {
            ThemPhieuNhapController themPhieuNhapController = Get.find();
            themPhieuNhapController.upDateGiaBan(
                hangHoaModel.value.maHangHoa!, hangHoaModel.value.donGiaBan!);
          }
          loading.value = false;
          Get.back();
          GetShowSnackBar.successSnackBar(
              'Đã update thành công hàng hoá ${hangHoaModel.value.tenHangHoa}!');
        } else {
          loading.value = false;
          await deleteListImage(hangHoaModel.value.hinhAnh!);
          hangHoaModel.value.hinhAnh = [];
        }
      }
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar('Vui lòng thêm hình ảnh cho hàng hoá');
    }
  }
}
