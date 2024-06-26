import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/giao_dich/giao_dich_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/xem_chi_tiet/chi_tiet_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/chi_tiet_phieu_nhap_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class XemGiaoDichScreen extends GetView<GiaoDichController> {
  CuaHangController cuaHangController = Get.find();
  ThemHangHoaController themHangHoaController = Get.find();
  XemGiaoDichScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: _buildAppBar(context),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            cuaHangController.cuaHangModel.value.tenCuaHang !=
                                    null
                                ? cuaHangController
                                    .cuaHangModel.value.tenCuaHang
                                    .toString()
                                : 'Tất cả',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 90, 90, 90)),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: ColorClass.color_thanh_ke.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(3, 0),
                          ),
                        ],
                      ),
                      child:
                          GetBuilder<GiaoDichController>(builder: (controller) {
                        return controller.filteredList.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      'Không có giao dịch theo yêu cầu',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromARGB(255, 121, 121, 121),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 0, bottom: 30),
                                itemCount: controller.filteredList.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  ColorClass.color_thanh_ke)),
                                    ),
                                    height: null,
                                    child: (index == 0)
                                        ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Giao dịch',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 121, 121, 121),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Giá vốn',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 121, 121, 121),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Số lượng',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 121, 121, 121),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Tồn cuối',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 121, 121, 121),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () async {
                                              if (controller
                                                      .filteredList[index - 1]
                                                      .loaiGiaoDich ==
                                                  'Nhập hàng') {
                                                ChiTietPhieuNhapController
                                                    chiTietPhieuNhapController =
                                                    Get.find();
                                                await chiTietPhieuNhapController
                                                    .getOnePhieuNhap(controller
                                                        .filteredList[index - 1]
                                                        .maPhieuNhap
                                                        .toString());
                                                Get.to(() =>
                                                    const ChiTietPhieuNhapScreen());
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        controller
                                                                .filteredList[
                                                                    index - 1]
                                                                .maPhieuNhap ??
                                                            (controller
                                                                    .filteredList[
                                                                        index -
                                                                            1]
                                                                    .maHoaDon ??
                                                                (controller
                                                                        .filteredList[
                                                                            index -
                                                                                1]
                                                                        .maPhieuKiemKho ??
                                                                    (controller
                                                                            .filteredList[index -
                                                                                1]
                                                                            .maCapNhat ??
                                                                        (controller.filteredList[index - 1].maXuatKho ??
                                                                            '')))),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        FunctionHelper.formNum(
                                                          controller
                                                              .filteredList[
                                                                  index - 1]
                                                              .giaVon
                                                              .toString(),
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        FunctionHelper.formNum(
                                                          controller
                                                              .filteredList[
                                                                  index - 1]
                                                              .soLuongGiaoDich
                                                              .toString(),
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: ColorClass
                                                              .color_xanh_it_dam,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        FunctionHelper.formNum(
                                                          controller
                                                              .filteredList[
                                                                  index - 1]
                                                              .soLuongTon
                                                              .toString(),
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      "${controller.filteredList[index - 1].loaiGiaoDich} vào ${FunctionHelper.formatDateTimeString(controller.filteredList[index - 1].thoiGianGiaoDich.toString())}",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromARGB(
                                                              255,
                                                              49,
                                                              49,
                                                              49))),
                                                )
                                              ],
                                            ),
                                          ),
                                  );
                                });
                      })),
                )
              ],
            )),
        Obx(() => controller.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        titleSpacing: 3,
        title: const Text(
          'Thẻ kho',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _buildChooseCuaHang(context);
              },
              icon: const Icon(
                Icons.store,
                color: Colors.black,
                size: 28,
              ))
        ],
        leading: IconButton(
            onPressed: () {
              // chuyển về trang them hang hoa
              controller.reSet();
              Get.back();
            },
            icon: const Icon(
              Icons.navigate_before,
              color: ColorClass.color_outline_icon,
              size: 40,
            )),
        bottom: _buildBottomSearch());
  }

  PreferredSize _buildBottomSearch() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: Column(
        children: [
          const Divider(
            color: Colors.black,
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 0),
            child: _buildTextFieldSearch(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSearch() {
    return Obx(
      () => TextField(
        controller: controller.searchController,
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
              borderSide:
                  const BorderSide(color: ColorClass.color_thanh_ke, width: 1),
              borderRadius: BorderRadius.circular(11)),
          hintText: 'Thời gian, loại giao dịch...',
          hintStyle: const TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 170, 170, 170)),
          prefixIcon: const Icon(
            Icons.search,
            color: ColorClass.color_thanh_ke,
          ),
          suffixIcon: controller.iconClose.value
              ? IconButton(
                  onPressed: () {
                    // delete value
                    controller.searchController.text = '';
                  },
                  icon: const Icon(Icons.close),
                  color: ColorClass.color_thanh_ke,
                )
              : null,
        ),
      ),
    );
  }

  _buildChooseCuaHang(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height *
                (((cuaHangController.listCuaHang.length) / 10 + 0.05) < 0.5
                    ? ((cuaHangController.listCuaHang.length) / 10 + 0.05)
                    : 0.5),
            child: GetBuilder<CuaHangController>(builder: (cuaHangController) {
              return ListView.builder(
                  itemCount: cuaHangController.listCuaHang.length + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        Get.back();
                        cuaHangController.findByMaCuaHang((index == 0)
                            ? 'Tất cả'
                            : cuaHangController.listCuaHang[index - 1].maCuaHang
                                .toString());
                        controller.filterlistGiaoDich(
                            maCuaHang: (index == 0)
                                ? 'Tất cả'
                                : cuaHangController
                                    .listCuaHang[index - 1].maCuaHang);
                      },
                      trailing: ((index != 0 &&
                                  cuaHangController
                                          .listCuaHang[index - 1].maCuaHang
                                          .toString() ==
                                      cuaHangController
                                          .cuaHangModel.value.maCuaHang
                                          .toString()) ||
                              (index == 0 &&
                                  cuaHangController
                                          .cuaHangModel.value.maCuaHang ==
                                      null))
                          ? const Icon(
                              Icons.check,
                              color: ColorClass.color_cancel,
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
                              style: TextStyle(color: Colors.black)),
                    );
                  });
            }),
          );
        });
  }
}
