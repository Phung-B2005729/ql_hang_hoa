import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/lo_hang.model.dart';

class ChiTietPhieuNhapModel {
  String? sId;
  String? maPhieuNhap;
  List<LoHangModel>? loNhap;
  int? donGiaNhap;
  double? soLuong;
  int? giaGiam;
  String? maHangHoa;
  String? ghiChu;
  HangHoaModel? hangHoa;

  ChiTietPhieuNhapModel({
    this.maPhieuNhap,
    this.sId,
    this.maHangHoa,
    this.loNhap,
    this.donGiaNhap,
    this.giaGiam,
    this.ghiChu,
    this.soLuong,
    this.hangHoa,
  });

  ChiTietPhieuNhapModel copyWith({
    String? maPhieuNhap,
    String? sId,
    String? maHangHoa,
    List<LoHangModel>? loNhap,
    int? donGiaNhap,
    String? ghiChu,
    int? giaGiam,
    double? soLuong,
    HangHoaModel? hangHoa,
  }) {
    return ChiTietPhieuNhapModel(
      sId: sId ?? this.sId,
      maHangHoa: maHangHoa ?? this.maHangHoa,
      maPhieuNhap: maPhieuNhap ?? this.maPhieuNhap,
      loNhap: loNhap ?? this.loNhap,
      ghiChu: ghiChu ?? this.ghiChu,
      giaGiam: giaGiam ?? this.giaGiam,
      donGiaNhap: donGiaNhap ?? this.donGiaNhap,
      soLuong: soLuong ?? this.soLuong,
      hangHoa: hangHoa ?? this.hangHoa,
    );
  }

  ChiTietPhieuNhapModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    maHangHoa = json['ma_hang_hoa'];
    ghiChu = json['ghi_chu'];
    loNhap = json['lo_nhap'] != null && json['lo_nhap'].isNotEmpty
        ? List<LoHangModel>.from(
            json['lo_nhap'].map((x) => LoHangModel.fromJson(x)))
        : [];
    maPhieuNhap = json['ma_phieu_nhap'];
    giaGiam = json['gia_giam'];
    donGiaNhap = json['don_gia_nhap'];
    soLuong = json['so_luong'] != null
        ? double.tryParse(json['so_luong'].toString())
        : null;

    hangHoa = json['hang_hoa_info'] != null && json['hang_hoa_info'].isNotEmpty
        ? HangHoaModel.fromJson(json['hang_hoa_info'][0])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['ma_hang_hoa'] = maHangHoa;
    data['ghi_chu'] = ghiChu;
    data['gia_giam'] = giaGiam;
    data['ma_phieu_nhap'] = maPhieuNhap;
    data['don_gia_nhap'] = donGiaNhap;
    data['so_luong'] = soLuong;
    data['lo_nhap'] = loNhap != null
        ? List<dynamic>.from(loNhap!.map((x) => x.toJson()))
        : null;
    return data;
  }
}
