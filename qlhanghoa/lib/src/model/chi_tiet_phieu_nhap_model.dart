import 'package:qlhanghoa/src/model/hang_hoa_model.dart';

class ChiTietPhieuNhapModel {
  String? sId;
  String? maPhieuNhap;
  String? soLo;
  int? donGiaNhap;
  double? soLuong;
  String? maHangHoa;
  HangHoaModel? hangHoa;
  String? hanSuDung;

  ChiTietPhieuNhapModel({
    this.maPhieuNhap,
    this.sId,
    this.maHangHoa,
    this.soLo,
    this.donGiaNhap,
    this.soLuong,
    this.hangHoa,
    this.hanSuDung,
  });

  ChiTietPhieuNhapModel copyWith({
    String? maPhieuNhap,
    String? sId,
    String? maHangHoa,
    String? soLo,
    int? donGiaNhap,
    double? soLuong,
    HangHoaModel? hangHoa,
    String? hanSuDung,
  }) {
    return ChiTietPhieuNhapModel(
      sId: sId ?? this.sId,
      maHangHoa: maHangHoa ?? this.maHangHoa,
      maPhieuNhap: maPhieuNhap ?? this.maPhieuNhap,
      soLo: soLo ?? this.soLo,
      donGiaNhap: donGiaNhap ?? this.donGiaNhap,
      soLuong: soLuong ?? this.soLuong,
      hanSuDung: hanSuDung ?? this.hanSuDung,
      hangHoa: hangHoa ?? this.hangHoa,
    );
  }

  ChiTietPhieuNhapModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    maHangHoa = json['ma_hang_hoa'];
    soLo = json['so_lo'];
    maPhieuNhap = json['ma_phieu_nhap'];
    donGiaNhap = json['don_gia_nhap'];
    soLuong = double.tryParse(json['so_luong'].toString());
    hanSuDung = json['han_su_dung'];
    hangHoa = json['hang_hoa_info'] != null && json['hang_hoa_info'].isNotEmpty
        ? HangHoaModel.fromJson(json['hang_hoa_info'][0])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['ma_hang_hoa'] = maHangHoa;
    data['so_lo'] = soLo;
    data['ma_phieu_nhap'] = maPhieuNhap;
    data['don_gia_nhap'] = donGiaNhap;
    data['so_luong'] = soLuong;
    data['han_su_dung'] = hanSuDung;

    return data;
  }
}
