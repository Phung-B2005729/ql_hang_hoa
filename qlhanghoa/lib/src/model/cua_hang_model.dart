class CuaHangModel {
  String? tenCuaHang;
  String? maCuaHang;
  String? diaChi;
  String? loaiCuaHang;
  String? sdt;

  CuaHangModel({
    this.tenCuaHang,
    this.maCuaHang,
    this.diaChi,
    this.loaiCuaHang,
    this.sdt,
  });

  CuaHangModel copyWith({
    String? tenCuaHang,
    String? maCuaHang,
    String? diaChi,
    String? loaiCuaHang,
    String? sdt,
  }) {
    return CuaHangModel(
      tenCuaHang: tenCuaHang ?? this.tenCuaHang,
      maCuaHang: maCuaHang ?? this.maCuaHang,
      diaChi: diaChi ?? this.diaChi,
      loaiCuaHang: loaiCuaHang ?? this.loaiCuaHang,
      sdt: sdt ?? this.sdt,
    );
  }

  CuaHangModel.fromJson(Map<String, dynamic> json) {
    maCuaHang = json['ma_cua_hang'];
    tenCuaHang = json['ten_cua_hang'];
    diaChi = json['dia_chi'];
    loaiCuaHang = json['loai_cua_hang'];
    sdt = json['sdt'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['ma_cua_hang'] = maCuaHang;
    data['ten_cua_hang'] = tenCuaHang;
    data['dia_chi'] = diaChi;
    data['loai_cua_hang'] = loaiCuaHang;
    data['sdt'] = sdt;
    return data;
  }
}
