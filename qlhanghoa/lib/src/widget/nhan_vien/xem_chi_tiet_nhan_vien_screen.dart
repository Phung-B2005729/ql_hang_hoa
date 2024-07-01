import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/nhan_vien/them_nhan_vien_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class XemChiTietNhanVienScreen extends StatelessWidget {
  XemChiTietNhanVienScreen({super.key});

  final NhanVienController nhanVienController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Obx(
              () => Text(
                nhanVienController.nhanVienModel.value.tenNhanVien ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.navigate_before,
                color: Colors.black,
                size: 28,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  // mở trang edit

                  nhanVienController.setUpDataEdit();
                  Get.to(() => ThemNhanVienScreen(
                        edit: true,
                      ));
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () async {
                  // xoá nhà NV
                  Get.dialog(_buildXaNVhanXoa(), barrierDismissible: false);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
          body: _buildThongTin(),
        ),
        Obx(() => nhanVienController.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  AlertDialog _buildXaNVhanXoa() {
    return AlertDialog(
      title: const Text(
        'Bạn có chắc chắn muốn thoát ?',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      content: const Text('Lưu ý:  dữ liệu sẽ không được lưu nếu thoát',
          style: TextStyle(color: Colors.black, fontSize: 16)),
      actions: [
        TextButton(
          child: const Text(
            'HUỶ',
            style: TextStyle(color: ColorClass.color_cancel, fontSize: 18),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: const Text(
            'XOÁ',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          onPressed: () async {
            Get.back();
            bool ktr = await nhanVienController
                .delete(nhanVienController.nhanVienModel.value);
            if (ktr == true) {
              GetShowSnackBar.successSnackBar(
                  '${nhanVienController.nhanVienModel.value.tenNhanVien} đã được xóa');
              Get.back();
            }
          },
        ),
      ],
    );
  }

  SingleChildScrollView _buildThongTin() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Thông tin nhân viên',
                style: TextStyle(fontSize: 15, color: ColorClass.color_cancel),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            width: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorClass.color_thanh_ke.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(3, 0),
                ),
              ],
            ),
            child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRowMaNhanVien(),
                _buildRowtenNhanVien(),
                _buildRowGioiTinhNhanVien(),
                _buildRowEmailNhanVien(),
                _buildRowSDTNhanVien(),
                _buildRowDiaChiNhanVien(),
                _buildRowTenChiNhanh(),
                _buildRowChucVuNhanVien(),
                _buildRowGhiChuNhanVien(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          (nhanVienController.nhanVienModel.value.taiKhoan != null &&
                  nhanVienController.nhanVienModel.value.taiKhoan!.userName !=
                      null &&
                  nhanVienController.nhanVienModel.value.taiKhoan!.trangThai !=
                      null &&
                  nhanVienController.nhanVienModel.value.taiKhoan!.phanQuyen !=
                      null)
              ? _buildTaiKhoan()
              : const SizedBox(),
        ],
      ),
    );
  }

  Container _buildTaiKhoan() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      // height: 80,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorClass.color_thanh_ke.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(3, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tài khoản người dùng',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        if (nhanVienController
                                .nhanVienModel.value.taiKhoan!.trangThai !=
                            0)
                          PopupMenuItem(
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Cấp mật khẩu mới',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: ColorClass.color_thanh_ke,
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (nhanVienController
                                .nhanVienModel.value.taiKhoan!.phanQuyen ==
                            1)
                          PopupMenuItem(
                            child: GestureDetector(
                              onTap: () {},
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cấp quyền admin',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: ColorClass.color_thanh_ke,
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (nhanVienController
                                .nhanVienModel.value.taiKhoan!.phanQuyen ==
                            0)
                          PopupMenuItem(
                            child: GestureDetector(
                              onTap: () {},
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Xoá quyền admin',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: ColorClass.color_thanh_ke,
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (nhanVienController
                                .nhanVienModel.value.taiKhoan!.trangThai ==
                            1)
                          PopupMenuItem(
                            child: GestureDetector(
                              onTap: () {},
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Khoá tài khoản',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: ColorClass.color_thanh_ke,
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (nhanVienController
                                .nhanVienModel.value.taiKhoan!.trangThai ==
                            0)
                          PopupMenuItem(
                            child: GestureDetector(
                              onTap: () {},
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mở tài khoản',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: ColorClass.color_thanh_ke,
                                  )
                                ],
                              ),
                            ),
                          ),
                        PopupMenuItem(
                          child: GestureDetector(
                            onTap: () {},
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Xoá tài khoản',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.red),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Divider(
                                  color: ColorClass.color_thanh_ke,
                                )
                              ],
                            ),
                          ),
                        ),
                      ])
            ],
          ),
          const Divider(
            color: ColorClass.color_thanh_ke,
          ),
          _buildRowUsername(),
          _buildRowTaiKhoan(),
          _buildRowTrangThai(),
        ],
      ),
    );
  }

  Row _buildRowUsername() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Username',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.taiKhoan!.userName ??
                      '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              ),
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowTaiKhoan() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Tài khoản',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.taiKhoan!.phanQuyen ==
                          0
                      ? 'Admin'
                      : 'Nhân viên',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowTrangThai() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Trạng thái',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.taiKhoan!.trangThai ==
                          1
                      ? 'Đang hoạt động'
                      : 'Đã khoá',
                  style: TextStyle(
                    fontSize: 16,
                    color: nhanVienController
                                .nhanVienModel.value.taiKhoan!.trangThai ==
                            1
                        ? ColorClass.color_xanh_it_dam
                        : Colors.red,
                  ),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowMaNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Mã NV',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.maNhanVien ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowtenNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Tên NV',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.tenNhanVien ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowEmailNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.email ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowSDTNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Số điện thoại',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.sdt ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowTenChiNhanh() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Thuộc chi nhánh',
          softWrap: true,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.cuaHang != null &&
                          nhanVienController
                                  .nhanVienModel.value.cuaHang!.tenCuaHang !=
                              null
                      ? nhanVienController
                          .nhanVienModel.value.cuaHang!.tenCuaHang!
                      : '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowDiaChiNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Địa chi',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.diaChi ?? '',
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowGioiTinhNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Giới tính',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.gioiTinh == null
                      ? ''
                      : ((nhanVienController.nhanVienModel.value.gioiTinh ==
                              true)
                          ? 'Nam'
                          : 'Nữ'),
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowChucVuNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Chức vụ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.chucVu ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowGhiChuNhanVien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Ghi chú',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhanVienController.nhanVienModel.value.ghiChu ?? '',
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }
}
