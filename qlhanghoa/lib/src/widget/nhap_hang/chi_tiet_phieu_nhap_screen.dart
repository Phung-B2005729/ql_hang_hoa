import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';

import 'package:qlhanghoa/src/controller/nhap_hang/chi_tiet_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/xem_chi_tiet/chi_tiet_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

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
                      Obx(
                        () => Row(
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
                                controller
                                    .phieuNhap.value.nhaCungCap!.tenNhaCungCap
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ]),
                            Text(
                                controller.phieuNhap.value.nhanVien!.tenNhanVien
                                    .toString(),
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
                        child: Obx(
                          () => Text(
                              FunctionHelper.formatDateTimeString(controller
                                      .phieuNhap.value.ngayLapPhieu
                                      .toString())
                                  .toString(),
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
                  child: Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var chitiet in controller.listChiTietPhieuNhap!)
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
                                          '${chitiet.hangHoa!.tenHangHoa} (${chitiet.hangHoa!.donViTinh.toString()})',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        Text(
                                            FunctionHelper.formNum(
                                                ((chitiet.donGiaNhap!) *
                                                        (chitiet.soLuong!))
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
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                              color:
                                                  ColorClass.color_button_nhat,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: const Center(
                                            child: Text(
                                              'Lô',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(chitiet.soLo.toString(),
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        chitiet.hanSuDung != null
                                            ? Text(
                                                "HSD ${FunctionHelper.formatDateString(chitiet.hanSuDung.toString())}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black))
                                            : const SizedBox(),
                                      ],
                                    ),
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
                          Obx(
                            () => Text(
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
                          Obx(
                            () => Text(
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
                          Obx(
                            () => Text(
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
                          Obx(
                            () => Text(
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
                      Obx(
                        () => Text(
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
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Obx(
                            () => Text(
                              controller.phieuNhap.value.nhanVien!.tenNhanVien
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => Text(
                          controller.phieuNhap.value.cuaHang!.tenCuaHang
                              .toString(),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
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
      title: Obx(
        () => Column(
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
        PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    child: ListTile(
                      title: Text(
                        'Huỷ phiếu',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                ])
      ],
    );
  }
}
