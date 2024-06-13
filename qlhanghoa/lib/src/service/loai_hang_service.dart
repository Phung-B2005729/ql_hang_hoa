import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/loai_hang_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class LoaiHangService extends GetConnect {
  // hàm create
  LoaiHangService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/loai_hang";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(LoaiHangModel loaiHang) async {
    try {
      var body = loaiHang.toJson();
      final response = await post(
        "/",
        body,
        contentType: AppConfig.contentTypeJson,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return response;
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
      return const Response(
        statusCode: 500,
        statusText: "Server Error",
      );
    }
  }

  // refresh Token
  Future<Response> findAll() async {
    try {
      final response = await get(
        "/",
        query: {},
        contentType: AppConfig.contentTypeJson,
      );
      return response;
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
      return const Response(
        statusCode: 500,
        statusText: "Server Error",
      );
    }
  }

  // deleteOne
  Future<Response> deleteOne({required String id}) async {
    var reponse = await delete("/$id");
    //
    return reponse;
  }

  // deleteOne
  Future<Response> deleteAll() async {
    var reponse = await delete("/");
    //
    return reponse;
  }

  // getUser
  Future<Response> getById({required String id}) async {
    final response = await get(
      '/$id',
    );
    return response;
  }

  Future<Response> update(
      {required String id, required LoaiHangModel loaihang}) async {
    var body = loaihang.toJson();
    final response = await put('/$id', body);
    return response;
  }
  //
}
