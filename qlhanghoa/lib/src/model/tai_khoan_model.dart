class TaiKhoan {
  String? sId;
  String? userName;
  String? password;
  int? trangThai;
  int? phanQuyen;

  TaiKhoan(
      {this.sId, this.userName, this.password, this.trangThai, this.phanQuyen});

  TaiKhoan.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['user_name'];
    password = json['password'];
    trangThai = json['trang_thai'];
    phanQuyen = json['phan_quyen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_name'] = this.userName;
    data['password'] = this.password;
    data['trang_thai'] = this.trangThai;
    data['phan_quyen'] = this.phanQuyen;
    return data;
  }
}
