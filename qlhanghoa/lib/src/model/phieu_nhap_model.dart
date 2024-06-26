import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/nhan_vien_model.dart';
import 'package:qlhanghoa/src/model/nha_cung_cap_model.dart';
import 'package:qlhanghoa/src/model/cua_hang_model.dart';

class PhieuNhapModel {
  String? maPhieuNhap;
  String? ngayLapPhieu;
  int? giaGiam;
  int? tongTien;
  int? daTraNCC;
  String? trangThai;
  String? maNhaCungCap;
  String? maCuaHang;
  String? maNhanVien;
  CuaHangModel? cuaHang;
  NhaCungCapModel? nhaCungCap;
  NhanVienModel? nhanVien;
  List<ChiTietPhieuNhapModel>? chiTietPhieuNhap;

  PhieuNhapModel({
    this.maPhieuNhap,
    this.ngayLapPhieu,
    this.maNhaCungCap,
    this.giaGiam,
    this.maNhanVien,
    this.daTraNCC,
    this.tongTien,
    this.nhaCungCap,
    this.cuaHang,
    this.nhanVien,
    this.chiTietPhieuNhap,
    this.maCuaHang,
    this.trangThai,
  });

  PhieuNhapModel copyWith({
    String? maPhieuNhap,
    String? ngayLapPhieu,
    String? maNhaCungCap,
    int? giaGiam,
    int? daTraNCC,
    String? maNhanVien,
    CuaHangModel? cuaHang,
    NhaCungCapModel? nhaCungCap,
    NhanVienModel? nhanVien,
    List<ChiTietPhieuNhapModel>? chiTietPhieuNhap,
    int? tongTien,
    String? maCuaHang,
    String? trangThai,
  }) {
    return PhieuNhapModel(
      maPhieuNhap: maPhieuNhap ?? this.maPhieuNhap,
      ngayLapPhieu: ngayLapPhieu ?? this.ngayLapPhieu,
      maNhaCungCap: maNhaCungCap ?? this.maNhaCungCap,
      giaGiam: giaGiam ?? this.giaGiam,
      daTraNCC: daTraNCC ?? this.daTraNCC,
      chiTietPhieuNhap: chiTietPhieuNhap ?? this.chiTietPhieuNhap,
      maNhanVien: maNhanVien ?? this.maNhanVien,
      tongTien: tongTien ?? this.tongTien,
      maCuaHang: maCuaHang ?? this.maCuaHang,
      trangThai: trangThai ?? this.trangThai,
      cuaHang: cuaHang ?? this.cuaHang,
      nhaCungCap: nhaCungCap ?? this.nhaCungCap,
      nhanVien: nhanVien ?? this.nhanVien,
    );
  }

  PhieuNhapModel.fromJson(Map<String, dynamic> json) {
    maPhieuNhap = json['ma_phieu_nhap'];
    ngayLapPhieu = json['ngay_lap_phieu'];
    giaGiam = json['gia_giam'];
    tongTien = json['tong_tien'];
    trangThai = json['trang_thai'];
    daTraNCC = json['da_tra_nha_cung_cap'];
    maNhaCungCap = json['ma_nha_cung_cap'];
    maCuaHang = json['ma_cua_hang'];
    maNhanVien = json['ma_nhan_vien'];
    cuaHang = json['cua_hang_info'] != null && json['cua_hang_info'].isNotEmpty
        ? CuaHangModel.fromJson(json['cua_hang_info'][0])
        : null;
    nhaCungCap = json['nha_cung_cap_info'] != null &&
            json['nha_cung_cap_info'].isNotEmpty
        ? NhaCungCapModel.fromJson(json['nha_cung_cap_info'][0])
        : null;
    nhanVien =
        json['nhan_vien_info'] != null && json['nhan_vien_info'].isNotEmpty
            ? NhanVienModel.fromJson(json['nhan_vien_info'][0])
            : null;
    chiTietPhieuNhap = json['chi_tiet_phieu_nhap_info'] != null
        ? List<ChiTietPhieuNhapModel>.from(json['chi_tiet_phieu_nhap_info']
            .map((x) => ChiTietPhieuNhapModel.fromJson(x)))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ma_phieu_nhap'] = maPhieuNhap;
    data['ngay_lap_phieu'] = ngayLapPhieu;
    data['gia_giam'] = giaGiam;
    data['tong_tien'] = tongTien;
    data['trang_thai'] = trangThai;
    data['ma_nha_cung_cap'] = maNhaCungCap;
    data['ma_cua_hang'] = maCuaHang;
    data['ma_nhan_vien'] = maNhanVien;
    data['da_tra_nha_cung_cap'] = daTraNCC;

    return data;
  }
}
