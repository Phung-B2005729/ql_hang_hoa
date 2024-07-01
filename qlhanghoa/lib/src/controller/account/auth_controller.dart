import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qlhanghoa/src/binding/all_binding.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/auth_token_model.dart';
import 'package:qlhanghoa/src/model/nhan_vien_model.dart';
import 'package:qlhanghoa/src/service/nhan_vien_service.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';
import 'package:qlhanghoa/src/widget/auth/login/login.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class AuthController extends GetxController {
  Rx<String?> uid = Rx<String?>(null);
  Rx<String?> userName = Rx<String?>(null);
  Rx<String?> hoTen = Rx<String?>(null);
  Rx<String?> maCuaHang = Rx<String?>(null);
  Rx<int?> phanQuyen = Rx<int?>(null);
  RxBool? isLogon = false.obs;
  Rx<AuthToken?> auth = AuthToken().obs;
  Rx<NhanVienModel> thongTinCaNhan = NhanVienModel().obs;

  @override
  void onInit() {
    print('gọi init authu');
    super.onInit();
    setUpData();
  }

  Future<void> setUpData() async {
    getIsLogon();
    getUserId();
    getUserName();
    getName();
    getMaCuaHang();
    getPhanQuyen();
    getAuthToken();
    await getThongTinCaNhan();
    update();
  }

  Future<void> getThongTinCaNhan() async {
    if (userName.value != null) {
      Response res = await NhanVienService().getById(id: userName.value!);
      if (res.statusCode == 200) {
        thongTinCaNhan.value = NhanVienModel.fromJson(res.body);
        update();
      } else {
        GetShowSnackBar.warningSnackBar(
          (res.body != null && res.body['message'] != null)
              ? res.body['message']
              : "Lỗi trong quá trình xử lý hoặc kết nối interner không ổn định",
        );
      }
    }
  }

  void getIsLogon() {
    isLogon?.value = AuthUtil.getIsLogon() ?? false;
    update();
  }

  // set logon
  void setLogon(bool bool) {
    isLogon?.value = bool;
    update();
  }

//
  void setAuthToken(String accessToken, String refreshToken) {
    auth.value = auth.value
        ?.copyWith(accessToken: accessToken, refreshToken: refreshToken);
    update();
  }

  void getAuthToken() async {
    dynamic accessToken = AuthUtil.getAccessToken();
    dynamic refreshToken = AuthUtil.getRefreshToken();
    auth.value = auth.value
        ?.copyWith(accessToken: accessToken, refreshToken: refreshToken);
    update();
  }

  void setName(String name) {
    hoTen.value = name;
    update();
  }

  void getName() {
    hoTen.value = AuthUtil.getName();
    update();
  }

  void setUserName(String username) {
    userName.value = username;
    update();
  }

  void getUserName() {
    userName.value = AuthUtil.getUserName();
    update();
  }

  void setPhanQuyen(int quyen) {
    phanQuyen.value = quyen;
    update();
  }

  void getPhanQuyen() {
    phanQuyen.value = AuthUtil.getQuyen();
    update();
  }

  void setUserId(String id) {
    uid.value = id;
    update();
  }

  void getUserId() {
    uid.value = AuthUtil.getUserId();
    update();
  }

  void setMaCuaHang(String maCH) {
    maCuaHang.value = maCH;
    update();
  }

  void getMaCuaHang() {
    print('gọi get auth mã cửa hàng');
    maCuaHang.value = AuthUtil.getMaCuaHang();
    print(maCuaHang.value);
    update();
  }

  void logout() async {
    print('gọi out');
    setUpData();
    await Hive.box(AppConfig.storageBox).clear();
    AllBinding().onDelete();
    Get.offAll(() => const Login());
  }
}
