import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/cua_hang/cua_hang_screen.dart';
import 'package:qlhanghoa/src/widget/nha_cung_cap/nha_cung_cap_screen.dart';
import 'package:qlhanghoa/src/widget/nhan_vien/nhan_vien_screen.dart';
import 'package:qlhanghoa/src/widget/tai_khoan/tai_khoan_screen.dart';

class NhieuHonScreen extends StatelessWidget {
  final AuthController controller = Get.find();

  NhieuHonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setUpData();
    });
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
          // margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: ColorClass.color_thanh_ke.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(3, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    // chuyển trang nhà cung cấp
                    Get.to(() => NhaCungCapScreen());
                  },
                  title: const Text('Nhà cung cấp',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  leading: const Icon(Icons.people, color: Colors.black),
                ),
                const Divider(
                  color: ColorClass.color_thanh_ke,
                ),
                ListTile(
                  onTap: () {
                    // chuyển trang nhân viên
                    Get.to(() => NhanVienScreen());
                  },
                  title: const Text('Nhân viên',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  leading: const Icon(Icons.people, color: Colors.black),
                ),
                const Divider(
                  color: ColorClass.color_thanh_ke,
                ),
                (controller.thongTinCaNhan.value.taiKhoan != null &&
                        controller.thongTinCaNhan.value.taiKhoan!.phanQuyen ==
                            0)
                    ? ListTile(
                        onTap: () {
                          // chuyển trang tài khoản
                          Get.to(() => TaiKhoanScreen());
                        },
                        title: const Text('Tài khoản người dùng',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        leading: const Icon(Icons.person, color: Colors.black),
                      )
                    : const SizedBox(),
                (controller.thongTinCaNhan.value.taiKhoan != null &&
                        controller.thongTinCaNhan.value.taiKhoan!.phanQuyen ==
                            0)
                    ? const Divider(
                        color: ColorClass.color_thanh_ke,
                      )
                    : const SizedBox(),
                ListTile(
                  onTap: () {
                    // chuyển trang cửa hàng
                    Get.to(() => CuaHangScreen());
                  },
                  title: const Text('Cửa hàng',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  leading:
                      const Icon(Icons.account_balance, color: Colors.black),
                ),
                const Divider(
                  color: ColorClass.color_thanh_ke,
                ),
                ListTile(
                  onTap: () {
                    // chuyển trang báo cáo
                  },
                  title: const Text('Báo cáo',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  leading: const Icon(Icons.assessment, color: Colors.black),
                ),
                const Divider(
                  color: ColorClass.color_thanh_ke,
                ),
                ListTile(
                  onTap: () {
                    controller.logout();
                  },
                  title: const Text('Đăng xuất',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w600)),
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                ),
                const Divider(
                  color: ColorClass.color_thanh_ke,
                )
              ],
            ),
          )),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(140),
      child: Container(
        // margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 137, 137, 137).withOpacity(
                  0.2), //withOpacity(0.2) sẽ làm màu đó trở nên trong suốt 20%. Điều này làm cho bóng mờ hơn so với màu gốc.
              spreadRadius: 5,
              blurRadius: 7, // tạo độ mờ
              offset: const Offset(0, 3), // dịch chuyên vị trí shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(29),
              bottomRight: Radius.circular(29)),
          child: AppBar(
            leading: Container(
              margin: const EdgeInsets.only(left: 10),
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundColor: const Color(0xFF75A1E4),
                child: Obx(
                  () => Text(
                    controller.hoTen.value != null
                        ? FunctionHelper.getInitials(controller.hoTen.value!)
                        : '',
                    style:
                        const TextStyle(fontSize: 20, color: Color(0xFF033869)),
                  ),
                ),
              ),
            ),
            //backgroundColor: Colors.white,
            title: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Text(
                    controller.hoTen.value != null
                        ? controller.hoTen.value!
                        : '',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(
                  // ignore: unnecessary_null_comparison
                  () => (controller.thongTinCaNhan.value != null &&
                          controller.thongTinCaNhan.value.cuaHang != null &&
                          controller.thongTinCaNhan.value.cuaHang!.tenCuaHang !=
                              null)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                              controller
                                  .thongTinCaNhan.value.cuaHang!.tenCuaHang
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: ColorClass.color_cancel,
                              )),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Chi nhánh trung tâm...',
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorClass.color_cancel,
                              )),
                        ),
                )
              ],
            ),
            //  titleSpacing: 20,
            //titleTextStyle: AppTheme.lightTextTheme.titleLarge,
            actions: [
              Container(
                margin: const EdgeInsets.only(
                  right: 20,
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // chuyển đến edit user
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
