import 'package:qlhanghoa/src/model/phieu_nhap_model.dart';

class NhaCungCapModel {
  String? tenNhaCungCap;
  String? maNhaCungCap;
  String? diaChi;
  String? email;
  String? congTy;
  String? sdt;
  String? ghiChu;
  List<PhieuNhapModel>? listPhieuNhap;

  NhaCungCapModel({
    this.tenNhaCungCap,
    this.maNhaCungCap,
    this.diaChi,
    this.listPhieuNhap,
    this.congTy,
    this.ghiChu,
    this.email,
    this.sdt,
  });

  NhaCungCapModel copyWith({
    String? tenNhaCungCap,
    String? maNhaCungCap,
    String? diaChi,
    List<PhieuNhapModel>? listPhieuNhap,
    String? loaiNhaCungCap,
    String? email,
    String? ghiChu,
    String? congTy,
    String? sdt,
  }) {
    return NhaCungCapModel(
      tenNhaCungCap: tenNhaCungCap ?? this.tenNhaCungCap,
      maNhaCungCap: maNhaCungCap ?? this.maNhaCungCap,
      diaChi: diaChi ?? this.diaChi,
      listPhieuNhap: listPhieuNhap ?? this.listPhieuNhap,
      email: email ?? this.email,
      congTy: congTy ?? this.congTy,
      ghiChu: ghiChu ?? this.ghiChu,
      sdt: sdt ?? this.sdt,
    );
  }

  NhaCungCapModel.fromJson(Map<String, dynamic> json) {
    maNhaCungCap = json['ma_nha_cung_cap'];
    tenNhaCungCap = json['ten_nha_cung_cap'];
    congTy = json['cong_ty'];
    email = json['email'];
    ghiChu = json['ghi_chu'];
    listPhieuNhap = json['phieu_nhap_info'] != null
        ? List<PhieuNhapModel>.from(
            json['phieu_nhap_info'].map((x) => PhieuNhapModel.fromJson(x)))
        : null;
    diaChi = json['dia_chi'];

    sdt = json['sdt'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['ma_nha_cung_cap'] = maNhaCungCap;
    data['ten_nha_cung_cap'] = tenNhaCungCap;
    data['dia_chi'] = diaChi;
    data['ghi_chu'] = ghiChu;
    data['email'] = email;
    data['cong_ty'] = congTy;
    data['sdt'] = sdt;
    return data;
  }
}
