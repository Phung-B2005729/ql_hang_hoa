// ignore_for_file: prefer_is_empty, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/loai_hang/loai_hang_controller.dart';
import 'package:qlhanghoa/src/controller/nha_cung_cap/nha_cung_cap_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/nhap_lo_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/them_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/edit_create_hang_hoa/chon_loai_hang_screen.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/edit_create_hang_hoa/them_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/edit_create_hang_hoa/thiet_lap_gia_ban.screen.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/tim_kiem_hang_hoa/tim_kiem_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/them_phieu_nhap/chon_nha_cung_cap_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/them_phieu_nhap/nhap_hang_tung_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/them_phieu_nhap/thanh_toan_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ThemPhieuNhapScreen extends GetView<ThemPhieuNhapController> {
  NhaCungCapController nhaCungCapController = Get.find();
  HangHoaController hangHoaController = Get.find();
  LoaiHangController loaiHangController = Get.find();
  ThemPhieuNhapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (loaiHangController.listLoaiHang.isEmpty) {
      loaiHangController.getListLoaiHang();
    }
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: GetBuilder<ThemPhieuNhapController>(
                builder: (controller) => controller.listChiTietPhieuNhap.isEmpty
                    ? _buildColumnChiTietEmpty()
                    : _buildColumnHangHoa(controller),
              )),
              Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 14, 102, 202),
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
                child: ListTile(
                  onTap: () {
                    // xác nhân nhập hàng
                    // đã chọn nhà cung cấp, tổng số lượng > 0 thì mới cho chuyển
                    if (controller.phieuNhap.value.maNhaCungCap != null &&
                        controller.phieuNhap.value.maCuaHang != '' &&
                        controller.tinhTongSoLuong() > 0) {
                      Get.to(() => ThanhToanScreen());
                    } else {
                      if (controller.phieuNhap.value.maNhaCungCap == null ||
                          controller.phieuNhap.value.maCuaHang == '') {
                        GetShowSnackBar.errorSnackBar(
                            'Vui lòng chọn nhà cung cấp');
                      } else {
                        GetShowSnackBar.errorSnackBar(
                            'Vui lòng kiểm tra lại số lượng đã nhập không được bằng 0');
                      }
                    }
                  },
                  minLeadingWidth: 0,
                  title: GetBuilder<ThemPhieuNhapController>(
                    builder: (controller) => Text(
                      controller.phieuNhap.value.tongTien != null
                          ? 'Tổng: ${FunctionHelper.formNum(controller.phieuNhap.value.tongTien.toString())}'
                          : 'Tổng: 0',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() => controller.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  Column _buildColumnHangHoa(ThemPhieuNhapController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: GetBuilder<ThemPhieuNhapController>(
            builder: (controller) => ListTile(
              onTap: () {
                // chọn nhà cung cấp
                Get.to(() => ChonNhaCungCapScreen());
              },
              leading: const Icon(
                Icons.people,
                color: ColorClass.color_cancel,
              ),
              minLeadingWidth: 15,
              title: controller.phieuNhap.value.maNhaCungCap != null
                  ? Text(
                      nhaCungCapController
                          .findNhaCungCap(
                              controller.phieuNhap.value.maNhaCungCap)
                          .tenNhaCungCap
                          .toString(),
                      style: const TextStyle(
                        color: ColorClass.color_cancel,
                      ),
                    )
                  : const Text(
                      'Chọn nhà cung cấp',
                      style: TextStyle(
                        color: ColorClass.color_cancel,
                      ),
                    ),
              trailing: const Icon(Icons.navigate_next,
                  color: ColorClass.color_cancel),
            ),
          ),
        ),
        _buildContanerListHangHoa(controller),
      ],
    );
  }

  SingleChildScrollView _buildColumnChiTietEmpty() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: GetBuilder<ThemPhieuNhapController>(
              builder: (controller) => ListTile(
                onTap: () {
                  // chọn nhà cung cấp
                  Get.to(() => ChonNhaCungCapScreen());
                },
                leading: const Icon(
                  Icons.people,
                  color: ColorClass.color_cancel,
                ),
                minLeadingWidth: 15,
                title: controller.phieuNhap.value.maNhaCungCap != null
                    ? Text(
                        nhaCungCapController
                            .findNhaCungCap(
                                controller.phieuNhap.value.maNhaCungCap)
                            .tenNhaCungCap
                            .toString(),
                        style: const TextStyle(
                          color: ColorClass.color_cancel,
                        ),
                      )
                    : const Text(
                        'Chọn nhà cung cấp',
                        style: TextStyle(
                          color: ColorClass.color_cancel,
                        ),
                      ),
                trailing: const Icon(Icons.navigate_next,
                    color: ColorClass.color_cancel),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                  height: 300,
                  width: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/empty.jpg'),
                    fit: BoxFit
                        .cover, // Tùy chọn: để hình ảnh vừa khít với container
                  ))),
              const SizedBox(
                height: 30,
              ),
              const Text('Chưa có hàng hoá trong phiếu nhập'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContanerListHangHoa(ThemPhieuNhapController controller) {
    return Expanded(
      child: Container(
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
        child: ListView.builder(
            itemCount: controller.listChiTietPhieuNhap.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                key: ValueKey(controller.listChiTietPhieuNhap[index].maHangHoa),
                startActionPane: ActionPane(
                  // action bắt đầu ở bên trái hoặc phía trên mục khi vuốt
                  extentRatio: 0.8,
                  motion:
                      const ScrollMotion(), // động tác điều khiển khi hành động mở ra

                  // cho phép pane bị loại bỏ khi người dùng vuột.
                  // dismissible: DismissiblePane(onDismissed: () {}),

                  // các hành động trong pane.
                  children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (_) {
                        controller.deleteHangHoa(
                            controller.listChiTietPhieuNhap[index].maHangHoa ??
                                '');
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Xoá',
                    ),
                    SlidableAction(
                      flex: 1,
                      onPressed: (_) {
                        // chuyển qua điều chỉnh giá bán
                        ThemHangHoaController themHangHoaController =
                            Get.find();
                        themHangHoaController.setUpDateData(
                            controller.listChiTietPhieuNhap[index].hangHoa!);
                        Get.to(() => const ThietLapGiaBanScreen(
                              themPhieuNhap: true,
                            ));
                        print('điều chỉnh giá bán');
                      },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.local_offer,
                      label: 'Giá bán',
                    ),
                    SlidableAction(
                      flex: 1,
                      onPressed: (_) async {
                        // chuyển qua thêm
                        print('thêm nhập hàng');
                        if (controller.listChiTietPhieuNhap[index].hangHoa!
                                .quanLyTheoLo ==
                            true) {
                          // chuyển đến giao diện thêm lô
                        } else {
                          NhapLoController nhapLoController = Get.find();

                          HangHoaController hangHoaController = Get.find();
                          if (hangHoaController.listHangHoa.isEmpty) {
                            await hangHoaController.getlistHangHoa();
                          }
                          nhapLoController.setUpData(
                              chiTiet: controller.listChiTietPhieuNhap[index],
                              hangHoa: hangHoaController.findMaHangHoa(
                                  controller
                                      .listChiTietPhieuNhap[index].maHangHoa!),
                              indext: index);
                          Get.to(() => const NhapHangTheoTungHangHoa());
                        }
                      },
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white, // màu lable và icon
                      icon: Icons.add,
                      label: 'Thêm',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  extentRatio: 0.8,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (_) async {
                        // chuyển qua thêm
                        print('thêm nhập hàng');
                        if (controller.listChiTietPhieuNhap[index].hangHoa!
                                .quanLyTheoLo ==
                            true) {
                          // chuyển đến giao diện thêm lô
                        } else {
                          NhapLoController nhapLoController = Get.find();

                          HangHoaController hangHoaController = Get.find();
                          if (hangHoaController.listHangHoa.isEmpty) {
                            await hangHoaController.getlistHangHoa();
                          }
                          nhapLoController.setUpData(
                              chiTiet: controller.listChiTietPhieuNhap[index],
                              hangHoa: hangHoaController.findMaHangHoa(
                                  controller
                                      .listChiTietPhieuNhap[index].maHangHoa!),
                              indext: index);
                          Get.to(() => const NhapHangTheoTungHangHoa());
                        }
                      },
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white, // màu lable và icon
                      icon: Icons.add,
                      label: 'Thêm',
                    ),
                    SlidableAction(
                      flex: 1,
                      onPressed: (_) {
                        ThemHangHoaController themHangHoaController =
                            Get.find();
                        themHangHoaController.setUpDateData(
                            controller.listChiTietPhieuNhap[index].hangHoa!);
                        Get.to(() => const ThietLapGiaBanScreen(
                              themPhieuNhap: true,
                            ));
                        print('điều chỉnh giá bán');
                      },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.local_offer,
                      label: 'Giá bán',
                    ),
                    SlidableAction(
                      flex: 1,
                      onPressed: (_) {
                        controller.deleteHangHoa(
                            controller.listChiTietPhieuNhap[index].maHangHoa ??
                                '');
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Xoá',
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                  child: GestureDetector(
                    onTap: () async {
                      // chuyển đến trang xem

                      NhapLoController nhapLoController = Get.find();

                      HangHoaController hangHoaController = Get.find();
                      if (hangHoaController.listHangHoa.isEmpty) {
                        await hangHoaController.getlistHangHoa();
                      }
                      nhapLoController.setUpData(
                          chiTiet: controller.listChiTietPhieuNhap[index],
                          hangHoa: hangHoaController.findMaHangHoa(controller
                              .listChiTietPhieuNhap[index].maHangHoa!),
                          indext: index);
                      Get.to(() => const NhapHangTheoTungHangHoa());
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${controller.listChiTietPhieuNhap[index].hangHoa!.tenHangHoa} (${controller.listChiTietPhieuNhap[index].hangHoa!.donViTinh.toString()})',
                                style: const TextStyle(
                                    fontSize: 16,
                                    //  fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Text(
                                  FunctionHelper.formNum(((controller
                                                  .listChiTietPhieuNhap[index]
                                                  .hangHoa!
                                                  .giaVon)! *
                                              (controller
                                                  .listChiTietPhieuNhap[index]
                                                  .soLuong!) -
                                          (controller
                                                  .listChiTietPhieuNhap[index]
                                                  .giaGiam ??
                                              0))
                                      .toString()),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      //  fontWeight: FontWeight.w600,
                                      color: Colors.black))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          GetBuilder<ThemPhieuNhapController>(
                            builder: (controller) => Text(
                              controller.listChiTietPhieuNhap[index].maHangHoa
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: ColorClass.color_cancel),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  FunctionHelper.formNum(controller
                                      .listChiTietPhieuNhap[index]
                                      .hangHoa!
                                      .giaVon
                                      .toString()),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black)),
                              Text(
                                  " x ${FunctionHelper.formNum(controller.listChiTietPhieuNhap[index].soLuong!.toString())}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: ColorClass.color_xanh_it_dam)),
                            ],
                          ),

                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Giá giảm: ',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                  controller.listChiTietPhieuNhap[index]
                                              .giaGiam !=
                                          null
                                      ? FunctionHelper.formNum(controller
                                          .listChiTietPhieuNhap[index].giaGiam!
                                          .toString())
                                      : '0',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // ignore: unused_local_variable
                          (controller.listChiTietPhieuNhap[index].loNhap !=
                                      null &&
                                  controller.listChiTietPhieuNhap[index].loNhap!
                                      .isNotEmpty)
                              ? Column(
                                  children: [
                                    for (var loHang in controller
                                        .listChiTietPhieuNhap[index].loNhap!)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, top: 5),
                                        child: Row(
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
                                            Text(loHang.soLo.toString(),
                                                style: const TextStyle(
                                                    fontSize: 13)),
                                            Text(
                                              " x ${FunctionHelper.formNum((loHang.soLuongNhap ?? 0).toString())}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: ColorClass
                                                      .color_xanh_it_dam),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            loHang.hanSuDung != null
                                                ? Text(
                                                    "HSD ${FunctionHelper.formatDateString(loHang.hanSuDung.toString())}",
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black))
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              : const SizedBox(),

                          const Divider(
                            color: ColorClass.color_thanh_ke,
                          ),
                        ]),
                  ),
                ),
              );
            }),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        titleSpacing: 3,
        title: const Text(
          'Nhập hàng',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              // sô modal thông tin các nhận xem là thoát luôn hay là lưu tạm
              print('gọi');
              if (controller.listChiTietPhieuNhap != null &&
                  controller.listChiTietPhieuNhap.length > 0) {
                Get.dialog(_buildDiaLogBack());
              } else {
                Get.back();
              }
            },
            icon: const Icon(
              Icons.close,
              color: ColorClass.color_outline_icon,
              size: 28,
            )),
        bottom: _buildBottomSearch());
  }

  AlertDialog _buildDiaLogBack() {
    return AlertDialog(
      title: const Text(
        'Bạn có muốn lưu vào phiếu tạm ?',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      actions: [
        TextButton(
          child: const Text(
            'Thoát',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          onPressed: () {
            Get.back();
            Get.back();
          },
        ),
        TextButton(
          child: const Text(
            'Lưu phiếu tạm',
            style: TextStyle(color: ColorClass.color_button_nhat, fontSize: 18),
          ),
          onPressed: () async {
            // lưu phiếu tạm và thoát
            Get.back();
          },
        ),
      ],
    );
  }

  PreferredSize _buildBottomSearch() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          padding: const EdgeInsets.only(left: 20),
          margin:
              const EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 225, 225, 225),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
              onTap: () async {
                hangHoaController.searchController.text = '';
                if (hangHoaController.listHangHoa.isEmpty) {
                  await hangHoaController.getlistHangHoa();
                }
                Get.to(() => TimKiemHangHoaScreen(
                      themPhieuNhap: true,
                    ));
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.search,
                    color: ColorClass.color_outline_icon,
                    size: 25,
                  ),
                  // ignore: unnecessary_const
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Chọn hàng nhập',
                    style:
                        TextStyle(color: ColorClass.color_cancel, fontSize: 18),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      // mở chọn loại hàng
                      LoaiHangController loaiHangController = Get.find();
                      loaiHangController.searchController.text = '';
                      // ignore: unused_local_variable
                      ThemHangHoaController themHangHoaController = Get.find();
                      themHangHoaController.reSetData();
                      Get.to(() => ChonLoaiHangScreen(
                            themPhieuNhap: true,
                          ));
                    },
                    icon: const Icon(
                      Icons.storage_outlined,
                      color: ColorClass.color_outline_icon,
                    )),
                IconButton(
                    onPressed: () {
                      // mở thêm hàng hoá
                      ThemHangHoaController controllerThemHangHoa = Get.find();
                      controllerThemHangHoa.reSetData();
                      Get.to(() => ThemHangHoaScreen(
                            themPhieuNhap: true,
                          ));
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 30,
                      color: ColorClass.color_outline_icon,
                    ))
              ],
            ),
          ]),
        ));
  }
}
