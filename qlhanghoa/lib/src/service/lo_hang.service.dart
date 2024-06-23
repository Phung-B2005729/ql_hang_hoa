import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/lo_hang.model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class LoHangService extends GetConnect {
  // hàm create
  LoHangService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/lo_hang";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(LoHangModel loHang) async {
    try {
      var body = loHang.toJson();
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
      {String? so_lo,
      String? maHangHoa,
      String? maCuaHang,
      String? hanSuDung,
      String? ngayBatDau,
      String? ngayKetThuc,
      String? trangThai}) async {
    try {
      final response = await get(
        "/",
        query: {
          'so_lo': so_lo,
          'ma_hang_hoa': maHangHoa,
          'ma_cua_hang': maCuaHang,
          'han_su_dung': hanSuDung,
          'ngay_bat_dau': ngayBatDau,
          'ngay_ket_thuc': ngayKetThuc,
          'trang_thai': trangThai
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
      {required String id, required LoHangModel loHang}) async {
    var body = loHang.toJson();
    final response = await put('/$id', body);
    return response;
  }
  //
}
