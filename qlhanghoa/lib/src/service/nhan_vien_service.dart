import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/nhan_vien_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class NhanVienService extends GetConnect {
  // hàm create
  NhanVienService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/nhan_vien";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(NhanVienModel nhanVien) async {
    try {
      var body = nhanVien.toJson();
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
    String? chuaTaiKhoan,
    String? coTaiKhoan,
    String? thongTinChung,
    String? maCuaHang,
    List? trangThai,
    List? chucVu,
  }) async {
    try {
      final response = await get(
        "/",
        query: {
          if (chuaTaiKhoan != null) 'chua_tai_khoan': chuaTaiKhoan,
          if (coTaiKhoan != null) 'co_tai_khoan': coTaiKhoan,
          if (thongTinChung != null) 'thong_tin_chung': thongTinChung,
          if (maCuaHang != null) 'ma_cua_hang': maCuaHang,
          if (trangThai != null && trangThai.isNotEmpty)
            'trang_thai': trangThai,
          if (chucVu != null && chucVu.isNotEmpty) 'chuc_vu': chucVu,
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

  Future<Response> update(
      {required String id, required NhanVienModel nhanVien}) async {
    var body = nhanVien.toJson();
    final response = await put('/$id', body);
    return response;
  }
  //
}
