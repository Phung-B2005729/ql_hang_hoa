import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class XemTonKho extends StatelessWidget {
  CuaHangController cuaHangController = Get.find();
  ThemHangHoaController themHangHoaController = Get.find();
  HangHoaController hangHoaController = Get.find();
  XemTonKho({super.key});

  @override
  Widget build(Object context) {
    return Stack(
      children: [
        Scaffold(
            appBar: _buildAppBar(),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chi nhánh',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 90, 90, 90)),
                        ),
                        Text(
                          'Tồn kho',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 90, 90, 90)),
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
                      child: GetBuilder<CuaHangController>(
                          builder: (controller) => ListView.builder(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 30),
                              itemCount: controller.filteredList.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: ColorClass.color_thanh_ke)),
                                  ),
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (index == 0)
                                            ? 'Tất cả'
                                            : controller.filteredList[index - 1]
                                                .tenCuaHang
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: (index == 0)
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: (index == 0)
                                                ? ColorClass.color_button_nhat
                                                : Colors.black),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          FunctionHelper.formNum(hangHoaController
                                              .tongsoLuongTonKhoTrongListLoHang(
                                                  hangHoa: themHangHoaController
                                                      .hangHoaModel.value,
                                                  cuaHang: (index == 0)
                                                      ? 'Tất cả'
                                                      : controller
                                                          .filteredList[
                                                              index - 1]
                                                          .maCuaHang)
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: (index == 0)
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: (index == 0)
                                                  ? ColorClass.color_button_nhat
                                                  : Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }))),
                )
              ],
            )),
        Obx(() => cuaHangController.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        titleSpacing: 3,
        title: Text(
          'Tồn kho ${themHangHoaController.hangHoaModel.value.tenHangHoa.toString()}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              // chuyển về trang them hang hoa
              Get.back();
            },
            icon: const Icon(
              Icons.navigate_before_outlined,
              color: ColorClass.color_outline_icon,
              size: 40,
            )));
  }
}
