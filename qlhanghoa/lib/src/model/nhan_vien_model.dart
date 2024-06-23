import 'package:qlhanghoa/src/model/tai_khoan_model.dart';

class NhanVienModel {
  String? maNhanVien;
  String? tenNhanVien;
  String? diaChi;
  String? sdt;
  String? email;
  String? stk;
  bool? gioiTinh;
  String? chucVu;
  String? trangThai;
  String? maCuaHang;
  TaiKhoan? taiKhoan;

  NhanVienModel(
      {this.maNhanVien,
      this.tenNhanVien,
      this.diaChi,
      this.sdt,
      this.stk,
      this.email,
      this.gioiTinh,
      this.chucVu,
      this.maCuaHang,
      this.taiKhoan,
      this.trangThai});

  NhanVienModel copyWith({
    String? maNhanVien,
    String? tenNhanVien,
    String? diaChi,
    String? sdt,
    String? email,
    String? stk,
    bool? gioiTinh,
    String? chucVu,
    String? trangThai,
    String? maCuaHang,
    TaiKhoan? taiKhoan,
  }) {
    return NhanVienModel(
        tenNhanVien: tenNhanVien ?? this.tenNhanVien,
        maNhanVien: maNhanVien ?? this.maNhanVien,
        diaChi: diaChi ?? this.diaChi,
        email: email ?? this.email,
        sdt: sdt ?? this.sdt,
        stk: stk ?? this.stk,
        gioiTinh: gioiTinh ?? this.gioiTinh,
        chucVu: chucVu ?? this.chucVu,
        trangThai: trangThai ?? this.trangThai,
        maCuaHang: maCuaHang ?? this.maCuaHang,
        taiKhoan: taiKhoan ?? this.taiKhoan);
  }

  NhanVienModel.fromJson(Map<String, dynamic> json) {
    maNhanVien = json['ma_nhan_vien'];
    tenNhanVien = json['ten_nhan_vien'];
    diaChi = json['dia_chi'];
    sdt = json['sdt'];
    stk = json['stk'];
    email = json['email'];
    gioiTinh = json['gioi_tinh'];
    chucVu = json['chuc_vu'];
    trangThai = json['trang_thai'];
    taiKhoan =
        json['tai_khoan'] != null ? TaiKhoan.fromJson(json['tai_khoan']) : null;
    maCuaHang = json['ma_cua_hang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ma_nhan_vien'] = maNhanVien;
    data['ten_nhan_vien'] = tenNhanVien;
    data['dia_chi'] = diaChi;
    data['sdt'] = sdt;
    data['stk'] = stk;
    data['email'] = email;
    data['gioi_tinh'] = gioiTinh;
    data['chuc_vu'] = chucVu;
    data['tai_khoan'] =
        taiKhoan != null ? taiKhoan!.toJson() : TaiKhoan().toJson();
    data['trang_thai'] = trangThai;
    data['ma_cua_hang'] = maCuaHang;
    return data;
  }
}
