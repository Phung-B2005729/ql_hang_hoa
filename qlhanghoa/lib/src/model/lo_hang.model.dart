import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/ton_kho_model.dart';

class LoHangModel {
  String? sId;
  String? soLo;
  String? maHangHoa;
  String? ngaySanXuat;
  String? hanSuDung;
  // String? trangThai;
  double? tongSoLuong;
  double? soLuongNhap;
  String? ngayTaoLo;
  List<TonKhoModel>? tonKho;
  HangHoaModel? hangHoa;

  LoHangModel({
    this.sId,
    this.soLo,
    this.maHangHoa,
    this.ngaySanXuat,
    this.ngayTaoLo,
    this.tongSoLuong,
    this.tonKho,
    this.soLuongNhap,
    this.hanSuDung,
    //this.trangThai,
    this.hangHoa,
  });

  LoHangModel copyWith(
      {String? sId,
      String? soLo,
      String? maHangHoa,
      String? ngaySanXuat,
      double? soLuongNhap,
      List<TonKhoModel>? tonKho,
      String? ngayTaoLo,
      double? tongSoLuong,
      String? hanSuDung,
      //String? trangThai,
      HangHoaModel? hangHoa}) {
    return LoHangModel(
      sId: sId ?? this.sId,
      soLuongNhap: soLuongNhap ?? this.soLuongNhap,
      soLo: soLo ?? this.soLo,
      tonKho: tonKho ?? this.tonKho,
      maHangHoa: maHangHoa ?? this.maHangHoa,
      ngaySanXuat: ngaySanXuat ?? this.ngaySanXuat,
      ngayTaoLo: ngayTaoLo ?? this.ngayTaoLo,
      tongSoLuong: tongSoLuong ?? this.tongSoLuong,
      hanSuDung: hanSuDung ?? this.hanSuDung,
      // trangThai: trangThai ?? this.trangThai,
      hangHoa: hangHoa ?? this.hangHoa,
    );
  }

  LoHangModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    maHangHoa = json['ma_hang_hoa'];
    soLo = json['so_lo'];
    soLuongNhap = json['so_luong_nhap'] != null
        ? double.parse(json['so_luong_nhap'].toString())
        : null;
    tonKho = json['ton_kho'] != null
        ? List<TonKhoModel>.from(
            json['ton_kho'].map((x) => TonKhoModel.fromJson(x)))
        : null;
    ngaySanXuat = json['ngay_san_xuat'];
    tongSoLuong = json['tong_so_luong'] != null
        ? double.parse(json['tong_so_luong'].toString())
        : null;
    ngayTaoLo = json['ngay_tao_lo'];
    hanSuDung = json['han_su_dung'];
    // trangThai = json['trang_thai'];
    hangHoa = json['hang_hoa_info'] != null && json['hang_hoa_info'].isNotEmpty
        ? HangHoaModel.fromJson(json['hang_hoa_info'][0])
        : null;
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['ton_kho'] = tonKho != null
        ? List<dynamic>.from(tonKho!.map((x) => x.toJson()))
        : null;
    data['ma_hang_hoa'] = maHangHoa;
    data['so_luong_nhap'] = soLuongNhap;
    data['so_lo'] = soLo;
    data['tong_so_luong'] = tongSoLuong;
    data['ngay_san_xuat'] = ngaySanXuat;
    data['ngay_tao_lo'] = ngayTaoLo;
    data['han_su_dung'] = hanSuDung;
    //data['trang_thai'] = trangThai;
    return data;
  }
}
