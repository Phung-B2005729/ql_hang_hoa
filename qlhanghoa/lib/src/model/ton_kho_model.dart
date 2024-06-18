class TonKhoModel {
  String? sId;
  String? soLo;
  String? maHangHoa;
  String? maCuaHang;
  double? so_luong_ton;

  TonKhoModel({
    this.sId,
    this.soLo,
    this.maHangHoa,
    this.maCuaHang,
    this.so_luong_ton,
  });

  TonKhoModel copyWith({
    String? sId,
    String? soLo,
    String? maHangHoa,
    String? maCuaHang,
    double? so_luong_ton,
  }) {
    return TonKhoModel(
      sId: sId ?? this.sId,
      soLo: soLo ?? this.soLo,
      maHangHoa: maHangHoa ?? this.maHangHoa,
      maCuaHang: maCuaHang ?? this.maCuaHang,
      so_luong_ton: so_luong_ton ?? this.so_luong_ton,
    );
  }

  TonKhoModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    maHangHoa = json['ma_hang_hoa'];
    soLo = json['so_lo'];
    maCuaHang = json['ma_cua_hang'];
    so_luong_ton = json['so_luong_ton'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['ma_hang_hoa'] = maHangHoa;
    data['so_lo'] = soLo;
    data['so_luong_ton'] = so_luong_ton;
    data['ma_cua_hang'] = maCuaHang;
    return data;
  }
}
