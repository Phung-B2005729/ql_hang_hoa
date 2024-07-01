import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/helper/validate_helper.dart';
import 'package:qlhanghoa/src/widget/nhan_vien/chon_cua_hang.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ThemNhanVienScreen extends StatelessWidget {
  bool? edit;
  NhanVienController controller = Get.find();

  ThemNhanVienScreen({super.key, this.edit});

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
                        _buildRowMaNhanVien(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowTenNhanVien(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowGioiTinhNhanVien(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowSDTNhanVien(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildEmailNhanVien(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowDiaChiNhanVien(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowCuaHangNhanVien(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowChucVuNhanVien()
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
      title: GetBuilder<NhanVienController>(
        builder: (controller) => Text(
          edit == true
              ? controller.nhanVienModel.value.maNhanVien.toString()
              : 'Thêm nhân viên',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      leading: IconButton(
          onPressed: () {
            // chuyển về trang NV
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
                ktr = await controller.updateNhanVien();
                if (ktr == true) {
                  // xử lý thêm  NV
                  Get.back();
                  GetShowSnackBar.successSnackBar('Đã cập nhật');
                }
              } else {
                ktr = await controller.createNhanVien();
                if (ktr == true) {
                  CuaHangController cuaHangController = Get.find();
                  cuaHangController.reSetTimKiem();
                  // xử lý thêm  NV
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
            CuaHangController cuaHangController = Get.find();

            cuaHangController.reSetTimKiem();
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

  Row _buildEmailNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Email NV',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: __buildFileEmailNhanVien(),
        )
      ],
    );
  }

  Row _buildRowSDTNhanVien() {
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
          child: _builFieldSDTNhanVien(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowMaNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mã NV',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldMaNhanVien(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowTenNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tên NV',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldTenNhanVien(),
        )
      ],
    );
  }

  Row _buildRowDiaChiNhanVien() {
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
          child: _builFieldDiaChiNhanVien(),
        )
      ],
    );
  }

  Row _buildRowChucVuNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Chức vụ',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 100,
        ),
        Expanded(child: __buildFileChucVuNhanVien())
      ],
    );
  }

  Row _buildRowGioiTinhNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Giới tính',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.changeGioiTinh(true);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Màu của viền
                              width: 2.0, // Độ rộng của viền
                            ),
                          ),
                          child: GetBuilder<NhanVienController>(
                            builder: (controller) => CircleAvatar(
                              backgroundColor:
                                  (controller.nhanVienModel.value.gioiTinh ==
                                          true)
                                      ? ColorClass.color_xanh_it_dam
                                      : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Nam',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.changeGioiTinh(false);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Màu của viền
                              width: 2.0, // Độ rộng của viền
                            ),
                          ),
                          child: GetBuilder<NhanVienController>(
                            builder: (controller) => CircleAvatar(
                              backgroundColor:
                                  (controller.nhanVienModel.value.gioiTinh !=
                                          true)
                                      ? ColorClass.color_xanh_it_dam
                                      : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Nữ',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _builFieldMaNhanVien() {
    return TextFormField(
      onSaved: (newValue) {
        controller.nhanVienModel.value =
            controller.nhanVienModel.value.copyWith(maNhanVien: newValue);
      },
      readOnly: edit ?? false,
      keyboardType: TextInputType.text,
      controller: controller.maNhanVienController,
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
        hintText: 'Mã NV tự động',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _builFieldTenNhanVien() {
    return TextFormField(
      onSaved: (newValue) {
        controller.nhanVienModel.value =
            controller.nhanVienModel.value.copyWith(tenNhanVien: newValue);
      },
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng nhập vào tên NV';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      controller: controller.tenNhanVienController,
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
        hintText: 'Tên NV',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget __buildFileEmailNhanVien() {
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
        controller.nhanVienModel.value =
            controller.nhanVienModel.value.copyWith(email: newValue);
      },
      controller: controller.emailNhanVienController,
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

  // ignore: unused_element
  Widget __buildFileChucVuNhanVien() {
    return GetBuilder<NhanVienController>(
        builder: (NhanVienController) => DropdownButton<String>(
              value: NhanVienController.nhanVienModel.value.chucVu != null
                  ? NhanVienController.nhanVienModel.value.chucVu.toString()
                  : 'Nhân viên',
              items: const [
                DropdownMenuItem<String>(
                  value: 'Chủ cửa hàng',
                  child: Text('Chủ cửa hàng',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                ),
                DropdownMenuItem<String>(
                  value: 'Quản lý',
                  child: Text('Quản lý',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                ),
                DropdownMenuItem<String>(
                  value: 'Nhân viên',
                  child: Text('Nhân viên',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                ),
              ],
              onChanged: (dynamic newValue) {
                if (newValue != null) {
                  NhanVienController.changeChucVu(newValue);
                }
              },
            ));
  }

  Widget _builFieldSDTNhanVien() {
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
        controller.nhanVienModel.value =
            controller.nhanVienModel.value.copyWith(sdt: newValue);
      },
      controller: controller.sdtNhanVienController,
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

  Widget _builFieldDiaChiNhanVien() {
    return TextFormField(
      onSaved: (newValue) {
        controller.nhanVienModel.value =
            controller.nhanVienModel.value.copyWith(diaChi: newValue);
      },
      maxLines: null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập vào địa chỉ';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      controller: controller.diaChiNhanVienController,
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
        controller.nhanVienModel.value =
            controller.nhanVienModel.value.copyWith(ghiChu: newValue);
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

  Row _buildRowCuaHangNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Thuộc chi nhánh',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              ListTile(
                onTap: () {
                  // chuyển qua chọn cửa hàng

                  Get.to(() => ChonCuaHangScreen());
                },
                trailing: const Icon(
                  Icons.navigate_next,
                  size: 28,
                ),
                title: GetBuilder<NhanVienController>(
                  builder: (controller) => Text(
                    (controller.nhanVienModel.value.cuaHang != null &&
                            controller
                                    .nhanVienModel.value.cuaHang!.tenCuaHang !=
                                null)
                        ? controller.nhanVienModel.value.cuaHang!.tenCuaHang
                            .toString()
                        : 'Chọn cửa hàng',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }
}
