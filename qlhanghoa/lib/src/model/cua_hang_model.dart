import 'package:qlhanghoa/src/model/nhan_vien_model.dart';
import 'package:qlhanghoa/src/model/ton_kho_model.dart';

class CuaHangModel {
  String? tenCuaHang;
  String? maCuaHang;
  String? diaChi;
  String? loaiCuaHang;
  String? sdt;
  String? ghiChu;
  List<TonKhoModel>? tonKho;
  List<NhanVienModel>? listNhanVien;

  CuaHangModel({
    this.tenCuaHang,
    this.maCuaHang,
    this.diaChi,
    this.ghiChu,
    this.loaiCuaHang,
    this.sdt,
    this.tonKho,
    this.listNhanVien,
  });

  CuaHangModel copyWith(
      {String? tenCuaHang,
      String? maCuaHang,
      String? diaChi,
      String? ghiChu,
      String? loaiCuaHang,
      String? sdt,
      List<TonKhoModel>? tonKho,
      List<NhanVienModel>? listNhanVien}) {
    return CuaHangModel(
        tenCuaHang: tenCuaHang ?? this.tenCuaHang,
        maCuaHang: maCuaHang ?? this.maCuaHang,
        ghiChu: ghiChu ?? this.ghiChu,
        diaChi: diaChi ?? this.diaChi,
        loaiCuaHang: loaiCuaHang ?? this.loaiCuaHang,
        sdt: sdt ?? this.sdt,
        tonKho: tonKho ?? this.tonKho,
        listNhanVien: listNhanVien ?? this.listNhanVien);
  }

  CuaHangModel.fromJson(Map<String, dynamic> json) {
    maCuaHang = json['ma_cua_hang'];
    tenCuaHang = json['ten_cua_hang'];
    diaChi = json['dia_chi'];
    loaiCuaHang = json['loai_cua_hang'];
    ghiChu = json['ghi_chu'];
    sdt = json['sdt'];
    tonKho = json['ton_kho'] != null
        ? List<TonKhoModel>.from(
            json['ton_kho'].map((x) => TonKhoModel.fromJson(x)))
        : null;
    listNhanVien = json['nhan_vien_info'] != null
        ? List<NhanVienModel>.from(
            json['nhan_vien_info'].map((x) => NhanVienModel.fromJson(x)))
        : null;
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['ma_cua_hang'] = maCuaHang;
    data['ten_cua_hang'] = tenCuaHang;
    data['ghi_chu'] = ghiChu;
    data['dia_chi'] = diaChi;
    data['loai_cua_hang'] = loaiCuaHang;
    data['sdt'] = sdt;
    return data;
  }
}
