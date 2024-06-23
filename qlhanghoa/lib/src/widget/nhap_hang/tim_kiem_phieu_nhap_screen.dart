import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';

import 'package:qlhanghoa/src/controller/nhap_hang/phieu_nhap_controller.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class TimKiemPhieuNhapScreen extends GetView<PhieuNhapController> {
  NhanVienController nhanVienController = Get.find();
  CuaHangController cuaHangController = Get.find();
  TimKiemPhieuNhapScreen({super.key});

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
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Theo',
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorClass.color_cancel,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                      _buildFieldMaPhieuNhap(),
                      _buildFieldHangHoa(),
                      _buildFieldNhaCungCap(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Nhân viên lập phiếu',
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorClass.color_cancel,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // chọn nhân viên và cửa hàng
                Container(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          // mở select nhân viên
                          (nhanVienController.listNhanVien.isNotEmpty)
                              ? _buildChooseNhanVien(context)
                              : GetShowSnackBar.warningSnackBar(
                                  'Chưa có danh sách nhân viên');
                        },
                        title: Obx(
                          () => Text(
                            nhanVienController
                                        .findNhanVien(
                                            controller.maNhanVien.value)
                                        .tenNhanVien !=
                                    null
                                ? nhanVienController
                                    .findNhanVien(controller.maNhanVien.value)
                                    .tenNhanVien
                                    .toString()
                                : controller.maNhanVien.value,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Cửa hàng',
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorClass.color_cancel,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
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
                      ListTile(
                        onTap: () {
                          // mở select cửa hàng
                          (cuaHangController.listCuaHang.isNotEmpty)
                              ? _buildChooseCuaHang(context)
                              : GetShowSnackBar.warningSnackBar(
                                  'Chưa có danh sách cửa hàng');
                          ;
                        },
                        title: Obx(
                          () => Text(
                            cuaHangController
                                        .findCuaHang(controller.maCuaHang.value)
                                        .tenCuaHang !=
                                    null
                                ? cuaHangController
                                    .findCuaHang(controller.maCuaHang.value)
                                    .tenCuaHang
                                    .toString()
                                : controller.maCuaHang.value,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // chọn trạng thái
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Trạng thái',
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorClass.color_cancel,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
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
                      ListTile(
                        onTap: () {
                          // mở select chọn trạng thái
                          _buildChooseTrangThai(context);
                        },
                        title: Obx(
                          () => Text(
                            controller.trangThai.value != '' &&
                                    // ignore: unnecessary_null_comparison
                                    controller.trangThai.value != null
                                ? controller.trangThai.value
                                : 'Trạng thái',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
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
      title: const Text(
        'Tìm kiếm phiếu nhập',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
          onPressed: () async {
            // reset các giá trị tìm kiếm
            controller.reSetTimKiem();
            // tìm kếm lại
            await controller.getlistPhieuNhap(
                ngayBatDau: controller.ngayBatDau.value,
                ngayKetThuc: controller.ngayKetThuc.value,
                trangThai: controller.trangThai.value,
                maCuaHang: controller.maCuaHang.value,
                maNhanVien: controller.maNhanVien.value,
                thongTinHangHoa: controller.thongTinHangHoa.text,
                thongTinLoHang: controller.thongTinLoHang.text,
                thongTinPhieuNhap: controller.thongTinPhieuNhap.text,
                thongTinNhaCungCap: controller.thongTinNhaCungCap.text);
            Get.back();
          },
          icon: const Icon(
            Icons.navigate_before,
            color: ColorClass.color_outline_icon,
            size: 28,
          )),
      actions: [
        TextButton(
            onPressed: () async {
              // gọi get list phiếu nhập
              controller.onSubmit.value = true;
              await controller.getlistPhieuNhap(
                  ngayBatDau: controller.ngayBatDau.value,
                  ngayKetThuc: controller.ngayKetThuc.value,
                  trangThai: controller.trangThai.value,
                  maCuaHang: controller.maCuaHang.value,
                  maNhanVien: controller.maNhanVien.value,
                  thongTinHangHoa: controller.thongTinHangHoa.text,
                  thongTinLoHang: controller.thongTinLoHang.text,
                  thongTinPhieuNhap: controller.thongTinPhieuNhap.text,
                  thongTinNhaCungCap: controller.thongTinNhaCungCap.text);
              Get.back();
            },
            child: const Text(
              'Áp dụng',
              style: TextStyle(
                fontSize: 18,
                color: ColorClass.color_xanh_it_dam,
              ),
            )),
      ],
    );
  }

  // ignore: unused_element

  Widget _buildFieldMaPhieuNhap() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: controller.thongTinPhieuNhap,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Mã phiếu nhập',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 16),
      ),
    );
  }

  Widget _buildFieldHangHoa() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: controller.thongTinHangHoa,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Tên hoặc hàng hoá, số lô ...',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 16),
      ),
    );
  }

  Widget _buildFieldNhaCungCap() {
    return TextField(
      controller: controller.thongTinNhaCungCap,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: 'Tên hoặc mã NCC',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 16),
      ),
    );
  }

  _buildChooseCuaHang(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // ignore: sized_box_for_whitespace
          return Container(
            height: MediaQuery.of(context).size.height *
                (((cuaHangController.listCuaHang.length) / 10 + 0.05) < 0.5
                    ? ((cuaHangController.listCuaHang.length) / 10 + 0.05)
                    : 0.5),
            child: cuaHangController.listCuaHang.length > 1
                ? GetBuilder<CuaHangController>(builder: (cuaHangController) {
                    return ListView.builder(
                        itemCount: cuaHangController.listCuaHang.length + 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Get.back();
                              // set chọn
                              controller.maCuaHang.value = (index == 0)
                                  ? 'Tất cả'
                                  : cuaHangController
                                      .listCuaHang[index - 1].maCuaHang
                                      .toString();
                            },
                            trailing: ((index != 0 &&
                                        cuaHangController.listCuaHang[index - 1]
                                                .maCuaHang
                                                .toString() ==
                                            controller.maCuaHang.value) ||
                                    (index == 0 &&
                                        (controller.maCuaHang.value == '' ||
                                            controller.maCuaHang.value ==
                                                'Tất cả')))
                                ? const Icon(
                                    Icons.check,
                                    color: ColorClass.color_xanh_it_dam,
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
                                    style:
                                        const TextStyle(color: Colors.black)),
                          );
                        });
                  })
                : ListTile(
                    onTap: () {
                      Get.back();
                      // set chọn
                      controller.maCuaHang.value =
                          cuaHangController.listCuaHang[0].maCuaHang.toString();
                    },
                    trailing: (cuaHangController.listCuaHang[0].maCuaHang
                                .toString() ==
                            controller.maCuaHang.value)
                        ? const Icon(
                            Icons.check,
                            color: ColorClass.color_xanh_it_dam,
                          )
                        : null,
                    title: Text(
                        cuaHangController.listCuaHang[0].tenCuaHang.toString(),
                        style: const TextStyle(color: Colors.black)),
                  ),
          );
        });
  }

  _buildChooseNhanVien(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height *
                (((nhanVienController.listNhanVien.length) / 10 + 0.05) < 0.5
                    ? ((nhanVienController.listNhanVien.length) / 10 + 0.05)
                    : 0.5),
            child: nhanVienController.listNhanVien.length > 1
                ? GetBuilder<NhanVienController>(builder: (nhanVienController) {
                    return ListView.builder(
                        itemCount: nhanVienController.listNhanVien.length + 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Get.back();
                              // set chọn
                              controller.maNhanVien.value = (index == 0)
                                  ? 'Tất cả'
                                  : nhanVienController
                                      .listNhanVien[index - 1].maNhanVien
                                      .toString();
                            },
                            trailing: ((index != 0 &&
                                        nhanVienController
                                                .listNhanVien[index - 1]
                                                .maNhanVien
                                                .toString() ==
                                            controller.maNhanVien.value) ||
                                    (index == 0 &&
                                        (controller.maNhanVien.value == '' ||
                                            controller.maNhanVien.value ==
                                                'Tất cả')))
                                ? const Icon(
                                    Icons.check,
                                    color: ColorClass.color_xanh_it_dam,
                                  )
                                : null,
                            title: (index == 0)
                                ? const Text(
                                    'Tất cả',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    nhanVienController
                                        .listNhanVien[index - 1].tenNhanVien
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.black)),
                          );
                        });
                  })
                : ListTile(
                    onTap: () {
                      Get.back();
                      // set chọn
                      controller.maNhanVien.value = nhanVienController
                          .listNhanVien[0].maNhanVien
                          .toString();
                    },
                    trailing: (nhanVienController.listNhanVien[0].maNhanVien
                                .toString() ==
                            controller.maNhanVien.value)
                        ? const Icon(
                            Icons.check,
                            color: ColorClass.color_xanh_it_dam,
                          )
                        : null,
                    title: Text(
                        nhanVienController.listNhanVien[0].tenNhanVien
                            .toString(),
                        style: const TextStyle(color: Colors.black)),
                  ),
          );
        });
  }

  // ignore: unused_element
  _buildChooseTrangThai(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // ignore: unused_local_variable

          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                  itemCount: controller.listTrangThai.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Get.back();
                        // set chọn
                        controller.trangThai.value =
                            controller.listTrangThai[index];
                      },
                      trailing: controller.listTrangThai[index] ==
                              controller.trangThai.value
                          ? const Icon(
                              Icons.check,
                              color: ColorClass.color_xanh_it_dam,
                            )
                          : null,
                      title: Text(controller.listTrangThai[index],
                          style: const TextStyle(color: Colors.black)),
                    );
                  }));
        });
  }
}
