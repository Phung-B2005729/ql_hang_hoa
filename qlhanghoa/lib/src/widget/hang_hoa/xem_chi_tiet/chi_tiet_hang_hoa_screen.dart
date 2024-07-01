import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/giao_dich/giao_dich_controller.dart';
import 'package:qlhanghoa/src/controller/lo_hang/lo_hang_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/edit_create_hang_hoa/them_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/xem_chi_tiet/xem_chi_tiet_ton_kho.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/xem_chi_tiet/xem_giao_dich_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/xem_chi_tiet/xem_lo_hang_hsd_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class ChiTietHangHoaScreen extends StatelessWidget {
  ThemHangHoaController controller = Get.find();
  HangHoaController hangHoaController = Get.find();
  ChiTietHangHoaScreen({super.key});

  @override
  Widget build(Object context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.listImage.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildImage(index);
                        }),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                      _buildRowMaHang(),
                      _buildRowTenHang(),
                      _builRowLoaiHang(),
                      _buildRowThuongHieu(),
                      _buildRowGiaBan(),
                      _buildRowGiaVon(),
                      _buildRowTonKho(),
                      _buildRowDonViTinh(),
                      _buildRowTheKho(),
                      // ignore: prefer_const_constructors
                      controller.hangHoaModel.value.quanLyTheoLo == true
                          ? _buildRowLoHSD()
                          : SizedBox(),
                      _buildRowQuanLyTonKho()
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 25,
                  ),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 20),
                  height: 200,
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
                      controller.hangHoaModel.value.moTa != null
                          ? controller.hangHoaModel.value.moTa!
                          : '',
                      softWrap: true,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() => hangHoaController.loading.value
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 3,
      title: Obx(
        () => Text(
          controller.hangHoaModel.value.maHangHoa.toString(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () async {
              print('gọi edit');
              controller.changEdit(true);
              controller.setUpTam();
              Get.to(() => ThemHangHoaScreen());

              // xử lý thêm  hàng hoá
            },
            icon: const Icon(
              Icons.edit,
              size: 28,
            )),
      ],
    );
  }

  Row _buildRowQuanLyTonKho() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Quản lý tồn kho',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        _buildWidgetChangeQuanLyTonKho(),
      ],
    );
  }

  Expanded _buildWidgetChangeQuanLyTonKho() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 16,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: controller.quanLyTheoLo.value != true
                          ? const Color(0xFFCCCCCC)
                          : const Color(0xFF9AC1EF),
                      border: Border.all(
                          color: controller.quanLyTheoLo.value != true
                              ? const Color(0xFF888888)
                              : const Color(0xFF448DE4)),
                      borderRadius: BorderRadius.circular(13)),
                  height: 16,
                  width: 45,
                ),
              ),
              Obx(
                () => (controller.quanLyTheoLo.value != true)
                    ? const Positioned(
                        top: -3,
                        left: -5,
                        child: SizedBox(
                          width: 23,
                          height: 23,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF888888),
                          ),
                        ),
                      )
                    : const Positioned(
                        top: -3,
                        right: -5,
                        child: SizedBox(
                          width: 23,
                          height: 23,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF1D67BF),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _buildRowThuongHieu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Thương hiệu',
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
                  (controller.hangHoaModel.value.thuongHieu != null &&
                          controller.hangHoaModel.value.thuongHieu!
                                  .tenThuongHieu !=
                              null)
                      ? controller.hangHoaModel.value.thuongHieu!.tenThuongHieu!
                      : '',
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
        ),
      ],
    );
  }

  Row _builRowLoaiHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Loại hàng',
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
                  (controller.hangHoaModel.value.loaiHang != null &&
                          controller.hangHoaModel.value.loaiHang!.tenLoai !=
                              null)
                      ? controller.hangHoaModel.value.loaiHang!.tenLoai!
                      : '',
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
        ),
      ],
    );
  }

  // ignore: unused_element
  Row _buildRowMaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mã hàng hoá',
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
                  controller.hangHoaModel.value.maHangHoa != null
                      ? controller.hangHoaModel.value.maHangHoa!
                      : '',
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

  // ignore: unused_element
  Row _buildRowTenHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tên hàng hoá',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Text(
                  controller.hangHoaModel.value.tenHangHoa != null
                      ? controller.hangHoaModel.value.tenHangHoa!
                      : '',
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

  Row _buildRowGiaBan() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Giá bán',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Text(
                  FunctionHelper.formNum(
                          controller.hangHoaModel.value.donGiaBan)
                      .toString(),
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

  Row _buildRowGiaVon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Giá vốn',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Text(
                  FunctionHelper.formNum(controller.hangHoaModel.value.giaVon),
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

  Widget _buildRowTonKho() {
    return GestureDetector(
      onTap: () {
        Get.to(() => XemTonKho());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tồn kho',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    FunctionHelper.formNum(hangHoaController
                            .tongsoLuongTonKhoTrongListLoHang(
                                hangHoa: controller.hangHoaModel.value)
                            .toString()) +
                        " < " +
                        FunctionHelper.formNum(controller
                            .hangHoaModel.value.tonNhieuNhat
                            .toString()),
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
          ),
          IconButton(
              onPressed: () {
                // chuyển đến xem chi tiết tồn kho
                Get.to(() => XemTonKho());
              },
              icon: const Icon(
                Icons.navigate_next,
                color: ColorClass.color_cancel,
                size: 30,
              ))
        ],
      ),
    );
  }

  // ignore: unused_element
  Row _buildRowDonViTinh() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Đơn vị tính',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Text(
                  controller.hangHoaModel.value.donViTinh.toString(),
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

  Row _buildRowTheKho() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Thẻ kho',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () async {
                  GiaoDichController giaoDichController = Get.find();
                  CuaHangController cuaHangController = Get.find();
                  cuaHangController
                      .findByMaCuaHang(hangHoaController.maCuaHang.toString());
                  await giaoDichController.getListGiaoDich(
                      maHangHoa: controller.hangHoaModel.value.maHangHoa,
                      maCuaHangLoc: hangHoaController.maCuaHang.toString());
                  Get.to(() => XemGiaoDichScreen());
                },
                child: const Text('Xem thêm',
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorClass.color_button_nhat,
                        fontWeight: FontWeight.w600)),
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

// ignore: unused_element
  Row _buildRowLoHSD() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Lô,HSD',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // chuyển đến xem các lô hàng, cho tìm kiếm hạn sử dụng
                  LoHangController controllerLoHang = Get.find();
                  controllerLoHang
                      .setListLoHang(controller.hangHoaModel.value.loHang!);
                  // gọi setLoHag
                  // sau đó chuyền đến trang
                  CuaHangController cuaHangController = Get.find();
                  cuaHangController
                      .findByMaCuaHang(hangHoaController.maCuaHang.toString());
                  Get.to(() => XemLoHangHSD());
                },
                child: const Text('Xem thêm',
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorClass.color_button_nhat,
                        fontWeight: FontWeight.w600)),
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

  Container _buildImage(int index) {
    return Container(
      height: 120,
      width: 110,
      child: Card(
        color: const Color.fromRGBO(207, 207, 207, 1),
        child: ((controller.listImage[index] is XFile) == true)
            ? Image.file(
                File(controller.listImage[index].path),
                fit: BoxFit.cover,
              )
            : Image.network(
                controller.listImage[index].linkAnh,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
