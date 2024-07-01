import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';

import 'package:qlhanghoa/src/controller/nhap_hang/xem_chi_tiet/chi_tiet_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/xem_chi_tiet/chi_tiet_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ChiTietPhieuNhapScreen extends GetView<ChiTietPhieuNhapController> {
  const ChiTietPhieuNhapScreen({super.key});

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
                Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 10),
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
                      GetBuilder<ChiTietPhieuNhapController>(
                        builder: (controller) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              const Icon(
                                Icons.person,
                                color: ColorClass.color_outline_icon,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                controller.phieuNhap.value.nhaCungCap != null
                                    ? controller.phieuNhap.value.nhaCungCap!
                                        .tenNhaCungCap
                                        .toString()
                                    : '',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ]),
                            Text(
                                controller.phieuNhap.value.nhanVien != null
                                    ? controller
                                        .phieuNhap.value.nhanVien!.tenNhanVien
                                        .toString()
                                    : '',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black))
                          ],
                        ),
                      ),
                      const Divider(
                        color: ColorClass.color_thanh_ke,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GetBuilder<ChiTietPhieuNhapController>(
                          builder: (controller) => Text(
                              controller.phieuNhap.value.ngayLapPhieu != null
                                  ? FunctionHelper.formatDateTimeString(
                                          controller
                                              .phieuNhap.value.ngayLapPhieu
                                              .toString())
                                      .toString()
                                  : '',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                // chi tiết
                Container(
                  padding: const EdgeInsets.only(top: 10),
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
                  child: GetBuilder<ChiTietPhieuNhapController>(
                    builder: (controller) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var chitiet in controller.listChiTietPhieuNhap)
                          GestureDetector(
                            onTap: () async {
                              // chuyển đến trang thêm + edit
                              HangHoaController hangHoaController = Get.find();
                              // gọi findOne data
                              await hangHoaController
                                  .getFindOne(chitiet.maHangHoa.toString());
                              Get.to(() => ChiTietHangHoaScreen());
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          chitiet.hangHoa != null
                                              ? '${chitiet.hangHoa!.tenHangHoa} (${chitiet.hangHoa!.donViTinh.toString()})'
                                              : '',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        Text(
                                            FunctionHelper.formNum(
                                                ((chitiet.donGiaNhap!) *
                                                            (chitiet.soLuong!) -
                                                        (chitiet.giaGiam ?? 0))
                                                    .toString()),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))
                                      ],
                                    ),
                                    Text(
                                      chitiet.maHangHoa.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: ColorClass.color_cancel),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            FunctionHelper.formNum(
                                                chitiet.donGiaNhap.toString()),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black)),
                                        Text(
                                            " x ${FunctionHelper.formNum(chitiet.soLuong.toString())}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: ColorClass
                                                    .color_xanh_it_dam)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text('Giá giảm: ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            chitiet.giaGiam != null
                                                ? FunctionHelper.formNum(
                                                    chitiet.giaGiam!.toString())
                                                : '0',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // ignore: unused_local_variable
                                    GetBuilder<ChiTietPhieuNhapController>(
                                        builder:
                                            (controller) =>
                                                (chitiet.loNhap != null &&
                                                        chitiet
                                                            .loNhap!.isNotEmpty)
                                                    ? Column(
                                                        children: [
                                                          for (var loHang
                                                              in chitiet
                                                                  .loNhap!)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5,
                                                                      top: 5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    height: 20,
                                                                    width: 20,
                                                                    decoration: const BoxDecoration(
                                                                        color: ColorClass
                                                                            .color_button_nhat,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5))),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        'Lô',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 13),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                      loHang
                                                                          .soLo
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              13)),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  loHang.hanSuDung !=
                                                                          null
                                                                      ? Text(
                                                                          "HSD ${FunctionHelper.formatDateString(loHang.hanSuDung.toString())}",
                                                                          style: const TextStyle(
                                                                              fontSize: 13,
                                                                              color: Colors.black))
                                                                      : const SizedBox(),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                      "x ${FunctionHelper.formNum(loHang.soLuongNhap.toString())}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: ColorClass
                                                                            .color_button_nhat,
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                        ],
                                                      )
                                                    : const SizedBox(
                                                        child: Text('lô rỗng'),
                                                      )),

                                    const Divider(
                                      color: ColorClass.color_thanh_ke,
                                    ),
                                  ]),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng tiền hàng',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          GetBuilder<ChiTietPhieuNhapController>(
                            builder: (controller) => Text(
                                FunctionHelper.formNum(controller
                                    .phieuNhap.value.tongTien
                                    .toString()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black)),
                          )
                        ],
                      ),
                      const Divider(
                        color: ColorClass.color_thanh_ke,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Giảm giá phiếu nhập',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          GetBuilder<ChiTietPhieuNhapController>(
                            builder: (controller) => Text(
                                FunctionHelper.formNum(controller
                                    .phieuNhap.value.giaGiam
                                    .toString()),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          )
                        ],
                      ),
                      const Divider(
                        color: ColorClass.color_thanh_ke,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Đã trả NCC',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          GetBuilder<ChiTietPhieuNhapController>(
                            builder: (controller) => Text(
                                FunctionHelper.formNum(controller
                                    .phieuNhap.value.tongTien
                                    .toString()),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          )
                        ],
                      ),
                      const Divider(
                        color: ColorClass.color_thanh_ke,
                      )
                    ],
                  ),
                ),

                // chọn trạng thái
                const SizedBox(
                  height: 15,
                ),

                Container(
                  padding: const EdgeInsets.only(
                      right: 15, left: 15, top: 15, bottom: 15),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GetBuilder<ChiTietPhieuNhapController>(
                            builder: (controller) => Text(
                              controller.listChiTietPhieuNhap.length.toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: ColorClass.color_xanh_it_dam),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Mặt hàng',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      GetBuilder<ChiTietPhieuNhapController>(
                        builder: (controller) => Text(
                          FunctionHelper.formNum(
                              controller.phieuNhap.value.tongTien.toString()),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ColorClass.color_xanh_it_dam),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Container(
                  padding: const EdgeInsets.only(
                      right: 15, left: 15, top: 15, bottom: 15),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Người tạo:',
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          GetBuilder<ChiTietPhieuNhapController>(
                            builder: (controller) => Text(
                              controller.phieuNhap.value.nhanVien != null
                                  ? controller
                                      .phieuNhap.value.nhanVien!.tenNhanVien
                                      .toString()
                                  : '',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<ChiTietPhieuNhapController>(
                        builder: (controller) => Text(
                          controller.phieuNhap.value.cuaHang != null
                              ? controller.phieuNhap.value.cuaHang!.tenCuaHang
                                  .toString()
                              : '',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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

  AppBar _builddAppBar() {
    return AppBar(
      titleSpacing: 3,
      title: GetBuilder<ChiTietPhieuNhapController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.phieuNhap.value.maPhieuNhap.toString(),
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              controller.phieuNhap.value.trangThai.toString(),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.navigate_before,
            color: ColorClass.color_outline_icon,
            size: 28,
          )),
      actions: [
        if (controller.phieuNhap.value.trangThai != 'Đã huỷ')
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    if (controller.phieuNhap.value.trangThai == 'Đã nhập hàng')
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () async {
                            bool ktr = await controller.huyPhieuNhap();
                            if (ktr == true) {
                              Get.back();
                              //Get.back();
                              GetShowSnackBar.successSnackBar('Đã huỷ');
                            }
                          },
                          title: const Text(
                            'Huỷ phiếu',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    if (controller.phieuNhap.value.trangThai == 'Phiếu tạm')
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () async {
                            bool ktr = await controller.deletePhieuNhap();
                            if (ktr == true) {
                              print('xoá phiếu thành công ' + ktr.toString());
                              Get.back();
                              Get.back();
                              GetShowSnackBar.successSnackBar('Đẫ xoá');
                            }
                          },
                          title: const Text(
                            'Xoá phiếu',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                  ])
      ],
    );
  }
}
