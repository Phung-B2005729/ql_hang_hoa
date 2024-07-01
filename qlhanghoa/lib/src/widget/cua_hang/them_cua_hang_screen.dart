import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/helper/validate_helper.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ThemCuaHangScreen extends StatelessWidget {
  bool? edit;
  CuaHangController controller = Get.find();

  ThemCuaHangScreen({super.key, this.edit});

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
                        _buildRowMaCuaHang(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowTenCuaHang(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowSDTCuaHang(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowLoaiCuaHang(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowDiaChiCuaHang(),
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
      title: GetBuilder<CuaHangController>(
        builder: (controller) => Text(
          edit == true
              ? controller.cuaHangModel.value.maCuaHang.toString()
              : 'Thêm chi nhánh',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      leading: IconButton(
          onPressed: () {
            // chuyển về trang CN
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
                ktr = await controller.updateCuaHang();
                if (ktr == true) {
                  // xử lý thêm  CN
                  Get.back();
                  GetShowSnackBar.successSnackBar('Đã cập nhật');
                }
              } else {
                ktr = await controller.createCuaHang();
                if (ktr == true) {
                  // xử lý thêm  CN
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
            if (edit == true) {
              controller.reSetDataChiTiet();
            }
            Get.back();
            Get.back();
          },
        ),
      ],
    );
  }

  Row _buildRowLoaiCuaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Loại CN',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildFieldLoaiCuaHang(),
        )
      ],
    );
  }

  Row _buildRowSDTCuaHang() {
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
          child: _builFieldSDTCuaHang(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowMaCuaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mã CN',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldMaCuaHang(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowTenCuaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tên CN',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldTenCuaHang(),
        )
      ],
    );
  }

  Row _buildRowDiaChiCuaHang() {
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
          child: _builFieldDiaChiCuaHang(),
        )
      ],
    );
  }

  Widget _builFieldMaCuaHang() {
    return TextFormField(
      onSaved: (newValue) {
        controller.cuaHangModel.value =
            controller.cuaHangModel.value.copyWith(maCuaHang: newValue);
      },
      readOnly: edit ?? false,
      keyboardType: TextInputType.text,
      controller: controller.maCuaHangController,
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
        hintText: 'Mã CN tự động',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _builFieldTenCuaHang() {
    return TextFormField(
      onSaved: (newValue) {
        controller.cuaHangModel.value =
            controller.cuaHangModel.value.copyWith(tenCuaHang: newValue);
      },
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng nhập vào tên CN';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      controller: controller.tenCuaHangController,
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
        hintText: 'Tên CN',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _buildFieldLoaiCuaHang() {
    return GetBuilder<CuaHangController>(
        builder: (cuaHangController) => DropdownButton<String>(
              value: cuaHangController.cuaHangModel.value.loaiCuaHang != null
                  ? cuaHangController.cuaHangModel.value.loaiCuaHang.toString()
                  : 'Chi nhánh',
              items: const [
                DropdownMenuItem<String>(
                  value: 'Trung tâm',
                  child: Text('Trung tâm',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                ),
                DropdownMenuItem<String>(
                  value: 'Chi nhánh',
                  child: Text('Chi nhánh',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                ),
              ],
              onChanged: (dynamic newValue) {
                if (newValue != null) {
                  cuaHangController.changeLoaiChiNhanh(newValue);
                }
              },
            ));
  }

  Widget _builFieldSDTCuaHang() {
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
        controller.cuaHangModel.value =
            controller.cuaHangModel.value.copyWith(sdt: newValue);
      },
      controller: controller.sdtCuaHangController,
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

  Widget _builFieldDiaChiCuaHang() {
    return TextFormField(
      onSaved: (newValue) {
        controller.cuaHangModel.value =
            controller.cuaHangModel.value.copyWith(diaChi: newValue);
      },
      maxLines: null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập vào địa chỉ';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      controller: controller.diaChiCuaHangController,
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
        controller.cuaHangModel.value =
            controller.cuaHangModel.value.copyWith(ghiChu: newValue);
      },
      maxLines: null,
      minLines: 4,
      controller: controller.ghiChuController,
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
