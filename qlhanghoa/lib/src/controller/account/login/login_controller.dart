import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/model/auth_token_model.dart';
import 'package:qlhanghoa/src/service/auth_service.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/home.dart';
import 'package:qlhanghoa/src/widget/shared/error_dialog.dart';

// xử lý các biến thay đổi trong widget login
class LoginController extends GetxController {
  // form
  final loginFormKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameFocus = FocusNode();
  final passwordFocus = FocusNode();

  RxBool loading = false.obs;
  RxBool showPassword = false.obs;

  // mở nút đăng nhập
  RxBool enableLoginButton = false.obs;

  RxBool isUsernameFocused = false.obs;
  RxBool isPasswordFocused = false.obs;
  bool loggon = false;

  @override
  void onInit() {
    print('gọi init');
    super.onInit();
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    userNameFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }

// check Focus
  void checkFoCus() {
    print('gọi ontap');
    userNameFocus.addListener(() {
      isUsernameFocused.value = userNameFocus.hasFocus;
    });
    passwordFocus.addListener(() {
      isPasswordFocused.value = passwordFocus.hasFocus;
    });
  }

  void checkEnableLoginButton() {
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      // không rỗng
      print('mớ nút');
      enableLoginButton.value = true;
    } else {
      print('khoá nút');
      enableLoginButton.value = false;
    }
  }

  void setShowPassword(bool value) {
    showPassword.value = value;
  }

  void goToResetPassword() {}

  Future<void> login() async {
    final state = loginFormKey.currentState;
    if (state != null && state.validate()) {
      print('gọi login');
      loading.value = true;
      print('xử lý login');
      //gọi api login
      Response res = await AuthService()
          .logIn(userNameController.text, passwordController.text);
      if (res.statusCode == 200) {
        // đăng nhập thahf công
        AuthToken auth = await AuthToken.fromJson(res.body);

        //và lấy thông tin user
        Response res_user =
            await AuthService().getInfoUser(accessToken: auth.accessToken!);
        if (res_user.statusCode == 200) {
          // lưu token, refresh
          await AuthUtil.setAccessToken(auth.accessToken!, auth.refreshToken);
          await AuthUtil.setName(res_user.body['ho_ten']);
          await AuthUtil.setUserId(res_user.body['tai_khoan']["_id"]);
          await AuthUtil.setQuyen(res_user.body['tai_khoan']["phan_quyen"]);
          await AuthUtil.setUserName(res_user.body['tai_khoan']["user_name"]);
          print(res_user.body['ma_cua_hang']);
          await AuthUtil.setMaCuaHang(res_user.body['ma_cua_hang'] ?? '');
          // lưu

          await AuthUtil.setIsLogon(true);
          // lưu vào userController
          AuthController controller = Get.find();

          controller.setUpData();
          Get.off(() => Home());
        } else {
          Get.dialog(
              ErrorDialog(
                callback: () {},
                message: "User không tồn tại",
              ),
              barrierDismissible: false);
        }
      } else if (res.statusCode == 500) {
        print('lỗi server');
        Get.dialog(
            ErrorDialog(
              callback: () {},
              message:
                  "Lỗi trong quá trình xử lý hoặc kết nối interner không ổn định",
            ),
            barrierDismissible: false);
      } else {
        Get.dialog(
            ErrorDialog(
              callback: () {},
              message: (res.body != null && res.body['message'] != null)
                  ? res.body['message']
                  : "Lỗi trong quá trình xử lý hoặc kết nối interner không ổn định",
            ),
            // barrierDismissible có cho phép đóng hợp thoại bằng cách chạm ra ngoài hay không ?
            barrierDismissible: false);
      }

      loading.value = false;

      // gọi login từ auth_controller
      // gọi api login
      // lấy token lưu vào
      // lưu biến isLogin = true;
      // lấy thông tin user đăng nhập lưu vào
    }
  }
}
