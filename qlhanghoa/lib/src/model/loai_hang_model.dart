class LoaiHangModel {
  String? sId;
  String? tenLoai;

  LoaiHangModel({this.sId, this.tenLoai});

  LoaiHangModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tenLoai = json['ten_loai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['ten_loai'] = this.tenLoai;
    return data;
  }
}
