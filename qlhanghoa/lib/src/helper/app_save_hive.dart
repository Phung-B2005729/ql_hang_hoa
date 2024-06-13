import 'package:hive/hive.dart';
import 'package:qlhanghoa/src/config/app_config.dart';

class AppSaveHive {
  static Future<void> setValueInHive(String key, dynamic value) async {
    await Hive.box(AppConfig.storageBox).put(key, false);
  }

  static dynamic getValueFormHive(String key) {
    return Hive.box(AppConfig.storageBox).get(key);
  }
}
