import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';

import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class ChonCuaHangScreen extends StatelessWidget {
  CuaHangController cuaHangController = Get.find();
  NhanVienController nhanVienController = Get.find();
  ChonCuaHangScreen({super.key});

  @override
  Widget build(Object context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: GetBuilder<CuaHangController>(
            builder: (controller) => ListView.builder(
                itemCount: controller.filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Obx(
                          () => ListTile(
                            onTap: () {
                              // cập nhật controllerLoaiHang bên ThemHangHoaController và HangHoaModel.loaiHang = listLoaiHang[index]
                              nhanVienController
                                  .chonCuaHang(controller.filteredList[index]);
                              Get.back();
                            },
                            title: Text(
                              controller.filteredList[index].tenCuaHang!,
                              style: const TextStyle(color: Colors.black),
                            ),
                            selected: nhanVienController
                                    .nhanVienModel.value.maCuaHang ==
                                controller.filteredList[index].maCuaHang,
                            trailing: nhanVienController
                                        .nhanVienModel.value.maCuaHang ==
                                    controller.filteredList[index].maCuaHang
                                ? const Icon(
                                    Icons.check,
                                    color: ColorClass.color_button_nhat,
                                  )
                                : null,
                          ),
                        ),
                        const Divider(
                          color: ColorClass.color_thanh_ke,
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
        Obx(() => cuaHangController.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        titleSpacing: 3,
        title: const Text(
          'Cửa hàng',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              // chuyển về trang them hang hoa
              cuaHangController.reSetTimKiem();
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
                // chuyển đến trang thêm cửa hàng
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
          controller: cuaHangController.searchController,
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
            hintText: 'Mã, tên, sdt, địa chỉ của cửa hàng',
            hintStyle: const TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 170, 170, 170)),
            prefixIcon: const Icon(
              Icons.search,
              color: ColorClass.color_thanh_ke,
            ),
            suffixIcon: cuaHangController.iconClose.value
                ? IconButton(
                    onPressed: () {
                      // delete value
                      cuaHangController.searchController.text = '';
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
