import 'package:qlhanghoa/src/config/app_config.dart';

class AuthRouteConfig {
  /// login route
  static const String loginRoute = "${AppConfig.urlApi}/login";

  /// logout
  static const String logoutRoute = "${AppConfig.urlApi}/logout";

  // refeshToken
  static const String refreshTokenRoute = "${AppConfig.urlApi}/refresh";

  static const String getUserLogin = "${AppConfig.urlApi}/getuser";
}
