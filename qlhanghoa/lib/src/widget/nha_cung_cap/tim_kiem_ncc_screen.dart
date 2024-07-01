import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/controller/nha_cung_cap/nha_cung_cap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/nha_cung_cap/xem_chi_tiet_ncc_screen.dart';

class TimKiemNhaCungCapScreen extends GetView<NhaCungCapController> {
  TimKiemNhaCungCapScreen({super.key, this.themPhieuNhap});
  final bool? themPhieuNhap;
  final BottomNavigationController bottomController = Get.find();

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: _builAppBar(),
      body: Container(
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
              builder: (controller) => (controller
                      .searchController.text.isNotEmpty)
                  ? (controller.filteredList.isEmpty)
                      ? const Center(
                          child: Text('Không tìm thấy kết quả phù hợp'))
                      : ListView.builder(
                          itemCount: controller.filteredList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 15, top: 10),
                              child: Column(
                                children: [
                                  Obx(
                                    () => GestureDetector(
                                        onTap: () async {
                                          // chuyển đến xem chi tiết nhà cung cấp
                                          await controller.getOneNCC(controller
                                                  .filteredList[index]
                                                  .maNhaCungCap ??
                                              '');
                                          Get.to(() =>
                                              XemChiTietNhaCungCapScreen());
                                        },
                                        // ignore: avoid_unnecessary_containers
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    controller
                                                            .filteredList[index]
                                                            .tenNhaCungCap ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    FunctionHelper.formNum(controller
                                                            .tinhTongMuaTungNhaCungCap(
                                                                controller
                                                                        .filteredList[
                                                                    index])
                                                            .toString())
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: ColorClass
                                                          .color_xanh_it_dam,
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
                                              ),
                                              const Divider(
                                                color:
                                                    ColorClass.color_thanh_ke,
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
                          })
                  : const SizedBox())),
    );
  }

  AppBar _builAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            // back và reset lại tìm kiếm và onsubmit
            controller.searchController.text = '';
            controller.setOnSubmit(false);
            Get.back();
          },
          icon: const Icon(
            Icons.navigate_before,
            size: 45,
            color: Color.fromARGB(193, 17, 17, 17),
          )),
      titleSpacing: 0,
      toolbarHeight: 100,
      //    expandedHeight: 350.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
              10), // Điều này sẽ bo tròn góc dưới của SliverAppBar
        ),
      ),
      actions: [
        Obx(
          () => controller.onsubmit.value == true
              ? Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: IconButton(
                      onPressed: () {
                        // chuyển trang nhập tìm kiếm
                        controller.searchController.text = '';
                        controller.setOnSubmit(false);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 57, 57, 57),
                        size: 27,
                      )),
                )
              : const SizedBox(),
        ),
      ],
      title: _buildTextSearch(),
      bottom: _buildBottomAppBar(),
    );
  }

  Obx _buildTextSearch() {
    return Obx(
      () => (controller.onsubmit.value == true)
          ? Text(
              controller.searchController.text,
              style: const TextStyle(fontSize: 17),
            )
          : Container(
              margin: const EdgeInsets.only(right: 20),
              color: Colors.white,
              height: 50,
              child: Obx(() => TextField(
                    onSubmitted: (value) {
                      controller.setOnSubmit(true);
                      print('gọi submit');
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.iconClose.value = true;
                      } else {
                        controller.iconClose.value = false;
                      }
                    },
                    controller: controller.searchController,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: ColorClass.color_xanh_it_dam, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 64, 64, 64), width: 1),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      fillColor: const Color.fromARGB(255, 246, 246, 246),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 64, 64, 64), width: 1),
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'Mã, tên, sdt, địa chỉ ncc',
                      hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 170, 170, 170)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: ColorClass.color_thanh_ke,
                      ),
                      suffixIcon: controller.iconClose.value == true
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
                  ))),
    );
  }

  PreferredSize _buildBottomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(10),
      child: Obx(
        () => controller.onsubmit != true
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                    bottom: 15, left: 20, right: 10, top: 0),
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
                                    fontSize: 14,
                                    color: ColorClass.color_xanh_it_dam),
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
                                    fontSize: 14,
                                    color: ColorClass.color_xanh_it_dam),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
