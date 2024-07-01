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
      String? soNgay,
      String? maCuaHang}) async {
    try {
      final response = await get(
        "/",
        query: {
          if (so_lo != null) 'so_lo': so_lo,
          if (maHangHoa != null) 'ma_hang_hoa': maHangHoa,
          if (maCuaHang != null) 'ma_cua_hang': maCuaHang,
          if (soNgay != null && soNgay != '') 'so_ngay': soNgay
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

  Future<Response> findTongTonKho(
      // ignore: non_constant_identifier_names
      {String? so_lo,
      String? maHangHoa,
      String? soNgay,
      String? maCuaHang}) async {
    try {
      final response = await get(
        "/tong_so_luong",
        query: {
          if (so_lo != null) 'so_lo': so_lo,
          if (maHangHoa != null) 'ma_hang_hoa': maHangHoa,
          if (maCuaHang != null) 'ma_cua_hang': maCuaHang,
          if (soNgay != null && soNgay != '') 'so_ngay': soNgay
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

  Future<Response> updateTheoSoLoHangHoaCuaHang(
      {required String soLo,
      required String maCuaHang,
      required String maHangHoa,
      required TonKhoModel tonkho}) async {
    var body = tonkho.toJson();
    final response = await put('/update/$soLo/$maHangHoa/$maCuaHang', body);
    return response;
  }

  //
  Future<Response> themSoLuongTonKho(
      {required String soLo,
      required String maCuaHang,
      required String maHangHoa,
      required TonKhoModel tonkho}) async {
    var body = tonkho.toJson();
    final response = await put('/$soLo/$maHangHoa/$maCuaHang', body);
    return response;
  }

  Future<Response> giamSoLuongTonKho(
      {required String soLo,
      required String maCuaHang,
      required String maHangHoa,
      required TonKhoModel tonkho}) async {
    var body = tonkho.toJson();
    final response =
        await put('/giam_so_luong/$soLo/$maHangHoa/$maCuaHang', body);
    return response;
  }
}
