import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/tai_khoan_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class TimKiemTaiKhoanScreen extends GetView<TaiKhoanController> {
  const TimKiemTaiKhoanScreen({super.key});

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
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Quyền tài khoản',
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
                  _buildPhanQuyen(context),
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
              controller.changeListTrangThai('0');
            },
            child: GetBuilder<TaiKhoanController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color:
                      controller.kiemTraList(controller.trangThai, '0') == true
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
                  'Đã khoá',
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          controller.kiemTraList(controller.trangThai, '0') ==
                                  true
                              ? Colors.white
                              : Colors.black),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeListTrangThai('1');
            },
            child: GetBuilder<TaiKhoanController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color:
                      controller.kiemTraList(controller.trangThai, '1') == true
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
                  'Đang hoạt động',
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          controller.kiemTraList(controller.trangThai, '1') ==
                                  true
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

  Container _buildPhanQuyen(BuildContext context) {
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
              controller.changeListPhanQuyen('0');
            },
            child: GetBuilder<TaiKhoanController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color:
                      controller.kiemTraList(controller.phanQuyen, '0') == true
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
                  'Admin',
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          controller.kiemTraList(controller.phanQuyen, '0') ==
                                  true
                              ? Colors.white
                              : Colors.black),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.changeListPhanQuyen('1');
            },
            child: GetBuilder<TaiKhoanController>(
              builder: (controller) => Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 158, 158, 158), // Màu viền
                    // Độ rộng viền
                  ),
                  color:
                      controller.kiemTraList(controller.phanQuyen, '1') == true
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
                      color:
                          controller.kiemTraList(controller.phanQuyen, '1') ==
                                  true
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

  AppBar _builddAppBar() {
    return AppBar(
      titleSpacing: 3,
      title: const Text(
        'Tìm kiếm tài khoản',
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
            await controller.getListTaiKhoan();
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
              await controller.getListTaiKhoan();
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
        hintText: 'Username, họ tên, mã nhân viên',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 16),
      ),
    );
  }
}
