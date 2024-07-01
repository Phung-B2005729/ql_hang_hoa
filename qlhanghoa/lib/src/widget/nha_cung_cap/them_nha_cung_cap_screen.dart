import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:qlhanghoa/src/controller/nha_cung_cap/nha_cung_cap_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/helper/validate_helper.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ThemNhaCungCapScreen extends StatelessWidget {
  bool? themPhieuNhap;
  bool? edit;
  NhaCungCapController controller = Get.find();

  ThemNhaCungCapScreen({super.key, this.themPhieuNhap, this.edit});

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
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowMaNhaCungCap(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowTenNhaCungCap(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowSDTNhaCungCap(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowEmailNhaCungCap(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowDiaChiNhaCungCap(),
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
                    child: __buildFileGhiChu(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => controller.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 3,
      title: GetBuilder<NhaCungCapController>(
        builder: (controller) => Text(
          edit == true
              ? controller.nhaCungCapModel.value.maNhaCungCap.toString()
              : 'Thêm nhà cung cấp',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      leading: IconButton(
          onPressed: () {
            // chuyển về trang NCC
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
              bool ktr = false;
              if (edit == true) {
                ktr = await controller.updateNCC();
                if (ktr == true) {
                  // xử lý thêm  NCC
                  Get.back();
                  GetShowSnackBar.successSnackBar('Đã cập nhật');
                }
              } else {
                ktr = await controller.createNCC();
                if (ktr == true) {
                  // xử lý thêm  NCC
                  Get.back();
                  GetShowSnackBar.successSnackBar('Đã thêm');
                }
              }
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
            Get.back();
            Get.back();
          },
        ),
      ],
    );
  }

  Row _buildRowEmailNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Email',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildFieldEmailNhaCungCap(),
        )
      ],
    );
  }

  Row _buildRowSDTNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Số điện thoại',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldSDTNhaCungCap(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowMaNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mã NCC',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldMaNhaCungCap(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowTenNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tên NCC',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldTenNhaCungCap(),
        )
      ],
    );
  }

  Row _buildRowDiaChiNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Địa chỉ',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldDiaChiNhaCungCap(),
        )
      ],
    );
  }

  Widget _builFieldMaNhaCungCap() {
    return TextFormField(
      onSaved: (newValue) {
        controller.nhaCungCapModel.value =
            controller.nhaCungCapModel.value.copyWith(maNhaCungCap: newValue);
      },
      readOnly: edit ?? false,
      keyboardType: TextInputType.text,
      controller: controller.maNhaCungCapController,
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
        hintText: 'Mã NCC tự động',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _builFieldTenNhaCungCap() {
    return TextFormField(
      onSaved: (newValue) {
        controller.nhaCungCapModel.value =
            controller.nhaCungCapModel.value.copyWith(tenNhaCungCap: newValue);
      },
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng nhập vào tên ncc';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      controller: controller.tenNhaCungCapController,
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
        hintText: 'Tên NCC',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _buildFieldEmailNhaCungCap() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        if (!ValidateHelper.isValidEmail(value)) {
          return 'Email không hợp lệ';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) {
        controller.nhaCungCapModel.value =
            controller.nhaCungCapModel.value.copyWith(email: newValue);
      },
      controller: controller.emailNhaCungCapController,
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
        hintText: 'Nhập email',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _builFieldSDTNhaCungCap() {
    return TextFormField(
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng nhập vào số điện thoại';
        }
        if (!ValidateHelper.isValidPhoneNumber(value)) {
          return 'Số điện thoại không hợp lệ';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      onSaved: (newValue) {
        controller.nhaCungCapModel.value =
            controller.nhaCungCapModel.value.copyWith(sdt: newValue);
      },
      controller: controller.sdtNhaCungCapController,
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
        hintText: 'Nhập số điện thoại',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _builFieldDiaChiNhaCungCap() {
    return TextFormField(
      onSaved: (newValue) {
        controller.nhaCungCapModel.value =
            controller.nhaCungCapModel.value.copyWith(diaChi: newValue);
      },
      maxLines: null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập vào địa chỉ';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      controller: controller.diaChiNhaCungCapController,
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
        hintText: 'Nhập địa chỉ',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget __buildFileGhiChu() {
    return TextFormField(
      onSaved: (newValue) {
        controller.nhaCungCapModel.value =
            controller.nhaCungCapModel.value.copyWith(ghiChu: newValue);
      },
      maxLines: null,
      minLines: 4,
      controller: controller.ghiChuCungCapController,
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
        hintText: 'Ghi chú',
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
}
