import 'package:hive/hive.dart';
import 'package:qlhanghoa/src/config/app_config.dart';

class AuthUtil {
  //logon
  static Future<void> setIsLogon(bool login) async {
    await Hive.box(AppConfig.storageBox).put('isLogon', login);
  }

  static bool? getIsLogon() {
    return Hive.box(AppConfig.storageBox).get('isLogon') ?? false;
  }

  //token
  static Future<void> setAccessToken(
      String accessToken, String? refreshToken) async {
    await Hive.box(AppConfig.storageBox).put('access_token', accessToken);
    if (refreshToken != null) {
      await setRefeshToken(refreshToken);
    }
  }

  static Future<void> setRefeshToken(String refreshToken) async {
    await Hive.box(AppConfig.storageBox).put('refresh_token', refreshToken);
  }

  static String? getAccessToken() {
    return Hive.box(AppConfig.storageBox).get('access_token');
  }

  static String? getRefreshToken() {
    return Hive.box(AppConfig.storageBox).get('refresh_token');
  }

  // userInfo
  static Future<void> setUserId(String uid) async {
    await Hive.box(AppConfig.storageBox).put('user_id', uid);
  }

  static String? getUserId() {
    return Hive.box(AppConfig.storageBox).get('user_id');
  }

  // quyentai
  static Future<void> setQuyen(int quyen) async {
    await Hive.box(AppConfig.storageBox).put('phan_quyen', quyen);
  }

  static int? getQuyen() {
    return Hive.box(AppConfig.storageBox).get('phan_quyen');
  }

  // username
  static Future<void> setUserName(String userName) async {
    await Hive.box(AppConfig.storageBox).put('user_name', userName);
  }

  static String? getUserName() {
    return Hive.box(AppConfig.storageBox).get('user_name');
  }

  // hoten
  static Future<void> setName(String hoten) async {
    await Hive.box(AppConfig.storageBox).put('name', hoten);
  }

  static String? getName() {
    return Hive.box(AppConfig.storageBox).get('name');
  }

  static Future<void> setMaCuaHang(String maCuaHang) async {
    await Hive.box(AppConfig.storageBox).put('ma_cua_hang', maCuaHang);
  }

  static String? getMaCuaHang() {
    return Hive.box(AppConfig.storageBox).get('ma_cua_hang');
  }
  // cua hang
}
