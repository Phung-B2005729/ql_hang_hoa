import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/lo_hang/lo_hang_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/app_theme.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class XemLoHangHSD extends GetView<LoHangController> {
  XemLoHangHSD({super.key});
  CuaHangController cuaHangController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Obx(
            () => (controller.filteredList.isEmpty)
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              cuaHangController.cuaHangModel.value.tenCuaHang ??
                                  'Tất cả cửa hàng',
                              style: const TextStyle(
                                  color: ColorClass.color_cancel,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height:
                              300, // Ensure the container has a fixed height
                          width: 400,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/empty.jpg'),
                              fit: BoxFit
                                  .cover, // Tùy chọn: để hình ảnh vừa khít với container
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text('Chưa có lô hàng theo yêu cầu'),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cuaHangController.cuaHangModel.value.tenCuaHang ??
                                  'Tất cả cửa hàng'.toString(),
                              style: const TextStyle(
                                  color: ColorClass.color_cancel,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                            Obx(
                              () => Text(
                                FunctionHelper.formNum(controller.tongsoLuong(
                                    listLoHang: controller.filteredList,
                                    maCuaHang: cuaHangController
                                            .cuaHangModel.value.maCuaHang ??
                                        'Tất cả')),
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ColorClass.color_xanh_it_dam),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorClass.color_thanh_ke
                                      .withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(3, 0),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 30),
                                itemCount: controller.filteredList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      // chuyển đến trang thêm + edit

                                      // xem chi tiết tồn kho của lô hàng trong từng cửa hàng
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 20, bottom: 5),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color:
                                                    ColorClass.color_thanh_ke)),
                                      ),
                                      height: 70,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: const BoxDecoration(
                                                        color: ColorClass
                                                            .color_button_nhat,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: const Center(
                                                      child: Text(
                                                        'Lô',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    controller
                                                        .filteredList[index]
                                                        .soLo
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )
                                                ],
                                              ),
                                              Obx(
                                                () => Text(
                                                  FunctionHelper.formNum(controller
                                                      .tongsoLuongTungLoHang(
                                                          loHangModel: controller
                                                                  .filteredList[
                                                              index],
                                                          maCuaHang: cuaHangController
                                                                  .cuaHangModel
                                                                  .value
                                                                  .maCuaHang ??
                                                              'Tất cả')),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: ColorClass
                                                          .color_xanh_it_dam),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          controller.filteredList[index]
                                                      .hanSuDung !=
                                                  null
                                              ? Text(
                                                  'HSD ${FunctionHelper.formatDateString(controller.filteredList[index].hanSuDung.toString())}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                      ),
                    ],
                  ),
          ),
          Obx(() => controller.loading.value
              ? const LoadingCircularFullScreen()
              : const SizedBox())
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        titleSpacing: 3,
        title: const Text(
          'Lô hàng, Hạn sử dụng',
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Obx(
            () => TextField(
              controller: controller.searchController,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: ColorClass.color_thanh_ke, width: 1),
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
                hintText: 'Số lô, hạn sử dụng',
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
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
          padding: const EdgeInsets.all(0),
          child: Obx(
            () => DropdownButton<String>(
              value: controller.trangThai.value,
              items: [
                DropdownMenuItem(
                  value: 'Tất cả',
                  child:
                      Text('Tất cả', style: AppTheme.lightTextTheme.bodySmall),
                ),
                DropdownMenuItem(
                  value: 'Còn hàng',
                  child: Text('Còn hàng',
                      style: AppTheme.lightTextTheme.bodySmall),
                ),
                DropdownMenuItem(
                  value: 'Hết hàng',
                  child: Text('Hết hàng',
                      style: AppTheme.lightTextTheme.bodySmall),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  print('gọi');

                  controller.changeTrangThai(
                      value: newValue,
                      maCuaHang:
                          cuaHangController.cuaHangModel.value.maCuaHang ??
                              'Tất cả');
                }
              },
            ),
          ),
        ),
      ],
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
                      onTap: () {
                        Get.back();
                        cuaHangController.findByMaCuaHang((index == 0)
                            ? 'Tất cả'
                            : cuaHangController.listCuaHang[index - 1].maCuaHang
                                .toString());
                        controller.filterListLoHang(
                            maCuaHang: (index == 0)
                                ? 'Tất cả'
                                : cuaHangController
                                    .listCuaHang[index - 1].maCuaHang
                                    .toString());
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
