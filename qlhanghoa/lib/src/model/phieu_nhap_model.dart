class PhieuNhapModel {
  String? maPhieuNhap;
  String? ngayLapPhieu;
  int? giaGiam;
  int? tongTien;
  String? trangThai;
  String? maNhaCungCap;
  String? maCuaHang;
  String? maNhanVien;

  PhieuNhapModel({
    this.maPhieuNhap,
    this.ngayLapPhieu,
    this.maNhaCungCap,
    this.giaGiam,
    this.maNhanVien,
    this.tongTien,
    this.maCuaHang,
    this.trangThai,
  });

  PhieuNhapModel copyWith({
    String? maPhieuNhap,
    String? ngayLapPhieu,
    String? maNhaCungCap,
    int? giaGiam,
    String? maNhanVien,
    int? tongTien,
    String? maCuaHang,
    String? trangThai,
  }) {
    return PhieuNhapModel(
      maPhieuNhap: maPhieuNhap ?? this.maPhieuNhap,
      ngayLapPhieu: ngayLapPhieu ?? this.ngayLapPhieu,
      maNhaCungCap: maNhaCungCap ?? this.maNhaCungCap,
      giaGiam: giaGiam ?? this.giaGiam,
      maNhanVien: maNhanVien ?? this.maNhanVien,
      tongTien: tongTien ?? this.tongTien,
      maCuaHang: maCuaHang ?? this.maCuaHang,
      trangThai: trangThai ?? this.trangThai,
    );
  }

  PhieuNhapModel.fromJson(Map<String, dynamic> json) {
    ngayLapPhieu = json['ngay_lap_phieu'];
    maPhieuNhap = json['ma_phieu_nhap'];
    maNhaCungCap = json['ma_nha_cung_cap'];
    giaGiam = json['gia_giam'];
    maNhanVien = json['ma_nhan_vien'];
    tongTien = json['tong_tien'];
    maCuaHang = json['ma_cua_hang'];
    trangThai = json['trang_thai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ten_hang_hoa'] = ngayLapPhieu;
    data['ma_phieu_nhap'] = maPhieuNhap;
    data['ma_nha_cung_cap'] = maNhaCungCap;
    data['gia_giam'] = giaGiam;
    data['ma_nhan_vien'] = maNhanVien;
    data['tong_tien'] = tongTien;
    data['ma_cua_hang'] = maCuaHang;
    data['trang_thai'] = trangThai;
    return data;
  }
}
