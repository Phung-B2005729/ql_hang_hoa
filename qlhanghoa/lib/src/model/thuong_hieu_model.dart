class ThuongHieuModel {
  String? sId;
  String? tenThuongHieu;

  ThuongHieuModel({this.sId, this.tenThuongHieu});

  ThuongHieuModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tenThuongHieu = json['ten_thuong_hieu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['ten_thuong_hieu'] = this.tenThuongHieu;
    return data;
  }
}
