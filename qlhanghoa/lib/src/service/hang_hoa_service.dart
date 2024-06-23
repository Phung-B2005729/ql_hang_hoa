import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class HangHoaService extends GetConnect {
  // hàm create
  HangHoaService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/hang_hoa";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(HangHoaModel hangHoa) async {
    try {
      var body = hangHoa.toJson();
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
  Future<Response> findAll({String? maCuaHang}) async {
    try {
      final response = await get(
        "/",
        query: {
          'ma_cua_hang': maCuaHang,
        },
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
    Response reponse = await delete("/$id");
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
      {required String id, required HangHoaModel hangHoa}) async {
    print(id);
    var body = hangHoa.toJson();
    print(id);
    Response response = await put('/$id', body);
    return response;
  }
  //
}
