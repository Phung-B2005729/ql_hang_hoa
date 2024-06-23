import 'package:get/get.dart';
import 'package:qlhanghoa/src/config/app_config.dart';
import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';
import 'package:qlhanghoa/src/util/auth_util.dart';

class PhieuNhapService extends GetConnect {
  // hàm create
  PhieuNhapService() {
    httpClient.baseUrl = "${AppConfig.urlApi}/phieu_nhap";
    httpClient.addRequestModifier<void>((request) {
      String? token = AuthUtil.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }
  // hàm create
  Future<Response> create(PhieuNhapModel phieuNhap) async {
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
  Future<Response> findAll(
      {String? thongTinHangHoa,
      String? thongTinNhaCungCap,
      String? thongTinLoHang,
      String? trangThai,
      String? ngayBatDau,
      String? ngayKetThuc,
      String? thongTinPhieuNhap,
      String? maCuaHang,
      String? maNhanVien}) async {
    try {
      print(thongTinNhaCungCap);
      print(thongTinLoHang);
      print(thongTinHangHoa);
      print('gọi get all');
      final response = await get(
        "/",
        query: {
          if (thongTinLoHang != null) 'thong_tin_lo_hang': thongTinLoHang,
          if (thongTinHangHoa != null) 'ma_hang_hoa': thongTinHangHoa,
          if (maCuaHang != null) 'ma_cua_hang': maCuaHang,
          if (maNhanVien != null) 'ma_nhan_vien': maNhanVien,
          if (ngayBatDau != null) 'ngay_bat_dau': ngayBatDau,
          if (ngayKetThuc != null) 'ngay_ket_thuc': ngayKetThuc,
          if (trangThai != null) 'trang_thai': trangThai,
          if (thongTinNhaCungCap != null)
            'thong_tin_nha_cung_cap': thongTinNhaCungCap,
          if (thongTinPhieuNhap != null)
            'thong_tin_phieu_nhap': thongTinPhieuNhap
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
      {required String id, required PhieuNhapModel phieuNhap}) async {
    var body = phieuNhap.toJson();
    final response = await put('/$id', body);
    return response;
  }
  //
}
