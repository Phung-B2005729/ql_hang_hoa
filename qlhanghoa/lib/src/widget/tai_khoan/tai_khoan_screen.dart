import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/tai_khoan_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/model/tai_khoan_model.dart';
import 'package:qlhanghoa/src/widget/nhan_vien/xem_chi_tiet_nhan_vien_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';
import 'package:qlhanghoa/src/widget/tai_khoan/cap_mat_khau_moi_screen.dart';
import 'package:qlhanghoa/src/widget/tai_khoan/them_tai_khoan_screen_1.dart';
import 'package:qlhanghoa/src/widget/tai_khoan/tim_kiem_tai_khoan_sceen.dart';

// ignore: must_be_immutable
class TaiKhoanScreen extends StatelessWidget {
  TaiKhoanController taiKhoanController = Get.find();
  NhanVienController nhanVienController = Get.find();
  TaiKhoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taiKhoanController.getListTaiKhoan();
    });
    return Stack(
      children: [
        Scaffold(
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
            child: GetBuilder<TaiKhoanController>(
              builder: (controller) => (controller.filteredList.isEmpty)
                  ? const Center(child: Text('Không tìm thấy kết quả phù hợp'))
                  : ListView.builder(
                      itemCount: controller.filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Column(
                            children: [
                              Obx(
                                () => GestureDetector(
                                    onTap: () async {
                                      // chuyển đến xem chi tiết nhà cung cấp
                                      await nhanVienController.getOneNhanVien(
                                          controller.filteredList[index]
                                                  .userName ??
                                              '');
                                      Get.to(() => XemChiTietNhanVienScreen());
                                    },
                                    // ignore: avoid_unnecessary_containers
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                controller.filteredList[index]
                                                        .userName ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              PopupMenuButton(
                                                  icon: const Icon(
                                                      Icons.more_vert),
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          <PopupMenuEntry>[
                                                            if (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .trangThai !=
                                                                0)
                                                              PopupMenuItem(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    taiKhoanController
                                                                        .setTaiKhoanThem(
                                                                      taiKhoan:
                                                                          controller
                                                                              .filteredList[index],
                                                                    );
                                                                    Get.to(() =>
                                                                        CapMatKhauMoiScreen());
                                                                  },
                                                                  child:
                                                                      const Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        'Cấp mật khẩu mới',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Divider(
                                                                        color: ColorClass
                                                                            .color_thanh_ke,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            if (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .phanQuyen ==
                                                                1)
                                                              PopupMenuItem(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Get.dialog(_AletDiaLogNhapAdminPass(
                                                                        taiKhoan:
                                                                            controller.filteredList[
                                                                                index],
                                                                        capQuyenAdmin:
                                                                            true));
                                                                  },
                                                                  child:
                                                                      const Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Cấp quyền admin',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Divider(
                                                                        color: ColorClass
                                                                            .color_thanh_ke,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            if (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .phanQuyen ==
                                                                0)
                                                              PopupMenuItem(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Get.dialog(_AletDiaLogNhapAdminPass(
                                                                        taiKhoan:
                                                                            controller.filteredList[
                                                                                index],
                                                                        xoaQuyenAdmin:
                                                                            true));
                                                                  },
                                                                  child:
                                                                      const Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Xoá quyền admin',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Divider(
                                                                        color: ColorClass
                                                                            .color_thanh_ke,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            if (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .trangThai ==
                                                                1)
                                                              PopupMenuItem(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Get.dialog(_AletDiaLogNhapAdminPass(
                                                                        taiKhoan:
                                                                            controller.filteredList[
                                                                                index],
                                                                        khoaTaiKhoan:
                                                                            true));
                                                                  },
                                                                  child:
                                                                      const Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Khoá tài khoản',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Divider(
                                                                        color: ColorClass
                                                                            .color_thanh_ke,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            if (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .trangThai ==
                                                                0)
                                                              PopupMenuItem(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Get.dialog(_AletDiaLogNhapAdminPass(
                                                                        taiKhoan:
                                                                            controller.filteredList[
                                                                                index],
                                                                        moTaiKhoan:
                                                                            true));
                                                                  },
                                                                  child:
                                                                      const Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'Mở tài khoản',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Divider(
                                                                        color: ColorClass
                                                                            .color_thanh_ke,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            PopupMenuItem(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Get.dialog(_AletDiaLogNhapAdminPass(
                                                                      taiKhoan:
                                                                          controller.filteredList[
                                                                              index],
                                                                      xoaTaiKhoan:
                                                                          true));
                                                                },
                                                                child:
                                                                    const Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Xoá tài khoản',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Divider(
                                                                      color: ColorClass
                                                                          .color_thanh_ke,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ])
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                (controller.filteredList[index]
                                                                .nhanVien !=
                                                            null &&
                                                        controller
                                                                .filteredList[
                                                                    index]
                                                                .nhanVien!
                                                                .tenNhanVien !=
                                                            null)
                                                    ? controller
                                                        .filteredList[index]
                                                        .nhanVien!
                                                        .tenNhanVien!
                                                    : '',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      ColorClass.color_cancel,
                                                )),
                                          ),
                                          GetBuilder<TaiKhoanController>(
                                            builder: (controller) => Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      (controller
                                                                  .filteredList[
                                                                      index]
                                                                  .phanQuyen !=
                                                              null)
                                                          ? (controller
                                                                      .filteredList[
                                                                          index]
                                                                      .phanQuyen ==
                                                                  0
                                                              ? 'Tài khoản: admin'
                                                              : 'Tài khoản: nhân viên')
                                                          : 'Chưa có tài khoản',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .phanQuyen !=
                                                                null)
                                                            ? (controller
                                                                        .filteredList[
                                                                            index]
                                                                        .phanQuyen ==
                                                                    0
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    10,
                                                                    126,
                                                                    222)
                                                                : Colors.green)
                                                            : Colors.red,
                                                      )),
                                                  Text(
                                                      (controller
                                                                  .filteredList[
                                                                      index]
                                                                  .trangThai !=
                                                              null)
                                                          ? (controller
                                                                      .filteredList[
                                                                          index]
                                                                      .trangThai ==
                                                                  0
                                                              ? 'Đã khoá'
                                                              : 'Đang hoạt động')
                                                          : '',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color: (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .trangThai ==
                                                                0)
                                                            ? Colors.red
                                                            : ColorClass
                                                                .color_xanh_it_dam,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            color: ColorClass.color_thanh_ke,
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        );
                      }),
            ),
          ),
        ),
        Obx(() => taiKhoanController.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorClass.color_thanh_ke.withOpacity(
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
          child: Obx(
            () => AppBar(
              //backgroundColor: Colors.white,
              titleSpacing: 2,
              title: (taiKhoanController.onsubmit.value == true)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ignore: unnecessary_null_comparison
                        if (taiKhoanController.thongTinChungController.text !=
                                null &&
                            taiKhoanController.thongTinChungController.text !=
                                '')
                          Text(
                            taiKhoanController.thongTinChungController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        Row(
                          children: [
                            if (taiKhoanController.kiemTraList(
                                taiKhoanController.phanQuyen, '0'))
                              const Text(
                                'admin',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 139, 139, 139),
                                ),
                              ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (taiKhoanController.kiemTraList(
                                taiKhoanController.phanQuyen, '1'))
                              const Text(
                                'nhân viên',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 139, 139, 139),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            if (taiKhoanController.kiemTraList(
                                taiKhoanController.trangThai, '1'))
                              const Text(
                                'đang hoạt động',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 139, 139, 139),
                                ),
                              ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (taiKhoanController.kiemTraList(
                                taiKhoanController.trangThai, '0'))
                              const Text(
                                'đã khoá',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 139, 139, 139),
                                ),
                              ),
                          ],
                        )
                      ],
                    )
                  : const Text(
                      'Tài khoản',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),

              // leadingWidth: 10,
              leading: (taiKhoanController.onsubmit == true)
                  ? IconButton(
                      onPressed: () async {
                        taiKhoanController.reSetTimKiem();
                        taiKhoanController.changeOnSubmit(false);
                        await taiKhoanController.getListTaiKhoan();
                      },
                      icon: const Icon(
                        Icons.navigate_before,
                        size: 30,
                      ))
                  : IconButton(
                      onPressed: () async {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.navigate_before,
                        size: 30,
                      )),
              actions: [
                IconButton(
                    onPressed: () {
                      // mở trang tìm kiếm
                      taiKhoanController.changeOnSubmit(false);
                      taiKhoanController.reSetTimKiem();
                      Get.to(() => TimKiemTaiKhoanScreen());
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 28,
                    )),
                IconButton(
                    onPressed: () async {
                      NhanVienController nhanVienController = Get.find();
                      nhanVienController.searchController.text = '';
                      Get.to(() => ThemTaiKhoanScreen1());
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 28,
                    )),
              ],
              bottom: _buildBottomAppBar(),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _buildBottomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 20, right: 10, top: 0),
        child: Column(
          children: [
            const Divider(
              color: Color.fromARGB(255, 114, 114, 114),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<TaiKhoanController>(
                      builder: (controller) => Text(
                        controller.filteredList.length.toString(),
                        style: const TextStyle(
                            fontSize: 14, color: ColorClass.color_xanh_it_dam),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Nhân viên',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<TaiKhoanController>(
                      builder: (controller) => Text(
                        FunctionHelper.formNum(controller
                            .countTaiKhoanAdmin(controller.filteredList)
                            .toString()),
                        style: const TextStyle(
                            fontSize: 14, color: ColorClass.color_xanh_it_dam),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Text(
                      'tài khoản admin',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names, unused_element
  Widget _AletDiaLogNhapAdminPass(
      {bool? khoaTaiKhoan,
      bool? moTaiKhoan,
      bool? xoaTaiKhoan,
      required TaiKhoanModel taiKhoan,
      bool? xoaQuyenAdmin,
      bool? capQuyenAdmin}) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        title: const Text(
          'Xác nhận lại mật khẩu admin',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        content: Form(
          key: taiKhoanController.formKeyAdmin,
          child: Obx(
            () => TextFormField(
              controller: taiKhoanController.adminPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập vào mật khẩu admin';
                }
                return null;
              },
              onSaved: (newValue) {
                taiKhoanController.taiKhoanModel.value.adminPassword = newValue;
              },
              obscureText: !taiKhoanController.showAdminPassword.value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorClass.color_button_nhat, width: 1),
                ),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.black,
                )),
                hintText: 'Nhập vào mật khẩu admin',
                hintStyle: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 170, 170, 170)),
                suffixIcon: IconButton(
                  icon: Icon(taiKhoanController.showAdminPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    taiKhoanController.showAdminPassword.value =
                        !taiKhoanController.showAdminPassword.value;
                  },
                ),
                suffixIconColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.focused)
                        ? ColorClass.color_button
                        : Colors.grey),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'THOÁT',
              style: TextStyle(color: ColorClass.color_cancel, fontSize: 18),
            ),
            onPressed: () {
              taiKhoanController.adminPasswordController.text = '';
              Get.back();
            },
          ),
          TextButton(
            child: const Text(
              'Hoàn thành',
              style:
                  TextStyle(color: ColorClass.color_button_nhat, fontSize: 18),
            ),
            onPressed: () async {
              // gọi update

              if (xoaTaiKhoan == true) {
                bool ktr =
                    await taiKhoanController.adminDeleteTaiKhoan(taiKhoan);
                if (ktr == true) {
                  //taiKhoanController.adminPasswordController.text = '';
                  GetShowSnackBar.successSnackBar('Đã xoá');
                }
              } else {
                bool ktr = await taiKhoanController.updateTaiKhoan(
                    taiKhoan: taiKhoan,
                    khoaTaiKhoan: khoaTaiKhoan,
                    moTaiKhoan: moTaiKhoan,
                    capQuyenAdmin: capQuyenAdmin,
                    xoaQuyenAdmin: xoaQuyenAdmin);
                if (ktr == true) {
                  //taiKhoanController.adminPasswordController.text = '';
                  GetShowSnackBar.successSnackBar('Thành công');
                }
              }
            },
          ),
        ]);
  }
}
