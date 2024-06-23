import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/giao_dich_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class GiaoDichService extends GetConnect {
  // hàm create
  GiaoDichService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/giao_dich";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(GiaoDichModel giaoDich) async {
    try {
      var body = giaoDich.toJson();
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
  Future<Response> findAll(
      {String? soLo,
      String? maHangHoa,
      String? maCuaHangChuyenDen,
      String? maCuaHang,
      String? maNhanVien,
      String? loaiGiaoDich}) async {
    try {
      final response = await get(
        "/",
        query: {
          'so_lo': soLo,
          'ma_hang_hoa': maHangHoa,
          'ma_cua_hang': maCuaHang,
          'ma_cua_hang_chuyen_den': maCuaHangChuyenDen,
          'ma_nhan_vien': maNhanVien,
          'loai_giao_dich': loaiGiaoDich,
        },
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
      {required String id, required GiaoDichModel giaoDich}) async {
    var body = giaoDich.toJson();
    final response = await put('/$id', body);
    return response;
  }
  //
}
