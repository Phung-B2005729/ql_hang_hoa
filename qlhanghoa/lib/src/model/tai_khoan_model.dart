import 'package:qlhanghoa/src/model/nhan_vien_model.dart';

class TaiKhoanModel {
  String? sId;
  String? userName;
  String? password;
  String? confirmPassword;
  String? adminPassword;
  String? userNameAdmin;
  int? trangThai;
  String? oldPassword;
  int? phanQuyen;
  NhanVienModel? nhanVien;

  TaiKhoanModel(
      {this.sId,
      this.userName,
      this.confirmPassword,
      this.adminPassword,
      this.userNameAdmin,
      this.password,
      this.trangThai,
      this.oldPassword,
      this.nhanVien,
      this.phanQuyen});
  TaiKhoanModel copyWith(
      {String? sId,
      String? userName,
      String? password,
      String? confirmPassword,
      String? adminPassword,
      String? userNameAdmin,
      int? trangThai,
      String? oldPassword,
      int? phanQuyen,
      NhanVienModel? nhanVien}) {
    return TaiKhoanModel(
        sId: sId ?? this.sId,
        userName: userName ?? this.userName,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        adminPassword: adminPassword ?? this.adminPassword,
        userNameAdmin: userNameAdmin ?? this.userNameAdmin,
        trangThai: trangThai ?? trangThai,
        oldPassword: oldPassword ?? oldPassword,
        phanQuyen: phanQuyen ?? phanQuyen,
        nhanVien: nhanVien ?? this.nhanVien);
  }

  TaiKhoanModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['user_name'];
    confirmPassword = json['confirm_password'];
    userNameAdmin = json['user_name_admin'];
    adminPassword = json['admin_password'];
    password = json['password'];
    trangThai = json['trang_thai'];
    phanQuyen = json['phan_quyen'];
    oldPassword = json['old_password'];
    nhanVien =
        json['nhan_vien_info'] != null && json['nhan_vien_info'].isNotEmpty
            ? NhanVienModel.fromJson(json['nhan_vien_info'][0])
            : null;
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['user_name'] = userName;
    data['password'] = password;
    data['trang_thai'] = trangThai;
    data['phan_quyen'] = phanQuyen;
    data['confirm_password'] = confirmPassword;
    data['user_name_admin'] = userNameAdmin;
    data['admin_password'] = adminPassword;
    data['old_password'] = oldPassword;
    return data;
  }
}
