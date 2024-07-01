// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/tai_khoan_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';

import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class CapMatKhauMoiScreen extends StatelessWidget {
  TaiKhoanController controller = Get.find();

  CapMatKhauMoiScreen({super.key});

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
                        _buildRowMatKhauCu(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowMatKhau(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowMatKhauNhapLai(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRowMatKhauAdmin(),
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
        builder: (controller) => Text(
          controller.taiKhoanModel.value.userName!,
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
              // ignore: unused_local_variable
              bool ktr = await controller.adminChangePass();
              if (ktr == true) {
                Get.back();
                GetShowSnackBar.successSnackBar('Thành công');
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

  // ignore: unused_element

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

  Row _buildRowMatKhauCu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            'Mật khẩu Củ',
            softWrap: true,
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: _builFieldMatKhauCu(),
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

  Row _buildRowMatKhauAdmin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            'Mật khẩu admin',
            softWrap: true,
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: _builFieldMatKhauAdmin(),
        )
      ],
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

  Widget _builFieldMatKhauCu() {
    return Obx(
      () => TextFormField(
        onSaved: (newValue) {
          controller.taiKhoanModel.value =
              controller.taiKhoanModel.value.copyWith(oldPassword: newValue);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập vào mật khẩu củ';
          }

          return null;
        },
        obscureText: !controller.showOldPassword.value,
        controller: controller.oldPasswordController,
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
            hintText: 'Nhập mật khẩu củ',
            hintStyle: const TextStyle(
                color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
            suffixIcon: IconButton(
              icon: Icon(controller.showOldPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                controller.showOldPassword.value =
                    !controller.showOldPassword.value;
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

  Widget _builFieldMatKhauAdmin() {
    return Obx(
      () => TextFormField(
        onSaved: (newValue) {
          controller.taiKhoanModel.value =
              controller.taiKhoanModel.value.copyWith(adminPassword: newValue);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập vào mật khẩu admin';
          }

          return null;
        },
        obscureText: !controller.showAdminPassword.value,
        controller: controller.adminPasswordController,
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
            hintText: 'Xác nhận mật khẩu admin',
            hintStyle: const TextStyle(
                color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
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
                    : Colors.grey)),
      ),
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
}
