import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/config/auth_route_config.dart';

class AuthService extends GetConnect {
  // hàm login
  // hàm login
  Future<Response> logIn(String userName, String password) async {
    Map<String, String?> body = {"user_name": userName, "password": password};
    print("Request Body: $body");
    print("Request URL: ${AuthRouteConfig.loginRoute}");

    try {
      final response = await post(
        AuthRouteConfig.loginRoute,
        body,
        contentType: AppConfig.contentTypeJson,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print("Error: $e");
      return const Response(
        statusCode: 500,
        statusText: "Server Error",
      );
    }
  }

  // refresh Token
  Future<Response> refreshToken({required String refreshToken}) async {
    Map<String, String> body = {'refresh_token': refreshToken};
    var reponse = await post(AuthRouteConfig.refreshTokenRoute, body);
    return reponse;
  }

  // logout
  Future<Response> logOut(
      {required String accessToken, required String refreshToken}) async {
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    Map<String, String> body = {'refresh_token': refreshToken};
    var reponse =
        await post(AuthRouteConfig.logoutRoute, body, headers: headers);
    //
    return reponse;
  }

  // getUser
  Future<Response> getInfoUser({required String accessToken}) async {
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    var reponse = await get(AuthRouteConfig.getUserLogin, headers: headers);
    //
    return reponse;
  }
  //
}
