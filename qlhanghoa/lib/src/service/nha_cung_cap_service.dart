import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/nha_cung_cap_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class NhaCungCapService extends GetConnect {
  // hàm create
  NhaCungCapService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/nha_cung_cap";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(NhaCungCapModel nhaCC) async {
    try {
      var body = nhaCC.toJson();
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
        body: {"message": "Server Error"},
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
        body: {"message": "Server Error"},
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
      {required String id, required NhaCungCapModel nhaCC}) async {
    var body = nhaCC.toJson();
    final response = await put('/$id', body);
    return response;
  }
  //
}
