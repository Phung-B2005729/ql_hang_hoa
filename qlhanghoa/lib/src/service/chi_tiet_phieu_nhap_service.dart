import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class ChiTietPhieuNhapService extends GetConnect {
  // hàm create
  ChiTietPhieuNhapService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/chi_tiet_nhap_hang";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(ChiTietPhieuNhapModel phieuNhap) async {
    try {
      var body = phieuNhap.toJson();
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
  Future<Response> findAll({
    String? soLo,
    String? maHangHoa,
    String? maPhieuNhap,
  }) async {
    try {
      final response = await get(
        "/",
        query: {
          'so_lo': soLo,
          'ma_hang_hoa': maHangHoa,
          'ma_phieu_nhap': maPhieuNhap,
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

  // deleteOne
  Future<Response> deleteMany({required String maPhieuNhap}) async {
    // ignore: unnecessary_brace_in_string_interps
    var reponse = await delete('/detele_many/${maPhieuNhap}');
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

  Future<Response> getOneSoLoMaHangMaPhieuNhap(
      {required String soLo,
      required String maHangHoa,
      required String maPhieuNhap}) async {
    final response = await get(
      '/$soLo/$maPhieuNhap/$maHangHoa',
    );
    return response;
  }

  Future<Response> update(
      {required String id, required ChiTietPhieuNhapModel phieuNhap}) async {
    var body = phieuNhap.toJson();
    final response = await put('/$id', body);
    return response;
  }
  //
}
