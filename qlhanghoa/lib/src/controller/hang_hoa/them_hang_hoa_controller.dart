import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/loai_hang_model.dart';
import 'package:qlhanghoa/src/model/thuong_hieu_model.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class ThemHangHoaController extends GetxController {
  //
  final formKey = GlobalKey<FormState>();
  TextEditingController maHangController = TextEditingController();
  TextEditingController tenHangController = TextEditingController();
  TextEditingController loaiHangController = TextEditingController();
  TextEditingController thuongHieuController = TextEditingController();
  TextEditingController giaBanController = TextEditingController();
  TextEditingController giaVonController = TextEditingController();
  TextEditingController tonKhoController = TextEditingController();
  TextEditingController donViTinhController = TextEditingController();
  TextEditingController tonItNhatController = TextEditingController();
  TextEditingController tonNhieuNhatController = TextEditingController();
  TextEditingController moTaController = TextEditingController();

  RxBool quanLyTheoLo = false.obs;

  HangHoaModel hangHoaModel = HangHoaModel(
    donGiaBan: 0,
    giaVon: 0,
    tonKho: 0,
    donViTinh: 'Kg',
    quanLyTheoLo: false,
    tonNhieuNhat: 999999999,
  );

  RxInt indexImage = 0.obs;
  RxList listImage = [].obs;

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUpData();
  }

  void getUpData() {
    quanLyTheoLo.value = hangHoaModel.quanLyTheoLo ?? false;
    tenHangController.text = hangHoaModel.tenHangHoa == null
        ? ''
        : hangHoaModel.tenHangHoa.toString();
    maHangController.text =
        hangHoaModel.maHangHoa != null ? hangHoaModel.maHangHoa.toString() : '';
    moTaController.text =
        hangHoaModel.moTa != null ? hangHoaModel.moTa.toString() : '';
    tonKhoController.text =
        FunctionHelper.formNum(hangHoaModel.tonKho.toString());
    tonItNhatController.text =
        FunctionHelper.formNum(hangHoaModel.tonNhieuNhat.toString());
    giaBanController.text =
        FunctionHelper.formNum(hangHoaModel.donGiaBan.toString());
    donViTinhController.text = hangHoaModel.donViTinh.toString();
    giaVonController.text =
        FunctionHelper.formNum(hangHoaModel.giaVon.toString());
    loaiHangController.text = (hangHoaModel.loaiHang != null &&
            hangHoaModel.loaiHang?.tenLoai != null)
        ? hangHoaModel.loaiHang!.tenLoai!
        : '';
    thuongHieuController.text = (hangHoaModel.thuongHieu != null &&
            hangHoaModel.thuongHieu?.tenThuongHieu != null)
        ? hangHoaModel.thuongHieu!.tenThuongHieu!
        : '';
    // thiếu trang thái + hình ảnh
  }

  void setUpDateData(HangHoaModel hanghoa) {
    hangHoaModel = hanghoa;
  }

  void saveQuanLyTheoLo(bool value) {
    quanLyTheoLo.value = value;
    if (double.tryParse(tonKhoController.text) == null ||
        tonKhoController.text.isEmpty) {
      tonKhoController.text = '0';
    }
    quanLyTheoLo.value = value;
    if (value == true) {
      hangHoaModel.tonKho = double.tryParse(tonKhoController.text) ?? 0;
    } else {
      tonKhoController.text = '0';
      hangHoaModel.tonKho = 0;
    }
    hangHoaModel.quanLyTheoLo = value;
  }

  void saveThuongHieu(ThuongHieuModel thuongHieu) {
    hangHoaModel = hangHoaModel.copyWith(thuongHieu: thuongHieu);
    thuongHieuController.text = thuongHieu.tenThuongHieu!;
  }

  String? getIdLoaiHang() {
    return (hangHoaModel.loaiHang != null) ? hangHoaModel.loaiHang!.sId : null;
  }

  String? getIdThuongHieu() {
    return (hangHoaModel.thuongHieu != null)
        ? hangHoaModel.thuongHieu!.sId
        : null;
  }

  void saveLoaiHang(LoaiHangModel loaiHang) {
    hangHoaModel = hangHoaModel.copyWith(loaiHang: loaiHang);
    loaiHangController.text = loaiHang.tenLoai!;
  }

  void saveHinhAnh(List<String> hinhAnh) {
    hangHoaModel = hangHoaModel.copyWith(
      hinhAnh: hinhAnh,
      quanLyTheoLo: quanLyTheoLo.value,
    );
  }

  void addListImage(var image) {
    listImage.add(image);
    indexImage.value++;
  }

  void deleteListImage(var index) {
    print(index);
    listImage.removeAt(index);
    indexImage.value--;
  }

  Future pickImage() async {
    print('goi ham imgae');
    try {
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var image = File(pickedFile.path);
        //var imageName = pickedFile.name.toString();
        print(pickedFile.path);
        //print(imageName);
        print(image);

        // save vào list
        addListImage(image);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      // ignore: avoid_print
      print('loi image  ' + e.toString());
    }
  }

  Future save() async {
    if (formKey.currentState!.validate()) {
      print(maHangController.text);
      print(tenHangController.text);
      if (listImage.isNotEmpty) {
        print('gọi save');
        try {
          loading.value = true;
          formKey.currentState!.save();
          loading.value = false;
        } catch (e) {
          // xử lý lỗi
        }
      } else {
        GetShowSnackBar.errorSnackBar('Vui lòng thêm hình ảnh cho hàng hoá');
      }
    }
  }
}
