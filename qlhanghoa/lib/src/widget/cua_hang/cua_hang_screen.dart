import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/cua_hang/them_cua_hang_screen.dart';
import 'package:qlhanghoa/src/widget/cua_hang/tim_kiem_cua_hang_screen.dart';
import 'package:qlhanghoa/src/widget/cua_hang/xem_chi_tiet_cua_hang_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class CuaHangScreen extends StatelessWidget {
  CuaHangController cuaHangController = Get.find();
  CuaHangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cuaHangController.getlistCuaHang();
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
            child: GetBuilder<CuaHangController>(
              builder: (controller) => ListView.builder(
                  itemCount: controller.filteredList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 15, top: 10),
                      child: Column(
                        children: [
                          Obx(
                            () => GestureDetector(
                                onTap: () async {
                                  // chuyển đến xem chi tiết
                                  await cuaHangController.getOneCuaHang(
                                      controller
                                              .filteredList[index].maCuaHang ??
                                          '');
                                  Get.to(() => XemChiTietCuaHangScreen());
                                },
                                // ignore: avoid_unnecessary_containers
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.filteredList[index]
                                                    .tenCuaHang ??
                                                '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            '${FunctionHelper.formNum(controller.tongSanPhamTungCuaHang(controller.filteredList[index]).toString())} sp',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color:
                                                  ColorClass.color_xanh_it_dam,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.place,
                                              size: 14,
                                              color: ColorClass.color_cancel,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                                controller.filteredList[index]
                                                        .diaChi ??
                                                    '',
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      ColorClass.color_cancel,
                                                )),
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
                          // const Divider(
                          // color: ColorClass.color_thanh_ke,
                          //)
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
        Obx(() => cuaHangController.loading.value == true
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
          child: AppBar(
            //backgroundColor: Colors.white,
            titleSpacing: 3,
            title: const Text(
              'Chi nhánh cửa hàng',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    // mở trang tìm kiếm
                    cuaHangController.setOnSubmit(false);
                    Get.to(() => TimKiemCuaHangScreen());
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 28,
                  )),
              IconButton(
                  onPressed: () {
                    // chuyển đến trang thêm nhà cung cấp
                    cuaHangController.reSetDataThem();
                    Get.to(() => ThemCuaHangScreen(
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
                    GetBuilder<CuaHangController>(
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
                      'chi nhánh',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tồn kho: ',
                      style: TextStyle(fontSize: 14),
                    ),
                    GetBuilder<CuaHangController>(
                      builder: (controller) => Text(
                        FunctionHelper.formNum(controller
                            .tongSanPham(controller.filteredList)
                            .toString()),
                        style: const TextStyle(
                            fontSize: 14, color: ColorClass.color_xanh_it_dam),
                      ),
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
