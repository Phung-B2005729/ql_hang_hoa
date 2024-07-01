import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/cua_hang/them_cua_hang_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

class XemChiTietCuaHangScreen extends StatelessWidget {
  XemChiTietCuaHangScreen({super.key});

  final CuaHangController cuaHangController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Obx(
              () => Text(
                cuaHangController.cuaHangModel.value.tenCuaHang ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () {
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

                  cuaHangController.setUpDataEdit();
                  Get.to(() => ThemCuaHangScreen(
                        edit: true,
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
                  // xoá nhà CN
                  Get.dialog(_buildXacNhanXoa(), barrierDismissible: false);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
          body: _buildThongTin(),
        ),
        Obx(() => cuaHangController.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
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
            bool ktr = await cuaHangController
                .delete(cuaHangController.cuaHangModel.value);
            if (ktr == true) {
              GetShowSnackBar.successSnackBar(
                  '${cuaHangController.cuaHangModel.value.tenCuaHang} đã được xóa');
              Get.back();
            }
          },
        ),
      ],
    );
  }

  SingleChildScrollView _buildThongTin() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
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
                _buildRowMaCuaHang(),
                _buildRowtenCuaHang(),
                _buildRowSDTCuaHang(),
                _buildRowDiaChiCuaHang(),
                _buildRowLoaiCuaHang(),
                _buildRowGhiChuCuaHang(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildTonKho(),
          const SizedBox(
            height: 10,
          ),
          _buildNhanVien(),
        ],
      ),
    );
  }

  Widget _buildTonKho() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      // height: 80,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tồn kho',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            FunctionHelper.formNum(cuaHangController
                .tongSanPhamTungCuaHang(cuaHangController.cuaHangModel.value)
                .toString()),
            style: const TextStyle(
                fontSize: 16,
                color: ColorClass.color_xanh_it_dam,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Container _buildNhanVien() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      // height: 80,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Nhân viên',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            (cuaHangController.cuaHangModel.value.listNhanVien != null)
                ? cuaHangController.cuaHangModel.value.listNhanVien!.length
                    .toString()
                : '0',
            style: const TextStyle(
                fontSize: 16,
                color: ColorClass.color_xanh_it_dam,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  // ignore: unused_element
  Row _buildRowMaCuaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Mã CN',
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
                  cuaHangController.cuaHangModel.value.maCuaHang ?? '',
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

  Row _buildRowtenCuaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Tên CN',
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
                  cuaHangController.cuaHangModel.value.tenCuaHang ?? '',
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

  Row _buildRowSDTCuaHang() {
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
                  cuaHangController.cuaHangModel.value.sdt ?? '',
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

  Row _buildRowLoaiCuaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Loại CN',
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
                  cuaHangController.cuaHangModel.value.loaiCuaHang ?? '',
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

  Row _buildRowDiaChiCuaHang() {
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
                  cuaHangController.cuaHangModel.value.diaChi ?? '',
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

  Row _buildRowGhiChuCuaHang() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Ghi chú',
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
                  cuaHangController.cuaHangModel.value.ghiChu ?? '',
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
