class NhaCungCapModel {
  String? tenNhaCungCap;
  String? maNhaCungCap;
  String? diaChi;
  String? email;
  String? congTy;
  String? sdt;

  NhaCungCapModel({
    this.tenNhaCungCap,
    this.maNhaCungCap,
    this.diaChi,
    this.congTy,
    this.email,
    this.sdt,
  });

  NhaCungCapModel copyWith({
    String? tenNhaCungCap,
    String? maNhaCungCap,
    String? diaChi,
    String? loaiNhaCungCap,
    String? email,
    String? congTy,
    String? sdt,
  }) {
    return NhaCungCapModel(
      tenNhaCungCap: tenNhaCungCap ?? this.tenNhaCungCap,
      maNhaCungCap: maNhaCungCap ?? this.maNhaCungCap,
      diaChi: diaChi ?? this.diaChi,
      email: email ?? this.email,
      congTy: congTy ?? this.congTy,
      sdt: sdt ?? this.sdt,
    );
  }

  NhaCungCapModel.fromJson(Map<String, dynamic> json) {
    maNhaCungCap = json['ma_nha_cung_cap'];
    tenNhaCungCap = json['ten_nha_cung_cap'];
    congTy = json['cong_ty'];
    email = json['email'];
    diaChi = json['dia_chi'];

    sdt = json['sdt'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['ma_nha_cung_cap'] = maNhaCungCap;
    data['ten_nha_cung_cap'] = tenNhaCungCap;
    data['dia_chi'] = diaChi;
    data['email'] = email;
    data['cong_ty'] = congTy;
    data['sdt'] = sdt;
    return data;
  }
}
