import 'package:qlhanghoa/src/model/loai_hang_model.dart';
import 'package:qlhanghoa/src/model/thuong_hieu_model.dart';

class HangHoaModel {
  String? sId;
  String? maHangHoa;
  String? tenHangHoa;
  String? moTa;
  int? donGiaBan;
  double? tonKho;
  int? giaVon;
  double? tonNhieuNhat;
  String? donViTinh;
  List<String>? hinhAnh;
  String? trangThai;
  LoaiHangModel? loaiHang;
  ThuongHieuModel? thuongHieu;
  bool? quanLyTheoLo;

  HangHoaModel({
    this.sId,
    this.maHangHoa,
    this.tenHangHoa,
    this.moTa,
    this.donGiaBan,
    this.tonNhieuNhat,
    this.tonKho,
    this.giaVon,
    this.donViTinh,
    this.thuongHieu,
    this.loaiHang,
    this.trangThai,
    this.hinhAnh,
    this.quanLyTheoLo,
  });

  HangHoaModel copyWith({
    String? sId,
    String? maHangHoa,
    String? tenHangHoa,
    String? moTa,
    int? donGiaBan,
    double? tonNhieuNhat,
    double? tonKho,
    int? giaVon,
    String? donViTinh,
    List<String>? hinhAnh,
    String? trangThai,
    LoaiHangModel? loaiHang,
    ThuongHieuModel? thuongHieu,
    bool? quanLyTheoLo,
  }) {
    return HangHoaModel(
      sId: sId ?? this.sId,
      maHangHoa: maHangHoa ?? this.maHangHoa,
      tenHangHoa: tenHangHoa ?? this.tenHangHoa,
      moTa: moTa ?? this.moTa,
      donGiaBan: donGiaBan ?? this.donGiaBan,
      tonKho: tonKho ?? this.tonKho,
      giaVon: giaVon ?? this.giaVon,
      tonNhieuNhat: tonNhieuNhat ?? this.tonNhieuNhat,
      donViTinh: donViTinh ?? this.donViTinh,
      hinhAnh: hinhAnh ?? this.hinhAnh,
      trangThai: trangThai ?? this.trangThai,
      loaiHang: loaiHang ?? this.loaiHang,
      thuongHieu: thuongHieu ?? this.thuongHieu,
      quanLyTheoLo: quanLyTheoLo ?? this.quanLyTheoLo,
    );
  }

  HangHoaModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tenHangHoa = json['ten_hang_hoa'];
    maHangHoa = json['ma_hang_hoa'];
    moTa = json['mo_ta'];
    tonNhieuNhat = json['ton_nhieu_nhat'];
    donGiaBan = json['don_gia_ban'];
    tonKho = json['ton_kho'];
    giaVon = json['gia_von'];
    donViTinh = json['don_vi_tinh'];
    if (json['thuong_hieu'] != null) {
      thuongHieu = ThuongHieuModel.fromJson(json['thuong_hieu']);
    }
    if (json['loai_hang'] != null) {
      loaiHang = LoaiHangModel.fromJson(json['loai_hang']);
    }
    trangThai = json['trang_thai'];
    quanLyTheoLo = json['quan_ly_theo_lo'];
    hinhAnh =
        json['hinh_anh'] != null ? List<String>.from(json['hinh_anh']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['ten_hang_hoa'] = tenHangHoa;
    data['ma_hang_hoa'] = maHangHoa;
    data['ton_nhieu_nhat'] = tonNhieuNhat;
    data['mo_ta'] = moTa;
    data['don_gia_ban'] = donGiaBan;
    data['ton_kho'] = tonKho;
    data['gia_von'] = giaVon;
    data['don_vi_tinh'] = donViTinh;
    if (thuongHieu != null) {
      data['thuong_hieu'] = thuongHieu!.toJson();
    }
    if (loaiHang != null) {
      data['loai_hang'] = loaiHang!.toJson();
    }
    data['trang_thai'] = trangThai;
    data['quan_ly_theo_lo'] = quanLyTheoLo;
    if (hinhAnh != null) {
      data['hinh_anh'] = hinhAnh;
    }
    return data;
  }
}
