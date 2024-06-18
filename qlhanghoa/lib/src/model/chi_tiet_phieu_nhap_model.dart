class PhieuNhapModel {
  String? maPhieuNhap;
  String? soLo;
  int? donGiaNhap;
  double? soLuong;

  PhieuNhapModel({
    this.maPhieuNhap,
    this.soLo,
    this.donGiaNhap,
    this.soLuong,
  });

  PhieuNhapModel copyWith({
    String? maPhieuNhap,
    String? soLo,
    int? donGiaNhap,
    double? soLuong,
  }) {
    return PhieuNhapModel(
      maPhieuNhap: maPhieuNhap ?? this.maPhieuNhap,
      soLo: soLo ?? this.soLo,
      donGiaNhap: donGiaNhap ?? this.donGiaNhap,
      soLuong: soLuong ?? this.soLuong,
    );
  }

  PhieuNhapModel.fromJson(Map<String, dynamic> json) {
    soLo = json['so_lo'];
    maPhieuNhap = json['ma_phieu_nhap'];

    donGiaNhap = json['don_gia_nhap'];

    soLuong = json['so_luong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['so_lo'] = soLo;
    data['ma_phieu_nhap'] = maPhieuNhap;
    data['don_gia_nhap'] = donGiaNhap;
    data['so_luong'] = soLuong;
    return data;
  }
}
