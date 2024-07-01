import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/nha_cung_cap/nha_cung_cap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/nha_cung_cap/them_nha_cung_cap_screen.dart';
import 'package:qlhanghoa/src/widget/nha_cung_cap/tim_kiem_ncc_screen.dart';
import 'package:qlhanghoa/src/widget/nha_cung_cap/xem_chi_tiet_ncc_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class NhaCungCapScreen extends StatelessWidget {
  NhaCungCapController nhaCungCapController = Get.find();
  NhaCungCapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nhaCungCapController.getListNhaCungCap();
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
            child: GetBuilder<NhaCungCapController>(
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
                                  // chuyển đến xem chi tiết nhà cung cấp
                                  await nhaCungCapController.getOneNCC(
                                      controller.filteredList[index]
                                              .maNhaCungCap ??
                                          '');
                                  Get.to(() => XemChiTietNhaCungCapScreen());
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
                                                    .tenNhaCungCap ??
                                                '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            FunctionHelper.formNum(controller
                                                    .tinhTongMuaTungNhaCungCap(
                                                        controller.filteredList[
                                                            index])
                                                    .toString())
                                                .toString(),
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
                                              Icons.phone,
                                              size: 14,
                                              color: ColorClass.color_cancel,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                                controller.filteredList[index]
                                                        .sdt ??
                                                    '',
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
        Obx(() => nhaCungCapController.loading.value == true
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
              'Nhà cung cấp',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    // mở trang tìm kiếm
                    nhaCungCapController.setOnSubmit(false);
                    Get.to(() => TimKiemNhaCungCapScreen());
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 28,
                  )),
              IconButton(
                  onPressed: () {
                    // chuyển đến trang thêm nhà cung cấp
                    nhaCungCapController.reSetDataThem();
                    Get.to(() => ThemNhaCungCapScreen(
                          edit: false,
                          themPhieuNhap: false,
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
                    GetBuilder<NhaCungCapController>(
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
                      'nhà cung cấp',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng mua: ',
                      style: TextStyle(fontSize: 14),
                    ),
                    GetBuilder<NhaCungCapController>(
                      builder: (controller) => Text(
                        FunctionHelper.formNum(controller
                            .tinhTongMua(controller.filteredList)
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

  /* PreferredSize _buildBottomSearch() {
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
          controller: nhaCungCapController.searchController,
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
            hintText: 'Tên loại hàng',
            hintStyle: const TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 170, 170, 170)),
            prefixIcon: const Icon(
              Icons.search,
              color: ColorClass.color_thanh_ke,
            ),
            suffixIcon: nhaCungCapController.iconClose.value
                ? IconButton(
                    onPressed: () {
                      // delete value
                      nhaCungCapController.searchController.text = '';
                    },
                    icon: const Icon(Icons.close),
                    color: ColorClass.color_thanh_ke,
                  )
                : null,
          ),
        ),
      ),
    );
  }*/
}
