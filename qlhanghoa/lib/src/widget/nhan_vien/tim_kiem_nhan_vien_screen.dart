import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class TimKiemNhanVienScreen extends GetView<NhanVienController> {
  NhanVienController nhanVienController = Get.find();
  CuaHangController cuaHangController = Get.find();
  TimKiemNhanVienScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _builddAppBar(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Thông tin tìm kiếm',
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorClass.color_cancel,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                      _buildThongTinChung(),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                // chọn nhân viên và cửa hàng
                Column(mainAxisSize: MainAxisSize.min, children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Cửa hàng',
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorClass.color_cancel,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
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
                        ListTile(
                          onTap: () {
                            // mở select cửa hàng
                            (cuaHangController.listCuaHang.isNotEmpty)
                                ? _buildChooseCuaHang(context)
                                : GetShowSnackBar.warningSnackBar(
                                    'Chưa có danh sách cửa hàng');
                            ;
                          },
                          title: Obx(
                            () => Text(
                              cuaHangController
                                          .findCuaHang(
                                              controller.maCuaHang.value)
                                          .tenCuaHang !=
                                      null
                                  ? cuaHangController
                                      .findCuaHang(controller.maCuaHang.value)
                                      .tenCuaHang
                                      .toString()
                                  : controller.maCuaHang.value,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Chức vụ',
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorClass.color_cancel,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildChucVu(context),
                  const SizedBox(
                    height: 20,
                  ),
                  // chọn trạng thái
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Tài khoản',
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorClass.color_cancel,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTaiKhoan(context),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Trạng thái',
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorClass.color_cancel,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTrangThai(context),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
              ],
            ),
          ),
        ),
        Obx(() => controller.loading.value
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  Container _buildTrangThai(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              controller.changeListTrangThai('Tạm nghỉ');
            },
            child: GetBuilder<NhanVienController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color: controller.kiemTraList(
                              controller.trangThai, 'Tạm nghỉ') ==
                          true
                      ? ColorClass.color_xanh_it_dam
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorClass.color_thanh_ke.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'Tạm nghỉ',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.kiemTraList(
                                  controller.trangThai, 'Tạm nghỉ') ==
                              true
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeListTrangThai('Đang làm việc');
            },
            child: GetBuilder<NhanVienController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color: controller.kiemTraList(
                              controller.trangThai, 'Đang làm việc') ==
                          true
                      ? ColorClass.color_xanh_it_dam
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorClass.color_thanh_ke.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'Đang làm việc',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.kiemTraList(
                                  controller.trangThai, 'Đang làm việc') ==
                              true
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeListTrangThai('Đã nghỉ');
            },
            child: GetBuilder<NhanVienController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color:
                      controller.kiemTraList(controller.trangThai, 'Đã nghỉ') ==
                              true
                          ? ColorClass.color_xanh_it_dam
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorClass.color_thanh_ke.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'Đã nghỉ',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.kiemTraList(
                                  controller.trangThai, 'Đã nghỉ') ==
                              true
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildTaiKhoan(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              controller.changeChuaCoTaiKhoan();
            },
            child: Obx(
              () => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color: controller.chuaTaiKhoan.value == '1'
                      ? ColorClass.color_xanh_it_dam
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorClass.color_thanh_ke.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'Chưa có tài khoản',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.chuaTaiKhoan.value == '1'
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeCoTaiKhoan();
            },
            child: Obx(
              () => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color: controller.coTaiKhoan.value == '1'
                      ? ColorClass.color_xanh_it_dam
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorClass.color_thanh_ke.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'Đã có tài khoản',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.coTaiKhoan.value == '1'
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildChucVu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              controller.changeListChucVu('Nhân viên');
            },
            child: GetBuilder<NhanVienController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color:
                      controller.kiemTraList(controller.chucVu, 'Nhân viên') ==
                              true
                          ? ColorClass.color_xanh_it_dam
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorClass.color_thanh_ke.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'Nhân viên',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.kiemTraList(
                                  controller.chucVu, 'Nhân viên') ==
                              true
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeListChucVu('Quản lý');
            },
            child: GetBuilder<NhanVienController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color: controller.kiemTraList(controller.chucVu, 'Quản lý') ==
                          true
                      ? ColorClass.color_xanh_it_dam
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorClass.color_thanh_ke.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'Quản lý',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.kiemTraList(
                                  controller.chucVu, 'Quản lý') ==
                              true
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeListChucVu('Chủ cửa hàng');
            },
            child: GetBuilder<NhanVienController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color: controller.kiemTraList(
                              controller.chucVu, 'Chủ cửa hàng') ==
                          true
                      ? ColorClass.color_xanh_it_dam
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorClass.color_thanh_ke.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  'Chủ cửa hàng',
                  style: TextStyle(
                      fontSize: 15,
                      color: controller.kiemTraList(
                                  controller.chucVu, 'Chủ cửa hàng') ==
                              true
                          ? Colors.white
                          : Colors.black),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar _builddAppBar() {
    return AppBar(
      titleSpacing: 3,
      title: const Text(
        'Tìm kiếm nhân viên',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
          onPressed: () async {
            // reset các giá trị tìm kiếm
            controller.reSetTimKiem();
            // tìm kếm lại
            await controller.getListNhanVien();
            Get.back();
          },
          icon: const Icon(
            Icons.navigate_before,
            color: ColorClass.color_outline_icon,
            size: 28,
          )),
      actions: [
        TextButton(
            onPressed: () async {
              // gọi get list phiếu nhập
              controller.changeOnSubmit(true);
              await controller.getListNhanVien();
              Get.back();
            },
            child: const Text(
              'Áp dụng',
              style: TextStyle(
                fontSize: 18,
                color: ColorClass.color_xanh_it_dam,
              ),
            )),
      ],
    );
  }

  // ignore: unused_element

  Widget _buildThongTinChung() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: controller.thongTinChungController,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Mã, tên, số điện thoại hoặc địa chỉ',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 16),
      ),
    );
  }

  _buildChooseCuaHang(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // ignore: sized_box_for_whitespace
          return Container(
            height: MediaQuery.of(context).size.height *
                (((cuaHangController.listCuaHang.length) / 10 + 0.05) < 0.5
                    ? ((cuaHangController.listCuaHang.length) / 10 + 0.05)
                    : 0.5),
            child: cuaHangController.listCuaHang.length > 1
                ? GetBuilder<CuaHangController>(builder: (cuaHangController) {
                    return ListView.builder(
                        itemCount: cuaHangController.listCuaHang.length + 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Get.back();
                              // set chọn
                              controller.maCuaHang.value = (index == 0)
                                  ? 'Tất cả'
                                  : cuaHangController
                                      .listCuaHang[index - 1].maCuaHang
                                      .toString();
                            },
                            trailing: ((index != 0 &&
                                        cuaHangController.listCuaHang[index - 1]
                                                .maCuaHang
                                                .toString() ==
                                            controller.maCuaHang.value) ||
                                    (index == 0 &&
                                        (controller.maCuaHang.value == '' ||
                                            controller.maCuaHang.value ==
                                                'Tất cả')))
                                ? const Icon(
                                    Icons.check,
                                    color: ColorClass.color_xanh_it_dam,
                                  )
                                : null,
                            title: (index == 0)
                                ? const Text(
                                    'Tất cả',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    cuaHangController
                                        .listCuaHang[index - 1].tenCuaHang
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.black)),
                          );
                        });
                  })
                : ListTile(
                    onTap: () {
                      Get.back();
                      // set chọn
                      controller.maCuaHang.value =
                          cuaHangController.listCuaHang[0].maCuaHang.toString();
                    },
                    trailing: (cuaHangController.listCuaHang[0].maCuaHang
                                .toString() ==
                            controller.maCuaHang.value)
                        ? const Icon(
                            Icons.check,
                            color: ColorClass.color_xanh_it_dam,
                          )
                        : null,
                    title: Text(
                        cuaHangController.listCuaHang[0].tenCuaHang.toString(),
                        style: const TextStyle(color: Colors.black)),
                  ),
          );
        });
  }
}
