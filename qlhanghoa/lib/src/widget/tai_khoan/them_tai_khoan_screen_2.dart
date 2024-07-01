// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/tai_khoan_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/helper/validate_helper.dart';
import 'package:qlhanghoa/src/model/nhan_vien_model.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ThemTaiKhoanScreen2 extends StatelessWidget {
  TaiKhoanController controller = Get.find();
  final bool? themTuNhanVien;

  ThemTaiKhoanScreen2({super.key, this.themTuNhanVien});

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
                        _buildRowUserName(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowHoTen(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowSDT(),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRowChucVu(),
                        const SizedBox(
                          height: 10,
                        ),
                        if (themTuNhanVien == true)
                          const Divider(
                            color: ColorClass.color_thanh_ke,
                          ),
                        _buildRowMatKhau(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowMatKhauNhapLai(),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRowQuyenTaiKhoan()
                      ],
                    ),
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
      title: GetBuilder<TaiKhoanController>(
        builder: (controller) => const Text(
          'Thêm tài khoản',
          style: TextStyle(
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
              // ignore: unused_local_variable
              bool ktr = false;
              if (controller.formKey.currentState!.validate()) {
                Get.dialog(_AletDiaLogNhapPassAdmin());
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
            controller.reSetThem();
            Get.back();
            Get.back();
          },
        ),
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowQuyenTaiKhoan() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            'Quyền tài khoản',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildFileQuyenTaiKhoan(),
        )
      ],
    );
  }

  Row _buildRowChucVu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            'Chức vụ',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        (themTuNhanVien != true)
            ? Expanded(
                flex: 2,
                child: _buildFileChucVu(),
              )
            : Expanded(
                flex: 2,
                child: Text(
                  controller.chucVuController.value,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              )
      ],
    );
  }

  Row _buildRowSDT() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Số điện thoại',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: _builFieldSDT(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowUserName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'UserName',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldUserName(),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowHoTen() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Họ tên',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldHoTen(),
        )
      ],
    );
  }

  Row _buildRowMatKhau() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mật khẩu',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _builFieldMatKhau(),
        )
      ],
    );
  }

  Row _buildRowMatKhauNhapLai() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            'Mật khẩu xác nhận',
            softWrap: true,
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: _builFieldMatKhauNhapLai(),
        )
      ],
    );
  }

  Widget _builFieldUserName() {
    return TextFormField(
      onSaved: (newValue) {
        controller.taiKhoanModel.value =
            controller.taiKhoanModel.value.copyWith(userName: newValue);
      },
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng nhập vào username';
        }
        return null;
      },
      readOnly: themTuNhanVien ?? false,
      keyboardType: TextInputType.text,
      controller: controller.userNamController,
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
        hintText: 'Nhập vào username',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _builFieldHoTen() {
    return TextFormField(
      onSaved: (newValue) {
        controller.taiKhoanModel.value.nhanVien ??= NhanVienModel();
        controller.taiKhoanModel.value.nhanVien!.tenNhanVien = newValue;
      },
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Vui lòng nhập vào họ tên';
        }
        return null;
      },
      readOnly: themTuNhanVien ?? false,
      keyboardType: TextInputType.text,
      controller: controller.hoTenController,
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
        hintText: 'Nhập họ tên',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _buildFileQuyenTaiKhoan() {
    return GetBuilder<TaiKhoanController>(
      builder: (controller) => DropdownButton<int>(
        // ignore: unnecessary_null_comparison, prefer_if_null_operators
        value: controller.phanQuyenController.value != null
            ? controller.phanQuyenController.value
            : 1,
        items: const [
          DropdownMenuItem<int>(
            value: 0,
            child: Text(
              'Admin',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          DropdownMenuItem<int>(
            value: 1,
            child: Text(
              'Nhân viên',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
        onChanged: (int? newValue) {
          if (newValue != null) {
            controller.changePhanQuyenThem(newValue);
          }
        },
      ),
    );
  }

  Widget _buildFileChucVu() {
    return GetBuilder<TaiKhoanController>(
      builder: (controller) => DropdownButton<String>(
        // ignore: unnecessary_null_comparison, prefer_if_null_operators
        value: controller.chucVuController.value != null
            ? controller.chucVuController.value
            : 'Nhân viên',
        items: const [
          DropdownMenuItem<String>(
            value: 'Chủ cửa hàng',
            child: Text(
              'Chủ cửa hàng',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Quản lý',
            child: Text(
              'Quản lý',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Nhân viên',
            child: Text(
              'Nhân viên',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.chucVuController.value = newValue;
          }
        },
      ),
    );
  }

  Widget _builFieldSDT() {
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
      readOnly: themTuNhanVien ?? false,
      keyboardType: TextInputType.number,
      onSaved: (newValue) {
        controller.taiKhoanModel.value.nhanVien ??= NhanVienModel();
        controller.taiKhoanModel.value.nhanVien!.sdt = newValue;
      },
      controller: controller.sdtController,
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

  Widget _builFieldMatKhau() {
    return Obx(
      () => TextFormField(
        onSaved: (newValue) {
          controller.taiKhoanModel.value =
              controller.taiKhoanModel.value.copyWith(password: newValue);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập vào mật khẩu';
          }
          if (value.length < 8) {
            return 'Mật khẩu ít nhất 8 kí tự';
          }
          return null;
        },
        obscureText: !controller.showPassword.value,
        controller: controller.passwordController,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 12),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: ColorClass.color_button, width: 1.2),
            ),
            border: const UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            hintText: 'Nhập mật khẩu',
            hintStyle: const TextStyle(
                color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
            suffixIcon: IconButton(
              icon: Icon(controller.showPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                controller.showPassword.value = !controller.showPassword.value;
              },
            ),
            suffixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused)
                    ? ColorClass.color_button
                    : Colors.grey)),
      ),
    );
  }

  Widget _builFieldMatKhauNhapLai() {
    return Obx(
      () => TextFormField(
        onSaved: (newValue) {
          controller.taiKhoanModel.value = controller.taiKhoanModel.value
              .copyWith(confirmPassword: newValue);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập vào mật khẩu xác nhận';
          }
          if (value != controller.passwordController.text &&
              // ignore: unnecessary_null_comparison
              controller.passwordController.text != null &&
              controller.passwordController.text.isNotEmpty) {
            return 'Mật khẩu xác nhận không chính xác';
          }
          return null;
        },
        obscureText: !controller.showConfirmPassword.value,
        controller: controller.confirmPasswordController,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 12),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: ColorClass.color_button, width: 1.2),
            ),
            border: const UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            hintText: 'Xác nhận lại mật khẩu',
            hintStyle: const TextStyle(
                color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
            suffixIcon: IconButton(
              icon: Icon(controller.showConfirmPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                controller.showConfirmPassword.value =
                    !controller.showConfirmPassword.value;
              },
            ),
            suffixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused)
                    ? ColorClass.color_button
                    : Colors.grey)),
      ),
    );
  }

  Widget _AletDiaLogNhapPassAdmin() {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        title: const Text(
          'Xác nhận lại mật khẩu admin',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        content: Form(
          key: controller.formKeyAdmin,
          child: Obx(
            () => TextFormField(
              controller: controller.adminPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập vào mật khẩu admin';
                }
                return null;
              },
              onSaved: (newValue) {
                controller.taiKhoanModel.value.adminPassword = newValue;
              },
              obscureText: !controller.showAdminPassword.value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorClass.color_button_nhat, width: 1),
                ),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.black,
                )),
                hintText: 'Nhập vào mật khẩu admin',
                hintStyle: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 170, 170, 170)),
                suffixIcon: IconButton(
                  icon: Icon(controller.showAdminPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    controller.showAdminPassword.value =
                        !controller.showAdminPassword.value;
                  },
                ),
                suffixIconColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.focused)
                        ? ColorClass.color_button
                        : Colors.grey),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'THOÁT',
              style: TextStyle(color: ColorClass.color_cancel, fontSize: 18),
            ),
            onPressed: () {
              controller.adminPasswordController.text = '';
              Get.back();
            },
          ),
          TextButton(
            child: const Text(
              'Hoàn thành',
              style:
                  TextStyle(color: ColorClass.color_button_nhat, fontSize: 18),
            ),
            onPressed: () async {
              bool ktr = await controller.createTaiKhoan(
                  themTuNhanVien: themTuNhanVien);
              if (ktr == true) {
                Get.back();
                Get.back();
                GetShowSnackBar.successSnackBar('Thành công');
              }
            },
          ),
        ]);
  }
}
