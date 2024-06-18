import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/ton_kho_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class TonKhoService extends GetConnect {
  // hàm create
  TonKhoService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/ton_kho_lo_hang";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(TonKhoModel tonkho) async {
    try {
      var body = tonkho.toJson();
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
  Future<Response> findAll(
      // ignore: non_constant_identifier_names
      {String? so_lo,
      String? maHangHoa,
      String? maCuaHang}) async {
    try {
      final response = await get(
        "/",
        query: {
          'so_lo': so_lo,
          'ma_hang_hoa': maHangHoa,
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

  Future<Response> getBySoLoMaCuaHang(
      {required String soLo, required String maCuaHang}) async {
    final response = await get(
      '/$soLo/$maCuaHang',
    );
    return response;
  }

  Future<Response> update(
      {required String id, required TonKhoModel tonkho}) async {
    var body = tonkho.toJson();
    final response = await put('/$id', body);
    return response;
  }

  //
  Future<Response> updateTheoSoLoMaCuaHang(
      {required String soLo,
      required String maCuaHang,
      required TonKhoModel tonkho}) async {
    var body = tonkho.toJson();
    final response = await put('/$soLo/$maCuaHang', body);
    return response;
  }
}
