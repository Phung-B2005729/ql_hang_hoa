import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/nhan_vien/them_nhan_vien_screen.dart';
import 'package:qlhanghoa/src/widget/nhan_vien/tim_kiem_nhan_vien_screen.dart';
import 'package:qlhanghoa/src/widget/nhan_vien/xem_chi_tiet_nhan_vien_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class NhanVienScreen extends StatelessWidget {
  NhanVienController nhanVienController = Get.find();
  CuaHangController cuaHangController = Get.find();
  NhanVienScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nhanVienController.getListNhanVien();
      if (cuaHangController.listCuaHang.isEmpty) {
        cuaHangController.getlistCuaHang();
      }
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
            child: GetBuilder<NhanVienController>(
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
                                                  .maNhanVien ??
                                              '');
                                      Get.to(() => XemChiTietNhanVienScreen());
                                    },
                                    // ignore: avoid_unnecessary_containers
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                controller.filteredList[index]
                                                        .tenNhanVien ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                controller.filteredList[index]
                                                        .maNhanVien ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.phone,
                                                      size: 14,
                                                      color: ColorClass
                                                          .color_cancel,
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                        controller
                                                                .filteredList[
                                                                    index]
                                                                .sdt ??
                                                            '',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: ColorClass
                                                              .color_cancel,
                                                        )),
                                                  ],
                                                ),
                                                Text(
                                                    (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .taiKhoan !=
                                                                null &&
                                                            controller
                                                                    .filteredList[
                                                                        index]
                                                                    .taiKhoan!
                                                                    .userName !=
                                                                null &&
                                                            controller
                                                                    .filteredList[
                                                                        index]
                                                                    .taiKhoan!
                                                                    .phanQuyen !=
                                                                null)
                                                        ? (controller
                                                                    .filteredList[
                                                                        index]
                                                                    .taiKhoan!
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
                                                                      .taiKhoan !=
                                                                  null &&
                                                              controller
                                                                      .filteredList[
                                                                          index]
                                                                      .taiKhoan!
                                                                      .userName !=
                                                                  null &&
                                                              controller
                                                                      .filteredList[
                                                                          index]
                                                                      .taiKhoan!
                                                                      .phanQuyen !=
                                                                  null)
                                                          ? (controller
                                                                      .filteredList[
                                                                          index]
                                                                      .taiKhoan!
                                                                      .phanQuyen ==
                                                                  0
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  10, 126, 222)
                                                              : Colors.green)
                                                          : Colors.red,
                                                    ))
                                              ],
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
        Obx(() => nhanVienController.loading.value == true
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
              title: (nhanVienController.onsubmit == true)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nhanVienController.thongTinChungController.text,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          cuaHangController
                                      .findCuaHang(
                                          nhanVienController.maCuaHang.value)
                                      .tenCuaHang !=
                                  null
                              ? cuaHangController
                                  .findCuaHang(
                                      nhanVienController.maCuaHang.value)
                                  .tenCuaHang
                                  .toString()
                              : nhanVienController.maCuaHang.value,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )
                  : const Text(
                      'Nhân viên',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),

              // leadingWidth: 10,
              leading: (nhanVienController.onsubmit == true)
                  ? IconButton(
                      onPressed: () async {
                        nhanVienController.reSetTimKiem();
                        nhanVienController.changeOnSubmit(false);
                        await nhanVienController.getListNhanVien();
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
                      nhanVienController.changeOnSubmit(false);
                      nhanVienController.reSetTimKiem();
                      Get.to(() => TimKiemNhanVienScreen());
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 28,
                    )),
                IconButton(
                    onPressed: () async {
                      CuaHangController cuaHangController = Get.find();
                      // ignore: unnecessary_null_comparison
                      if (cuaHangController.listCuaHang == null ||
                          cuaHangController.listCuaHang.isEmpty) {
                        await cuaHangController.getlistCuaHang();
                      }
                      cuaHangController.reSetTimKiem();
                      // chuyển đến trang thêm nhà cung cấp
                      nhanVienController.reSetDataThem();
                      Get.to(() => ThemNhanVienScreen(
                            edit: false,
                          ));
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
                    GetBuilder<NhanVienController>(
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
                    GetBuilder<NhanVienController>(
                      builder: (controller) => Text(
                        FunctionHelper.formNum(controller
                            .chuaCoTaiKhoan(controller.filteredList)
                            .toString()),
                        style: const TextStyle(
                            fontSize: 14, color: ColorClass.color_xanh_it_dam),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Text(
                      'Chưa có tài khoản',
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
}
