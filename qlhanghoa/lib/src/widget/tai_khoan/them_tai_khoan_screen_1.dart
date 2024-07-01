import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/tai_khoan_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/model/tai_khoan_model.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/tai_khoan/them_tai_khoan_screen_2.dart';

// ignore: must_be_immutable
class ThemTaiKhoanScreen1 extends StatelessWidget {
  NhanVienController nhanVienController = Get.find();
  ThemTaiKhoanScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nhanVienController.getListNhanVien(getChuaTaiKhoan: true);
    });
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(top: 5),
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
                                      TaiKhoanController taiKhoanController =
                                          Get.find();
                                      taiKhoanController.setTaiKhoanThem(
                                          taiKhoan: controller
                                                  .filteredList[index]
                                                  .taiKhoan ??
                                              TaiKhoanModel(),
                                          nhanVienModel:
                                              controller.filteredList[index]);
                                      Get.to(() => ThemTaiKhoanScreen2(
                                            themTuNhanVien: true,
                                          ));
                                      // cập nhật tài khoản model để thêm// chuyển đến trang thêm 2
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
                                                    controller
                                                                .filteredList[
                                                                    index]
                                                                .chucVu !=
                                                            null
                                                        ? controller
                                                            .filteredList[index]
                                                            .chucVu!
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: controller
                                                                  .filteredList[
                                                                      index]
                                                                  .chucVu ==
                                                              'Chủ cửa hàng'
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 22, 129, 216)
                                                          : (controller
                                                                      .filteredList[
                                                                          index]
                                                                      .chucVu ==
                                                                  'Quản lý'
                                                              ? Colors.green
                                                              : const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  204,
                                                                  186,
                                                                  22)),
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

  AppBar _buildAppBar() {
    return AppBar(
        titleSpacing: 3,
        title: const Text(
          'Nhân viên chưa có tài khoản',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              // chuyển về trang them hang hoa
              Get.back();
            },
            icon: const Icon(
              Icons.close,
              color: ColorClass.color_outline_icon,
              size: 28,
            )),
        actions: [
          IconButton(
              onPressed: () {
                // chuyển đến trang thêm nhà cung cấp
                TaiKhoanController taiKhoanController = Get.find();
                taiKhoanController.reSetThem();
                Get.to(() => ThemTaiKhoanScreen2(
                      themTuNhanVien: false,
                    ));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 28,
              )),
        ],
        bottom: _buildBottomSearch());
  }

  PreferredSize _buildBottomSearch() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: Column(
        children: [
          const Divider(
            color: Colors.black,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 0),
            child: _buildTextFieldSearch(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSearch() {
    return Center(
      child: Obx(
        () => TextField(
          controller: nhanVienController.searchController,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: ColorClass.color_thanh_ke, width: 1),
              borderRadius: BorderRadius.circular(11),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 237, 237, 237), width: 1),
              borderRadius: BorderRadius.circular(11),
            ),
            fillColor: const Color(0xFFE6E4E4),
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: ColorClass.color_thanh_ke, width: 1),
                borderRadius: BorderRadius.circular(11)),
            hintText: 'Mã, tên ncc',
            hintStyle: const TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 170, 170, 170)),
            prefixIcon: const Icon(
              Icons.search,
              color: ColorClass.color_thanh_ke,
            ),
            suffixIcon: nhanVienController.iconClose.value
                ? IconButton(
                    onPressed: () {
                      // delete value
                      nhanVienController.searchController.text = '';
                    },
                    icon: const Icon(Icons.close),
                    color: ColorClass.color_thanh_ke,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
