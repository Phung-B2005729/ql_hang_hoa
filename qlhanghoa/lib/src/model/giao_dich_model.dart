class GiaoDichModel {
  String? sId;
  String? thoiGianGiaoDich;
  String? loaiGiaoDich;
  double? soLuongGiaoDich;
  double? soLuongTon;
  int? giaVon;
  //String? soLo;
  String? maHangHoa;
  String? maCuaHang;
  String? maNhanVien;
  String? maPhieuNhap;
  String? maCapNhat;
  String? maPhieuKiemKho;
  String? maHoaDon;
  String? maCuaHangChuyenDen;
  String? maXuatKho;

  GiaoDichModel(
      {this.sId,
      this.thoiGianGiaoDich,
      this.loaiGiaoDich,
      this.soLuongGiaoDich,
      this.maCapNhat,
      this.soLuongTon,
      this.giaVon,
      //this.soLo,
      this.maHangHoa,
      this.maCuaHang,
      this.maNhanVien,
      this.maPhieuNhap,
      this.maCuaHangChuyenDen,
      this.maHoaDon,
      this.maXuatKho,
      this.maPhieuKiemKho});
  GiaoDichModel copyWith({
    String? sId,
    String? maCapNhat,
    String? thoiGianGiaoDich,
    String? loaiGiaoDich,
    double? soLuongGiaoDich,
    double? soLuongTon,
    int? giaVon,
    //String? soLo,
    String? maHangHoa,
    String? maCuaHang,
    String? maNhanVien,
    String? maPhieuNhap,
    String? maPhieuKiemKho,
    String? maXuatKho,
    String? maHoaDon,
    String? maCuaHangChuyenDen,
  }) {
    return GiaoDichModel(
      sId: sId ?? this.sId,
      thoiGianGiaoDich: thoiGianGiaoDich ?? this.thoiGianGiaoDich,
      loaiGiaoDich: loaiGiaoDich ?? this.loaiGiaoDich,
      soLuongGiaoDich: soLuongGiaoDich ?? this.soLuongGiaoDich,
      soLuongTon: soLuongTon ?? this.soLuongTon,
      giaVon: giaVon ?? this.giaVon,
      // soLo: soLo ?? this.soLo,
      maHangHoa: maHangHoa ?? this.maHangHoa,
      maCapNhat: maCapNhat ?? this.maCapNhat,
      maCuaHang: maCuaHang ?? this.maCuaHang,
      maNhanVien: maNhanVien ?? this.maNhanVien,
      maPhieuNhap: maPhieuNhap ?? this.maPhieuNhap,
      maXuatKho: maXuatKho ?? this.maXuatKho,
      maPhieuKiemKho: maPhieuKiemKho ?? this.maPhieuKiemKho,
      maHoaDon: maHoaDon ?? this.maHoaDon,
      maCuaHangChuyenDen: maCuaHangChuyenDen ?? this.maCuaHangChuyenDen,
    );
  }

  GiaoDichModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    thoiGianGiaoDich = json['thoi_gian_giao_dich'];
    loaiGiaoDich = json['loai_giao_dich'];
    soLuongGiaoDich = double.tryParse(json['so_luong_giao_dich'].toString());
    soLuongTon = double.tryParse(json['so_luong_ton'].toString());
    giaVon = json['gia_von'];
    //soLo = json['so_lo'];
    maHangHoa = json['ma_hang_hoa'];
    maXuatKho = json['ma_xuat_kho'];
    maCuaHang = json['ma_cua_hang'];
    maCapNhat = json['ma_cap_nhat'];
    maNhanVien = json['ma_nhan_vien'];
    maPhieuNhap = json['ma_phieu_nhap'];
    maCuaHangChuyenDen = json['ma_cua_hang_chuyen_den'];
    maHoaDon = json['ma_hoa_don'];
    maPhieuKiemKho = json['ma_phieu_kiem_kho'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['thoi_gian_giao_dich'] = thoiGianGiaoDich;
    data['loai_giao_dich'] = loaiGiaoDich;
    data['so_luong_giao_dich'] = soLuongGiaoDich;
    data['so_luong_ton'] = soLuongTon;
    data['gia_von'] = giaVon;
    // data['so_lo'] = soLo;
    data['ma_hang_hoa'] = maHangHoa;
    data['ma_cua_hang'] = maCuaHang;
    data['ma_cap_nhat'] = maCapNhat;
    data['ma_nhan_vien'] = maNhanVien;
    data['ma_phieu_nhap'] = maPhieuNhap;
    data['ma_hoa_don'] = maHangHoa;
    data['ma_xuat_kho'] = maXuatKho;
    data['ma_cua_hang_chuyen_den'] = maCuaHangChuyenDen;
    data['ma_phieu_kiem_kho'] = maPhieuKiemKho;
    return data;
  }
}
