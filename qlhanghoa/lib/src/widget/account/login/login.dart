import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/login/login_controller.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

class Login extends GetView<LoginController> {
  // final LoginController controller = Get.find(); có thể dùng thay bằng GetView<> gắn liên kết với 1 controller nhất định mà không cần gọi nó
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Form(
                key: controller.loginFormKey,
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 5.0),
                    child: Column(
                      children: [
                        // logo
                        Image.asset("assets/logo/logo_thu_y_x2.png"),
                        Container(
                          width: 203,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE49554),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              'VETERINARY STORE',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF070269)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        _buildUsername(context),
                        const SizedBox(
                          height: 32,
                        ),
                        _buildPasswordInput(context),
                        const SizedBox(
                          height: 30,
                        ),
                        const Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Quên mật khẩu ?',
                            style: TextStyle(
                              color: ColorClass.color_title_large,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        _buttonLogin(),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 120,
                          height: 55,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image.asset(
                                  "assets/logo/logo_xanh_vang_x2.png",
                                  height: 28,
                                  width: 30,
                                ),
                              ),
                              const Text(
                                'ArCH - TP',
                                style: TextStyle(
                                    color: ColorClass.color_title_large,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Obx(() => controller.loading.value
                ? const LoadingCircularFullScreen()
                : const SizedBox())
          ],
        ),
      ),
    );
  }

  Obx _buttonLogin() {
    return Obx(
      () => ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 198, minHeight: 48),
        // ignore: sort_child_properties_last
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: controller.enableLoginButton.value
                  ? MaterialStateProperty.all(ColorClass.color_button)
                  : MaterialStateProperty.all(Colors.grey),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(31),
              ))),
          // ignore: sort_child_properties_last
          child: const Text('ĐĂNG NHẬP',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          onPressed: (controller.enableLoginButton.value)
              ? () => controller.login()
              : null,
        ),
      ),
    );
  }

  Obx _buildUsername(BuildContext context) {
    return Obx(
      () => TextFormField(
          focusNode: controller.userNameFocus,
          style: const TextStyle(color: Colors.black),
          cursorColor: ColorClass.color_button,
          controller: controller.userNameController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person),
            errorStyle: const TextStyle(fontSize: 12),
            prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused)
                    ? ColorClass.color_button
                    : Colors.grey),
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorClass.color_button, width: 1.2),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            labelText: 'Tên đăng nhập',
            labelStyle: TextStyle(
                color: controller.isUsernameFocused.value
                    ? ColorClass.color_button
                    : const Color.fromARGB(43, 10, 4, 126),
                fontSize: 14),
          ),
          onChanged: (value) {
            // print('gọi');
            controller.checkEnableLoginButton();
          },
          onTap: () {
            controller.checkFoCus();
          }),
    );
  }

  Obx _buildPasswordInput(BuildContext context) {
    return Obx(() => TextFormField(
          focusNode: controller.passwordFocus,
          style: const TextStyle(color: Colors.black),
          cursorColor: ColorClass.color_button,
          controller: controller.passwordController,
          obscureText: !controller.showPassword.value,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              errorStyle: const TextStyle(fontSize: 12),
              prefixIconColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.focused)
                      ? ColorClass.color_button
                      : Colors.grey),
              focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: ColorClass.color_button, width: 1.2),
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              labelText: 'Mật khẩu',
              labelStyle: TextStyle(
                  color: controller.isPasswordFocused.value
                      ? ColorClass.color_button
                      : Colors.grey,
                  fontSize: 14),
              suffixIcon: IconButton(
                icon: Icon(controller.showPassword.value
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  controller.setShowPassword(!controller.showPassword.value);
                },
              ),
              suffixIconColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.focused)
                      ? ColorClass.color_button
                      : Colors.grey)),
          onChanged: (value) {
            // print('gọi');
            controller.checkEnableLoginButton();
          },
          onTap: () {
            controller.checkFoCus();
          },
        ));
  }
}
