import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/tai_khoan_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class TaiKhoanService extends GetConnect {
  // hàm create
  TaiKhoanService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/tai_khoan";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(TaiKhoanModel taiKhoan) async {
    try {
      var body = taiKhoan.toJson();
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
  Future<Response> findAll({
    String? thongTinChung,
    List<String>? trangThai,
    List<String>? phanQuyen,
  }) async {
    try {
      final response = await get(
        "/",
        query: {
          if (thongTinChung != null) 'thong_tin_chung': thongTinChung,
          if (trangThai != null && trangThai.isNotEmpty)
            'trang_thai': trangThai,
          if (phanQuyen != null && phanQuyen.isNotEmpty)
            'phan_quyen': phanQuyen,
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

  Future<Response> update(
      {required String id, required TaiKhoanModel taiKhoan}) async {
    var body = taiKhoan.toJson();
    final response = await put('/$id', body);
    return response;
  }

  //
  Future<Response> adminChangePass({required TaiKhoanModel taiKhoan}) async {
    var body = taiKhoan.toJson();
    final response = await put('/admin/change_password', body);
    return response;
  }

  Future<Response> adminDeleteTaiKhoan(
      {required String id, required TaiKhoanModel taiKhoan}) async {
    var body = taiKhoan.toJson();
    final response = await put('/admin/delete/$id', body);
    return response;
  }

  Future<Response> changePass(
      {required String id, required TaiKhoanModel taiKhoan}) async {
    var body = taiKhoan.toJson();
    final response = await put('/$id/change_password', body);
    return response;
  }
}
