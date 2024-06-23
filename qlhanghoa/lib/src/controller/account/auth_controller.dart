import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/controller/account/login/login_controller.dart';
import 'package:qlhanghoa/src/model/auth_token_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/account/login/login.dart';

class AuthController extends GetxController {
  Rx<String?> uid = Rx<String?>(null);
  Rx<String?> userName = Rx<String?>(null);
  Rx<String?> hoTen = Rx<String?>(null);
  Rx<String?> maCuaHang = Rx<String?>(null);
  Rx<int?> phanQuyen = Rx<int?>(null);
  RxBool? isLogon = false.obs;
  Rx<AuthToken?> auth = AuthToken().obs;

  @override
  void onInit() {
    print('gọi init authu');
    super.onInit();
    setUpData();
  }

  void setUpData() {
    getIsLogon();
    getUserId();
    getUserName();
    getName();
    getMaCuaHang();
    getPhanQuyen();
    getAuthToken();
  }

  void getIsLogon() {
    isLogon?.value = AuthUtil.getIsLogon() ?? false;
  }

  // set logon
  void setLogon(bool bool) {
    isLogon?.value = bool;
  }

//
  void setAuthToken(String accessToken, String refreshToken) {
    auth.value = auth.value
        ?.copyWith(accessToken: accessToken, refreshToken: refreshToken);
  }

  void getAuthToken() async {
    dynamic accessToken = AuthUtil.getAccessToken();
    dynamic refreshToken = AuthUtil.getRefreshToken();
    auth.value = auth.value
        ?.copyWith(accessToken: accessToken, refreshToken: refreshToken);
  }

  void setName(String name) {
    hoTen.value = name;
  }

  void getName() {
    hoTen.value = AuthUtil.getName();
  }

  void setUserName(String username) {
    userName.value = username;
  }

  void getUserName() {
    userName.value = AuthUtil.getUserName();
  }

  void setPhanQuyen(int quyen) {
    phanQuyen.value = quyen;
  }

  void getPhanQuyen() {
    phanQuyen.value = AuthUtil.getQuyen();
  }

  void setUserId(String id) {
    uid.value = id;
  }

  void getUserId() {
    uid.value = AuthUtil.getUserId();
  }

  void setMaCuaHang(String maCH) {
    maCuaHang.value = maCH;
  }

  void getMaCuaHang() {
    print('gọi get auth mã cửa hàng');
    maCuaHang.value = AuthUtil.getMaCuaHang();
    print(maCuaHang.value);
  }

  void logout() async {
    print('gọi out');
    await Get.delete<LoginController>();
    Get.offAll(() => Login());
    await Hive.box(AppConfig.storageBox).clear();
    setUpData();
  }
}
