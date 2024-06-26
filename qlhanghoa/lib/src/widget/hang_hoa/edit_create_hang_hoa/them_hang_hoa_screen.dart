// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/loai_hang/loai_hang_controller.dart';
import 'package:qlhanghoa/src/controller/thuong_hieu/thuong_hieu.controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/edit_create_hang_hoa/chon_loai_hang_screen.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/edit_create_hang_hoa/chon_thuong_hieu_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class ThemHangHoaScreen extends GetView<ThemHangHoaController> {
  LoaiHangController loaiHangController = Get.find();
  ThuongHieuController thuongHieuController = Get.find();
  ThemHangHoaScreen({super.key, this.themPhieuNhap});
  final bool? themPhieuNhap;

  @override
  Widget build(Object context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Obx(
                    () => Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.listImage.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            return (controller.indexImage.value == index)
                                ? _buildPickImage(context)
                                : _buildImage(index);
                          }),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: ColorClass.color_thanh_ke.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(3, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildRowMaHang(),
                        _buildRowTenHang(),
                        _builRowLoaiHang(),
                        _buildRowThuongHieu(),
                        _buildRowGiaBan(),
                        _buildRowGiaVon(),
                        _buildRowDonViTinh(),
                        _buildRowTonNhieuNhat(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowQuanLyTonKho()
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: ColorClass.color_thanh_ke.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(3, 0),
                        ),
                      ],
                    ),
                    child: _buildFileMoTa(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => controller.loading.value
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 3,
      title: Obx(
        () => Text(
          controller.edit.value == true
              ? controller.hangHoaModel.value.maHangHoa.toString()
              : 'Thêm hàng hoá',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      leading: IconButton(
          onPressed: () {
            // chuyển về trang hàng hoá
            Get.dialog(_buildDiaLogBack());
          },
          icon: const Icon(
            Icons.close,
            color: ColorClass.color_outline_icon,
            size: 28,
          )),
      actions: [
        TextButton(
            onPressed: () async {
              print('gọi');
              controller.edit.value == true
                  ? await controller.upDate()
                  : await controller.save(themPhieuNhap: themPhieuNhap);
              // xử lý thêm  hàng hoá
            },
            child: const Text(
              'Lưu',
              style: TextStyle(
                fontSize: 18,
                color: ColorClass.color_xanh_it_dam,
              ),
            )),
      ],
    );
  }

  AlertDialog _buildDiaLogBack() {
    return AlertDialog(
      title: const Text(
        'Bạn có chắc chắn muốn thoát ?',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      content: const Text('Lưu ý:  dữ liệu sẽ không được lưu nếu thoát',
          style: TextStyle(color: Colors.black, fontSize: 16)),
      actions: [
        TextButton(
          child: const Text(
            'HUỶ',
            style: TextStyle(color: ColorClass.color_cancel, fontSize: 18),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: const Text(
            'THOÁT',
            style: TextStyle(color: ColorClass.color_button_nhat, fontSize: 18),
          ),
          onPressed: () async {
            controller.reSetTam();
            Get.back();
            Get.back();
          },
        ),
      ],
    );
  }

  Row _buildRowQuanLyTonKho() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Quản lý tồn kho',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        _buildWidgetChangeQuanLyTonKho(),
      ],
    );
  }

  Expanded _buildWidgetChangeQuanLyTonKho() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (controller.edit.value != true)
            controller.saveQuanLyTheoLo(!controller.quanLyTheoLo.value);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 16,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                        color: controller.quanLyTheoLo.value != true
                            ? const Color(0xFFCCCCCC)
                            : const Color(0xFF9AC1EF),
                        border: Border.all(
                            color: controller.quanLyTheoLo.value != true
                                ? const Color(0xFF888888)
                                : const Color(0xFF448DE4)),
                        borderRadius: BorderRadius.circular(13)),
                    height: 16,
                    width: 45,
                  ),
                ),
                Obx(
                  () => (controller.quanLyTheoLo.value != true)
                      ? const Positioned(
                          top: -3,
                          left: -5,
                          child: SizedBox(
                            width: 23,
                            height: 23,
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF888888),
                            ),
                          ),
                        )
                      : const Positioned(
                          top: -3,
                          right: -5,
                          child: SizedBox(
                            width: 23,
                            height: 23,
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF1D67BF),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildRowThuongHieu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Thương hiệu',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildFieldThuongHieu(),
        )
      ],
    );
  }

  Row _builRowLoaiHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Loại hàng',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildFieldLoaiHang(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowMaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mã hàng hoá',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldMaHang(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowTenHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tên hàng hoá',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldTenHang(),
        )
      ],
    );
  }

  Row _buildRowGiaBan() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Giá bán',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildFileGiaBan(),
        )
      ],
    );
  }

  Row _buildRowGiaVon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Giá vốn',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildFieldGiaVon(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowDonViTinh() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Đơn vị tính',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildFieldDonViTinh(),
        )
      ],
    );
  }

  Row _buildRowTonNhieuNhat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tồn nhiều nhất',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(child: _buildFieldTonNhieuNhat())
      ],
    );
  }

  Widget _builFieldMaHang() {
    return TextFormField(
      onSaved: (newValue) {
        controller.hangHoaModel.value =
            controller.hangHoaModel.value.copyWith(maHangHoa: newValue);
      },
      readOnly: controller.edit.value,
      keyboardType: TextInputType.text,
      controller: controller.maHangController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Mã hàng hoá tự động',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _builFieldTenHang() {
    return TextFormField(
      onSaved: (newValue) {
        controller.hangHoaModel.value =
            controller.hangHoaModel.value.copyWith(tenHangHoa: newValue);
      },
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng nhập vào tên hàng';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      controller: controller.tenHangController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Tên hàng hoá',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _buildFieldThuongHieu() {
    return TextFormField(
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng chọn thương hiệu';
        }
        return null;
      },
      readOnly: true,
      controller: controller.thuongHieuController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.navigate_next),
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Chọn thương hiệu',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onTap: () {
        // mở modal chọn thương hiệu
        Get.to(() => ChonThuongHieuScreen());
      },
    );
  }

  Widget _buildFieldLoaiHang() {
    return TextFormField(
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng chọn loại hàng';
        }
        return null;
      },
      readOnly: true,
      controller: controller.loaiHangController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.navigate_next),
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Chọn loại hàng',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onTap: () {
        // mở modal chọn thương hiệu
        Get.to(() => ChonLoaiHangScreen());
      },
    );
  }

  Widget _buildFieldDonViTinh() {
    return TextFormField(
      onSaved: (newValue) {
        controller.hangHoaModel.value =
            controller.hangHoaModel.value.copyWith(donViTinh: newValue);
      },
      keyboardType: TextInputType.text,
      controller: controller.donViTinhController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Kg',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _buildFieldTonNhieuNhat() {
    return TextFormField(
      onSaved: (newValue) {
        var va = newValue.toString().replaceAll(',', '');
        print(va);
        controller.hangHoaModel.value = controller.hangHoaModel.value.copyWith(
            tonNhieuNhat:
                va != '' && va != null ? double.parse(va) : 999999999.99);
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      keyboardType: TextInputType.number,
      controller: controller.tonItNhatController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: '999,999,999',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          controller.tonItNhatController.text = '0';
        }
        int count = value.split('.').length - 1;
        print('đếm');
        print(count);
        if (count > 1) {
          value = value.substring(0, value.length - 1).toString();
        }

        if (double.tryParse(value) != null && !value.endsWith('.')) {
          print('gọi');
          //  print(FunctionHelper.formNum(value));
          controller.tonItNhatController.text = FunctionHelper.formNum(value);
        }
        //controller.text = FunctionHelper.formNum(value);
      },
      onEditingComplete: () {
        //  print('gọi complete');
        controller.tonItNhatController.text =
            controller.tonItNhatController.text.toString().replaceAll(',', '');
        if (double.tryParse(controller.tonItNhatController.text) == null) {
          controller.tonItNhatController.text = '999999999';
        } else {
          controller.tonItNhatController.text =
              FunctionHelper.formNum(controller.tonItNhatController.text);
        }
      },
    );
  }

  Widget _buildFileGiaBan() {
    return TextFormField(
      onSaved: (newValue) {
        var va = newValue.toString().replaceAll(',', '');
        controller.hangHoaModel.value =
            controller.hangHoaModel.value.copyWith(donGiaBan: int.parse(va));
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      validator: (value) {
        // loại bỏ các dấu "," khỏi chuỗi
        var va = value.toString().replaceAll(',', '');
        // sao đó kiểm tra
        if ((va.isEmpty)) {
          return 'Vui lòng nhập giá bán';
        }
        if (double.tryParse(va) == null) {
          return 'Vui lòng nhập vào giá trị số';
        }
        if (double.parse(va) < 0) {
          return 'Giá trị phải lớn hơn hoặc bằng 0';
        }
        return null;
      },
      controller: controller.giaBanController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: '0',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          controller.giaBanController.text = '0';
        }
        if (double.tryParse(value) != null) {
          //  print(FunctionHelper.formNum(value));
          controller.giaBanController.text = FunctionHelper.formNum(value);
        }
        //controller.text = FunctionHelper.formNum(value);
      },
      onEditingComplete: () {
        //  print('gọi complete');
        controller.giaBanController.text =
            controller.giaBanController.text.replaceAll(',', '');

        if (double.tryParse(controller.giaBanController.text) == null) {
          print('giá trị null');
          controller.giaBanController.text = '0';
        } else {
          controller.giaBanController.text =
              FunctionHelper.formNum(controller.giaBanController.text);
        }
      },
    );
  }

  Widget _buildFieldGiaVon() {
    return TextFormField(
      onSaved: (newValue) {
        var va = newValue.toString().replaceAll(',', '');
        controller.hangHoaModel.value =
            controller.hangHoaModel.value.copyWith(giaVon: int.parse(va));
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      validator: (value) {
        // loại bỏ các dấu "," khỏi chuỗi
        var va = value.toString().replaceAll(',', '');
        // sao đó kiểm tra
        if ((va.isEmpty)) {
          return 'Vui lòng nhập giá vốn';
        }
        if (double.tryParse(va) == null) {
          return 'Vui lòng nhập vào giá trị số';
        }
        if (double.parse(va) < 0) {
          return 'Giá trị phải lớn hơn hoặc bằng 0';
        }
        return null;
      },
      controller: controller.giaVonController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: '0',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          controller.giaVonController.text = '0';
        }
        if (double.tryParse(value) != null) {
          //  print(FunctionHelper.formNum(value));
          controller.giaVonController.text = FunctionHelper.formNum(value);
        }
        //controller.text = FunctionHelper.formNum(value);
      },
      onEditingComplete: () {
        //  print('gọi complete');
        controller.giaVonController.text =
            controller.giaVonController.text.toString().replaceAll(',', '');
        if (double.tryParse(controller.giaVonController.text) == null) {
          controller.giaVonController.text = '0';
        } else {
          controller.giaVonController.text =
              FunctionHelper.formNum(controller.giaVonController.text);
        }
      },
    );
  }

  Widget _buildFileMoTa() {
    return TextFormField(
      onSaved: (newValue) {
        controller.hangHoaModel.value = controller.hangHoaModel.value
            .copyWith(moTa: controller.moTaController.text);
      },
      maxLines: null,
      minLines: 4,
      controller: controller.moTaController,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        hintText: 'Mô tả',
        hintStyle: TextStyle(
          color: Color.fromARGB(43, 10, 4, 126),
          fontSize: 14,
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildPickImage(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // gọi
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      Get.back();
                      controller.pickImage(ImageSource.camera);
                      // Get.back();
                    },
                    leading: const Icon(Icons.camera, size: 28),
                    title: const Text(
                      'Chụp ảnh mới',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Divider(
                    color: ColorClass.color_thanh_ke,
                  ),
                  ListTile(
                    onTap: () {
                      Get.back();
                      controller.pickMulImage();
                      //  Get.back();
                    },
                    leading: const Icon(Icons.photo, size: 28),
                    title: const Text(
                      'Thêm từ thư viện',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Divider(
                    color: ColorClass.color_thanh_ke,
                  ),
                ],
              );
            });
      },
      child: const SizedBox(
        height: 90,
        width: 95,
        child: Card(
          color: Color.fromARGB(255, 207, 207, 207),
          child: Center(
              child: Icon(
            Icons.linked_camera,
            size: 50,
            color: Colors.white,
          )),
        ),
      ),
    );
  }

  Container _buildImage(int index) {
    return Container(
      height: 90,
      width: 95,
      child: Card(
          color: const Color.fromARGB(255, 207, 207, 207),
          child: Stack(
            children: [
              Positioned.fill(
                child: ((controller.listImage[index] is XFile) == true)
                    ? Image.file(
                        File(controller.listImage[index].path),
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        controller.listImage[index].linkAnh!,
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                              'assets/images/hang_hoa_mac_dinh.png',
                              fit: BoxFit.contain);
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: const Color.fromARGB(255, 185, 185, 185),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    controller.deleteImage(index);
                  },
                  child: const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(93, 125, 125, 125),
                      child: Center(
                          child: Icon(
                        Icons.close,
                        color: Color.fromARGB(255, 241, 241, 241),
                      )),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
