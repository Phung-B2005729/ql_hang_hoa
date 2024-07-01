import 'package:qlhanghoa/src/model/hang_hoa_model.dart';

class TonKhoModel {
  String? sId;
  String? soLo;
  String? hanSuDung;
  String? maHangHoa;
  String? maCuaHang;
  double? soLuongTon;
  HangHoaModel? hangHoa;

  TonKhoModel({
    this.sId,
    this.soLo,
    this.maHangHoa,
    this.hanSuDung,
    this.maCuaHang,
    this.soLuongTon,
    this.hangHoa,
  });

  TonKhoModel copyWith(
      {String? sId,
      String? soLo,
      String? maHangHoa,
      String? hanSuDung,
      String? maCuaHang,
      double? soLuongTon,
      HangHoaModel? hangHoa}) {
    return TonKhoModel(
        sId: sId ?? this.sId,
        soLo: soLo ?? this.soLo,
        hanSuDung: hanSuDung ?? this.hanSuDung,
        maHangHoa: maHangHoa ?? this.maHangHoa,
        maCuaHang: maCuaHang ?? this.maCuaHang,
        soLuongTon: soLuongTon ?? this.soLuongTon,
        hangHoa: hangHoa ?? this.hangHoa);
  }

  TonKhoModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    maHangHoa = json['ma_hang_hoa'];
    soLo = json['so_lo'];
    hanSuDung = json['han_su_dung'];
    maCuaHang = json['ma_cua_hang'];
    soLuongTon = json['so_luong_ton'] != null
        ? double.parse(json['so_luong_ton'].toString())
        : null;
    hangHoa = json['hang_hoa_info'] != null && json['hang_hoa_info'].isNotEmpty
        ? HangHoaModel.fromJson(json['hang_hoa_info'][0])
        : null;
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['ma_hang_hoa'] = maHangHoa;
    data['han_su_dung'] = hanSuDung;
    data['so_lo'] = soLo;
    data['so_luong_ton'] = soLuongTon;
    data['ma_cua_hang'] = maCuaHang;
    return data;
  }
}
