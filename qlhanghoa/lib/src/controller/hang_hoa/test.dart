import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController tonKhoController = TextEditingController();
  TextEditingController donViTinhController = TextEditingController();
  TextEditingController tonItNhatController = TextEditingController();
  TextEditingController tonNhieuNhatController = TextEditingController();
  TextEditingController moTaController = TextEditingController();

  RxBool quanLyTheoLo = true.obs;

  HangHoaModel hangHoaModel = HangHoaModel(
    donGiaBan: 0,
    giaVon: 0,
    tonKho: 0,
    donViTinh: 'Kg',
    quanLyTheoLo: true,
    tonNhieuNhat: 999999999,
  );

  RxInt indexImage = 0.obs;
  RxList<dynamic> listImage = [].obs;

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUpData();
  }

  void getUpData() {
    quanLyTheoLo.value = hangHoaModel.quanLyTheoLo ?? false;
    tenHangController.text = hangHoaModel.tenHangHoa ?? '';
    maHangController.text = hangHoaModel.maHangHoa ?? '';
    moTaController.text = hangHoaModel.moTa ?? '';
    tonKhoController.text =
        FunctionHelper.formNum(hangHoaModel.tonKho.toString());
    tonItNhatController.text =
        FunctionHelper.formNum(hangHoaModel.tonNhieuNhat.toString());
    giaBanController.text =
        FunctionHelper.formNum(hangHoaModel.donGiaBan.toString());
    donViTinhController.text = hangHoaModel.donViTinh.toString();
    giaVonController.text =
        FunctionHelper.formNum(hangHoaModel.giaVon.toString());
    loaiHangController.text = hangHoaModel.loaiHang?.tenLoai ?? '';
    thuongHieuController.text = hangHoaModel.thuongHieu?.tenThuongHieu ?? '';
    listImage.value = hangHoaModel.hinhAnh ?? [];
  }

  void setUpDateData(HangHoaModel hanghoa) {
    hangHoaModel = hanghoa;
  }

  void saveQuanLyTheoLo(bool value) {
    quanLyTheoLo.value = value;
    hangHoaModel.tonKho = double.tryParse(tonKhoController.text) ?? 0;
    hangHoaModel.quanLyTheoLo = value;
    if (!value) {
      tonKhoController.text = '0';
      hangHoaModel.tonKho = 0;
    }
  }

  void saveThuongHieu(ThuongHieuModel thuongHieu) {
    hangHoaModel = hangHoaModel.copyWith(thuongHieu: thuongHieu);
    thuongHieuController.text = thuongHieu.tenThuongHieu!;
  }

  void deleteLoaiHang() {
    hangHoaModel.loaiHang = LoaiHangModel();
    loaiHangController.text = '';
  }

  void deleteThuongHieu() {
    hangHoaModel.thuongHieu = ThuongHieuModel();
    thuongHieuController.text = '';
  }

  String? getIdLoaiHang() {
    return hangHoaModel.loaiHang?.sId;
  }

  String? getIdThuongHieu() {
    return hangHoaModel.thuongHieu?.sId;
  }

  void saveLoaiHang(LoaiHangModel loaiHang) {
    hangHoaModel = hangHoaModel.copyWith(loaiHang: loaiHang);
    loaiHangController.text = loaiHang.tenLoai!;
  }

  void saveHinhAnh(List<HinhAnhModel> hinhAnh) {
    hangHoaModel = hangHoaModel.copyWith(hinhAnh: hinhAnh);
  }

  int getIndexLinkAnh(String linkanh, List<HinhAnhModel> list) {
    return list.indexWhere((element) => element.linkAnh == linkanh);
  }

  void addListImage(dynamic image) {
    listImage.add(image);
    indexImage.value++;
  }

  void deleteImage(int index) {
    if (listImage[index] is! XFile) {
      UpLoadService.delete(listImage[index]);
    }
    listImage.removeAt(index);
    indexImage.value--;
  }

  Future<void> pickImage(ImageSource imageSource) async {
    print('Gọi hàm image');
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: imageSource);

      if (pickedFile != null) {
        // Save vào list
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
    try {
      final picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      // ignore: unnecessary_null_comparison
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        // Thử gọi upload
        for (var file in pickedFiles) {
          addListImage(file);
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Lỗi image: ' + e.toString());
    }
  }

  Future<dynamic> saveListImage() async {
    var response = await UpLoadService.uploadMultiple(listImage);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // lưu hình ảnh
      List<HinhAnhModel> list = await data
          .map((json) => HinhAnhModel.fromJson(json))
          .toList()
          .cast<HinhAnhModel>();
      return list;
    } else {
      print(data);
      return data['message'] ?? 'Lỗi xử lý trong quá trình thêm ảnh';
    }
  }

  Future<dynamic> deleteListImage(List<dynamic> list) async {
    for (var item in list) {
      var res = await UpLoadService.delete(item);
      if (res.statusCode != 200) {
        return false;
      }
    }
    return true;
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

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      print(maHangController.text);
      print(tenHangController.text);
      if (listImage.isNotEmpty) {
        print('Gọi save');
        loading.value = true;
        formKey.currentState!.save();
        print(hangHoaModel.thuongHieu!.tenThuongHieu);
        // save hình ảnh và upload
        print('gọi save ảnh');
        var res = await UpLoadService.uploadMultiple(listImage);
        var bool = checkResponHttp(res);
        if (bool == true) {
          print('gọi save ảnh 2');
          var data = jsonDecode(res.body);
          hangHoaModel.hinhAnh = await data
              .map((json) => HinhAnhModel.fromJson(json))
              .toList()
              .cast<HinhAnhModel>();
          var response = await HangHoaService().create(hangHoaModel);
          bool = checkResponGetConnect(response);
          if (bool == true) {
            //hangHoaModel.copyWith(maHangHoa: res.body.toString());
            hangHoaModel.maHangHoa = res.body;
            // gọi thêm hàng hoá
            // gọi update
            print('gọi update');
            loading.value = false;
            GetShowSnackBar.successSnackBar('Đã thêm thành công!');
          } else {
            await deleteListImage(hangHoaModel.hinhAnh!);
            hangHoaModel.hinhAnh = [];
          }
        }
      }
      loading.value = false;
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar('Vui lòng thêm hình ảnh cho hàng hoá');
    }
  }

  /*Future<void> save() async {
    if (formKey.currentState!.validate()) {
      print(maHangController.text);
      print(tenHangController.text);
      if (listImage.isNotEmpty) {
        print('Gọi save');
        loading.value = true;
        formKey.currentState!.save();
        print(hangHoaModel.thuongHieu!.tenThuongHieu);
        // gọi thêm hàng hoá
        var res = await HangHoaService().create(hangHoaModel);
        var bool = checkResponGetConnect(res);
        if (bool == true) {
          print(res.body);
          //hangHoaModel.copyWith(maHangHoa: res.body.toString());
          hangHoaModel.maHangHoa = res.body;
          // save hình ảnh và upload
          print('gọi save ảnh');
          var response = await UpLoadService.uploadMultiple(listImage);
          bool = checkResponHttp(response);
          if (bool == true) {
            print('gọi save ảnh 2');
            var data = jsonDecode(response.body);
            hangHoaModel.hinhAnh = await data
                .map((json) => HinhAnhModel.fromJson(json))
                .toList()
                .cast<HinhAnhModel>();
            // gọi update
            print('gọi update');
            var response2 = await HangHoaService().update(
                id: hangHoaModel.maHangHoa.toString(), hangHoa: hangHoaModel);
            bool = checkResponGetConnect(response2);
            if (bool == true) {
              loading.value = false;
              GetShowSnackBar.successSnackBar('Đã thêm thành công!');
            } else {
              await HangHoaService()
                  .deleteOne(id: hangHoaModel.maHangHoa.toString());
              await deleteListImage(hangHoaModel.hinhAnh!);
              hangHoaModel.hinhAnh = [];
            }
          } else {
            // ignore: unused_local_variable
            var response2 = await HangHoaService()
                .deleteOne(id: hangHoaModel.maHangHoa.toString());
          }
        }
      }
      loading.value = false;
    } else {
      loading.value = false;
      GetShowSnackBar.errorSnackBar('Vui lòng thêm hình ảnh cho hàng hoá');
    }
  } */
}
