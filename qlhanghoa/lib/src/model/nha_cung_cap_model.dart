class NhaCungCapModel {
  String? tenNhaCungCap;
  String? maNhaCungCap;
  String? diaChi;
  String? sdt;

  NhaCungCapModel({
    this.tenNhaCungCap,
    this.maNhaCungCap,
    this.diaChi,
    this.sdt,
  });

  NhaCungCapModel copyWith({
    String? tenNhaCungCap,
    String? maNhaCungCap,
    String? diaChi,
    String? loaiNhaCungCap,
    String? sdt,
  }) {
    return NhaCungCapModel(
      tenNhaCungCap: tenNhaCungCap ?? this.tenNhaCungCap,
      maNhaCungCap: maNhaCungCap ?? this.maNhaCungCap,
      diaChi: diaChi ?? this.diaChi,
      sdt: sdt ?? this.sdt,
    );
  }

  NhaCungCapModel.fromJson(Map<String, dynamic> json) {
    maNhaCungCap = json['ma_nha_cung_cap'];
    tenNhaCungCap = json['ten_nha_cung_cap'];
    diaChi = json['dia_chi'];

    sdt = json['sdt'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['ma_nha_cung_cap'] = maNhaCungCap;
    data['ten_nha_cung_cap'] = tenNhaCungCap;
    data['dia_chi'] = diaChi;
    data['sdt'] = sdt;
    return data;
  }
}
