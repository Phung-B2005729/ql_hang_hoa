import 'package:qlhanghoa/src/model/hinh_anh_model.dart';
import 'package:qlhanghoa/src/model/loai_hang_model.dart';
import 'package:qlhanghoa/src/model/thuong_hieu_model.dart';

class HangHoaModel {
  String? maHangHoa;
  String? tenHangHoa;
  String? moTa;
  int? donGiaBan;
  double? tonKho;
  int? giaVon;
  double? tonNhieuNhat;
  String? donViTinh;
  List<HinhAnhModel>? hinhAnh;
  String? trangThai;
  LoaiHangModel? loaiHang;
  ThuongHieuModel? thuongHieu;
  bool? quanLyTheoLo;

  HangHoaModel({
    this.maHangHoa,
    this.tenHangHoa,
    this.moTa,
    this.donGiaBan,
    this.tonNhieuNhat,
    this.tonKho,
    this.giaVon,
    this.donViTinh,
    this.thuongHieu,
    this.loaiHang,
    this.trangThai,
    this.hinhAnh,
    this.quanLyTheoLo,
  });
  HangHoaModel copyWith({
    String? maHangHoa,
    String? tenHangHoa,
    String? moTa,
    int? donGiaBan,
    double? tonNhieuNhat,
    double? tonKho,
    int? giaVon,
    String? donViTinh,
    List<HinhAnhModel>? hinhAnh,
    String? trangThai,
    LoaiHangModel? loaiHang,
    ThuongHieuModel? thuongHieu,
    bool? quanLyTheoLo,
  }) {
    return HangHoaModel(
      maHangHoa: maHangHoa ?? this.maHangHoa,
      tenHangHoa: tenHangHoa ?? this.tenHangHoa,
      moTa: moTa ?? this.moTa,
      donGiaBan: donGiaBan ?? this.donGiaBan,
      tonKho: tonKho ?? this.tonKho,
      giaVon: giaVon ?? this.giaVon,
      tonNhieuNhat: tonNhieuNhat ?? this.tonNhieuNhat,
      donViTinh: donViTinh ?? this.donViTinh,
      hinhAnh: hinhAnh ?? this.hinhAnh,
      trangThai: trangThai ?? this.trangThai,
      loaiHang: loaiHang ?? this.loaiHang,
      thuongHieu: thuongHieu ?? this.thuongHieu,
      quanLyTheoLo: quanLyTheoLo ?? this.quanLyTheoLo,
    );
  }

  factory HangHoaModel.fromJson(Map<String, dynamic> json) {
    return HangHoaModel(
      maHangHoa: json['ma_hang_hoa'],
      tenHangHoa: json['ten_hang_hoa'],
      moTa: json['mo_ta'],
      donGiaBan: json['don_gia_ban'],
      tonNhieuNhat: json['ton_nhieu_nhat'],
      tonKho: json['ton_kho'],
      giaVon: json['gia_von'],
      donViTinh: json['don_vi_tinh'],
      trangThai: json['trang_thai'],
      quanLyTheoLo: json['quan_ly_theo_lo'],
      hinhAnh: json['hinh_anh'] != null
          ? List<HinhAnhModel>.from(
              json['hinh_anh'].map((x) => HinhAnhModel.fromJson(x)))
          : null,
      loaiHang: json['loai_hang'] != null
          ? LoaiHangModel.fromJson(json['loai_hang'])
          : null,
      thuongHieu: json['thuong_hieu'] != null
          ? ThuongHieuModel.fromJson(json['thuong_hieu'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'ma_hang_hoa': maHangHoa,
      'ten_hang_hoa': tenHangHoa,
      'mo_ta': moTa,
      'don_gia_ban': donGiaBan,
      'ton_nhieu_nhat': tonNhieuNhat,
      'ton_kho': tonKho,
      'gia_von': giaVon,
      'don_vi_tinh': donViTinh,
      'trang_thai': trangThai,
      'quan_ly_theo_lo': quanLyTheoLo,
      'hinh_anh': hinhAnh != null
          ? List<dynamic>.from(hinhAnh!.map((x) => x.toJson()))
          : null,
      'loai_hang': loaiHang?.toJson(),
      'thuong_hieu': thuongHieu?.toJson(),
    };
    return data;
  }
}
