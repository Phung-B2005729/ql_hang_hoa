import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qlhanghoa/src/controller/nha_cung_cap/nha_cung_cap_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/xem_chi_tiet/chi_tiet_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/nha_cung_cap/them_nha_cung_cap_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/chi_tiet_phieu_nhap_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class XemChiTietNhaCungCapScreen extends StatelessWidget {
  XemChiTietNhaCungCapScreen({super.key});

  final NhaCungCapController nhaCungCapController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Obx(
                () => Text(
                  nhaCungCapController.nhaCungCapModel.value.tenNhaCungCap ??
                      '',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  nhaCungCapController.indexTap.value = 0;
                  Get.back();
                },
                icon: const Icon(
                  Icons.navigate_before,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    // mở trang edit

                    nhaCungCapController.setUpDataEdit();
                    Get.to(() => ThemNhaCungCapScreen(
                          edit: true,
                          themPhieuNhap: false,
                        ));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    // xoá nhà ncc
                    Get.dialog(_buildXacNhanXoa(), barrierDismissible: false);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
              bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2,
                    color: ColorClass.fiveColor,
                  ),
                ),
                labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                labelColor: ColorClass.fiveColor,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: "Thông tin"),
                  Tab(text: "Lịch sử giao dịch"),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                _buildThongTinCaNhan(),
                _buildLichSuGiaoDich(),
              ],
            ),
          ),
          Obx(() => nhaCungCapController.loading.value == true
              ? const LoadingCircularFullScreen()
              : const SizedBox())
        ],
      ),
    );
  }

  AlertDialog _buildXacNhanXoa() {
    return AlertDialog(
      title: const Text(
        'Bạn có chắc chắn muốn thoát ?',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      content: const Text('Lưu ý:  dữ liệu sẽ không được lưu nếu thoát',
          style: TextStyle(color: Colors.black, fontSize: 16)),
      actions: [
        TextButton(
          child: const Text(
            'HUỶ',
            style: TextStyle(color: ColorClass.color_cancel, fontSize: 18),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: const Text(
            'XOÁ',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          onPressed: () async {
            Get.back();
            bool ktr = await nhaCungCapController
                .delete(nhaCungCapController.nhaCungCapModel.value);
            if (ktr == true) {
              GetShowSnackBar.successSnackBar(
                  '${nhaCungCapController.nhaCungCapModel.value.tenNhaCungCap} đã được xóa');
              Get.back();
            }
          },
        ),
      ],
    );
  }

  Widget _buildLichSuGiaoDich() {
    return Container(
        margin: const EdgeInsets.only(top: 15),
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
        child: GetBuilder<NhaCungCapController>(builder: (controller) {
          return (controller.nhaCungCapModel.value.listPhieuNhap == null ||
                  controller.nhaCungCapModel.value.listPhieuNhap!.isEmpty)
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Không có giao dịch theo yêu cầu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 121, 121, 121),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 30),
                  itemCount:
                      controller.nhaCungCapModel.value.listPhieuNhap!.length +
                          1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 5, right: 5),
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: ColorClass.color_thanh_ke)),
                      ),
                      height: null,
                      child: (index == 0)
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.nhaCungCapModel.value
                                            .listPhieuNhap!.length
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorClass.color_xanh_it_dam,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      const Text(
                                        'Giao dịch',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 121, 121, 121),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tổng mua',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 121, 121, 121),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        controller
                                            .tinhTongMuaTungNhaCungCap(
                                                controller
                                                    .nhaCungCapModel.value)
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorClass.color_xanh_it_dam,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                ChiTietPhieuNhapController
                                    chiTietPhieuNhapController = Get.find();
                                await chiTietPhieuNhapController
                                    .getOnePhieuNhap(controller
                                        .nhaCungCapModel
                                        .value
                                        .listPhieuNhap![index - 1]
                                        .maPhieuNhap
                                        .toString());
                                Get.to(() => const ChiTietPhieuNhapScreen());
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller
                                                .nhaCungCapModel
                                                .value
                                                .listPhieuNhap![index - 1]
                                                .maPhieuNhap ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        FunctionHelper.formNum(
                                          controller
                                              .nhaCungCapModel
                                              .value
                                              .listPhieuNhap![index - 1]
                                              .tongTien
                                              .toString(),
                                        ),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: (controller
                                                      .nhaCungCapModel
                                                      .value
                                                      .listPhieuNhap![index - 1]
                                                      .trangThai ==
                                                  'Đã nhập hàng')
                                              ? ColorClass.color_xanh_it_dam
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          (controller
                                                      .nhaCungCapModel
                                                      .value
                                                      .listPhieuNhap![index - 1]
                                                      .ngayLapPhieu !=
                                                  null)
                                              ? "Ngày ${FunctionHelper.formatDateTimeString(controller.nhaCungCapModel.value.listPhieuNhap![index - 1].ngayLapPhieu.toString())}"
                                              : '',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              //  fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 49, 49, 49))),
                                      Text(
                                        (controller
                                                        .nhaCungCapModel
                                                        .value
                                                        .listPhieuNhap![
                                                            index - 1]
                                                        .nhanVien !=
                                                    null &&
                                                controller
                                                        .nhaCungCapModel
                                                        .value
                                                        .listPhieuNhap![
                                                            index - 1]
                                                        .nhanVien!
                                                        .tenNhanVien !=
                                                    null)
                                            ? controller
                                                .nhaCungCapModel
                                                .value
                                                .listPhieuNhap![index - 1]
                                                .nhanVien!
                                                .tenNhanVien
                                                .toString()
                                            : '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 49, 49, 49),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        controller.nhaCungCapModel.value
                                            .listPhieuNhap![index - 1].trangThai
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: (controller
                                                        .nhaCungCapModel
                                                        .value
                                                        .listPhieuNhap![
                                                            index - 1]
                                                        .trangThai ==
                                                    'Đã nhập hàng')
                                                ? ColorClass.color_xanh_it_dam
                                                : Colors.red)),
                                  )
                                ],
                              ),
                            ),
                    );
                  });
        }));
  }

  SingleChildScrollView _buildThongTinCaNhan() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            //  margin: EdgeInsets.only(top: 10),
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
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
              //   crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRowMaNhaCungCap(),
                _buildRowTenNhaCungCap(),
                _buildRowSDTNhaCungCap(),
                _buildRowEmailNhaCungCap(),
                _buildRowDiaChiNhaCungCap(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Ghi chú',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 94, 94, 94)),
              ),
            ),
          ),
          _buildGhiChu(),
        ],
      ),
    );
  }

  Container _buildGhiChu() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 25,
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      height: 80,
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
      child: Obx(
        () => Text(
          nhaCungCapController.nhaCungCapModel.value.ghiChu ?? '',
          softWrap: true,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  // ignore: unused_element
  Row _buildRowMaNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Mã NCC',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhaCungCapController.nhaCungCapModel.value.maNhaCungCap ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowTenNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Tên NCC',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhaCungCapController.nhaCungCapModel.value.tenNhaCungCap ??
                      '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowSDTNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Số điện thoại',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhaCungCapController.nhaCungCapModel.value.sdt ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowEmailNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhaCungCapController.nhaCungCapModel.value.email ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }

  Row _buildRowDiaChiNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Địa chi',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Text(
                  nhaCungCapController.nhaCungCapModel.value.diaChi ?? '',
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        )
      ],
    );
  }
}
