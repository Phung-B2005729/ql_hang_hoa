class LoHangModel {
  String? sId;
  String? soLo;
  String? maHangHoa;
  String? ngaySanXuat;
  String? hanSuDung;
  String? trangThai;
  double? tongSoLuong;
  String? ngayTaoLo;

  LoHangModel({
    this.sId,
    this.soLo,
    this.maHangHoa,
    this.ngaySanXuat,
    this.ngayTaoLo,
    this.tongSoLuong,
    this.hanSuDung,
    this.trangThai,
  });

  LoHangModel copyWith({
    String? sId,
    String? soLo,
    String? maHangHoa,
    String? ngaySanXuat,
    String? ngayTaoLo,
    double? tongSoLuong,
    String? hanSuDung,
    String? trangThai,
  }) {
    return LoHangModel(
      sId: sId ?? this.sId,
      soLo: soLo ?? this.soLo,
      maHangHoa: maHangHoa ?? this.maHangHoa,
      ngaySanXuat: ngaySanXuat ?? this.ngaySanXuat,
      ngayTaoLo: ngayTaoLo ?? this.ngayTaoLo,
      tongSoLuong: tongSoLuong ?? this.tongSoLuong,
      hanSuDung: hanSuDung ?? this.hanSuDung,
      trangThai: trangThai ?? this.trangThai,
    );
  }

  LoHangModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    maHangHoa = json['ma_hang_hoa'];
    soLo = json['so_lo'];
    ngaySanXuat = json['ngay_san_xuat'];
    tongSoLuong = json['tong_so_luong'];
    ngayTaoLo = json['ngay_tao_lo'];
    hanSuDung = json['han_su_dung'];
    trangThai = json['trang_thai'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['ma_hang_hoa'] = maHangHoa;
    data['so_lo'] = soLo;
    data['tong_so_luong'] = tongSoLuong;
    data['ngay_san_xuat'] = ngaySanXuat;
    data['ngay_tao_lo'] = ngayTaoLo;
    data['han_su_dung'] = hanSuDung;
    data['trang_thai'] = trangThai;
    return data;
  }
}
