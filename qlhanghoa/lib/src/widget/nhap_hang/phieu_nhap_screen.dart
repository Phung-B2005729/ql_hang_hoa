import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/nhan_vien/nhan_vien_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/them_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/xem_chi_tiet/chi_tiet_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/app_theme.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/chi_tiet_phieu_nhap_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/them_phieu_nhap/them_phieu_nhap_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/tim_kiem_phieu_nhap_screen.dart';

import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class PhieuNhapScreen extends GetView<PhieuNhapController> {
  final BottomNavigationController bottomController = Get.find();
  NhanVienController nhanVienController = Get.find();

  PhieuNhapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
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
            child: Obx(
              () => AppBar(
                leading: (controller.onSubmit.value == true)
                    ? IconButton(
                        onPressed: () async {
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
                              thongTinPhieuNhap:
                                  controller.thongTinPhieuNhap.text,
                              thongTinNhaCungCap:
                                  controller.thongTinNhaCungCap.text);
                        },
                        icon: const Icon(
                          Icons.navigate_before,
                          color: ColorClass.color_outline_icon,
                          size: 30,
                        ))
                    : null,
                //backgroundColor: Colors.white,
                title: (controller.onSubmit != true)
                    ? Text(
                        'Nhập Hàng',
                        style: AppTheme.lightTextTheme.titleLarge,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.thongTinPhieuNhap.text,
                            style: AppTheme.lightTextTheme.titleLarge,
                          ),
                          Row(
                            children: [
                              Text(
                                controller.thongTinHangHoa.text,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              Text(
                                controller.thongTinNhaCungCap.text,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              )
                            ],
                          )
                        ],
                      ),
                titleSpacing: 20,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: IconButton(
                        onPressed: () {
                          // chuyển trang tìm kiếm phiếu nhập
                          controller.onSubmit.value = false;
                          Get.to(() => TimKiemPhieuNhapScreen());
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 57, 57, 57),
                          size: 30,
                        )),
                  ),
                ],
                bottom: _buildBottomAppBar(context),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Obx(
            () => controller.listPhieuNhap.isEmpty
                ? Column(
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
                      const Text('Chưa có thông tin phiếu nhập'),
                      TextButton(
                          onPressed: () async {
                            await controller.getlistPhieuNhap(
                                ngayBatDau: controller.ngayBatDau.value,
                                ngayKetThuc: controller.ngayKetThuc.value,
                                trangThai: controller.trangThai.value,
                                maCuaHang: controller.maCuaHang.value,
                                maNhanVien: controller.maNhanVien.value,
                                thongTinHangHoa:
                                    controller.thongTinHangHoa.text,
                                thongTinLoHang: controller.thongTinLoHang.text,
                                thongTinPhieuNhap:
                                    controller.thongTinPhieuNhap.text,
                                thongTinNhaCungCap:
                                    controller.thongTinNhaCungCap.text);
                          },
                          child: const Text(
                            'Tải lại',
                            style: TextStyle(
                                fontSize: 15,
                                color: ColorClass.color_xanh_it_dam,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: ColorClass.color_thanh_ke.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(3, 0),
                        ),
                      ],
                    ),
                    child: GetBuilder<PhieuNhapController>(
                        builder: (controller) => ListView.builder(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 30, top: 10),
                            itemCount: controller.listPhieuNhap.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  // chuyển đến xem chi tiết
                                  ChiTietPhieuNhapController
                                      chiTietPhieuNhapController = Get.find();
                                  print('gọi find');
                                  await chiTietPhieuNhapController
                                      .getOnePhieuNhap(controller
                                              .listPhieuNhap[index]
                                              .maPhieuNhap ??
                                          '');
                                  Get.to(() => const ChiTietPhieuNhapScreen());
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: ColorClass.color_thanh_ke)),
                                  ),
                                  height: null,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.moneyBill,
                                            size: 25,
                                            color: ColorClass.color_button_nhat,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  FunctionHelper.formNum(
                                                      controller
                                                          .listPhieuNhap[index]
                                                          .tongTien
                                                          .toString()),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: ColorClass
                                                          .color_xanh_it_dam),
                                                ),
                                                Text(
                                                  controller
                                                      .listPhieuNhap[index]
                                                      .maPhieuNhap
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Ngày ${FunctionHelper.formatDateTimeString(controller.listPhieuNhap[index].ngayLapPhieu.toString())}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  controller
                                                              .listPhieuNhap[
                                                                  index]
                                                              .trangThai !=
                                                          null
                                                      ? controller
                                                          .listPhieuNhap[index]
                                                          .trangThai
                                                          .toString()
                                                      : 'Phiếu tạm',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 28),
                                        child: Text(
                                          controller.listPhieuNhap[index]
                                                      .nhaCungCap !=
                                                  null
                                              ? controller.listPhieuNhap[index]
                                                  .nhaCungCap!.tenNhaCungCap
                                                  .toString()
                                              : ''.toString(),
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: ColorClass.color_cancel),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }))),
          ),
          Obx(() => controller.loading.value
              ? const LoadingCircularFullScreen()
              : const SizedBox())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
          HangHoaController hangHoaController = Get.find();
          if (hangHoaController.listHangHoa.isEmpty) {
            await hangHoaController.getlistHangHoa();
          }
          // chuyển đến thêm phiếu nhập
          ThemPhieuNhapController themPhieuNhapController = Get.find();
          themPhieuNhapController.reSetData();

          Get.to(() => ThemPhieuNhapScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  AlertDialog _builDiaLogDelete(HangHoaModel hangHoa) {
    return AlertDialog(
      title: const Text(
        'Bạn có chắc chắn ?',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      content: const Text('Bạn có chắc chắn muốn huỷ phiếu này ?',
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
            // gọi hàm huỷ phiếu

            Get.back();
          },
        ),
      ],
    );
  }

  PreferredSize _buildBottomAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(20),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 5, bottom: 10, top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(
              color: Color.fromARGB(255, 114, 114, 114),
            ),
            ListTile(
              onTap: () {
                // mở model chọn ngày tháng
                _buildChooseNgayThangNam(context);
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.event,
                    color: Colors.black,
                    size: 26,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Obx(
                    () => FunctionHelper.soSanhTwoStringUTCWithToDay(
                                controller.ngayBatDau.value.toString(),
                                controller.ngayKetThuc.value.toString()) ==
                            true
                        ? Text(
                            'Hôm nay, ${FunctionHelper.formatDateString(controller.ngayBatDau.value)}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          )
                        : Text(
                            '${FunctionHelper.formatDateString(controller.ngayBatDau.value)}, ${FunctionHelper.formatDateString(controller.ngayKetThuc.value)}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          controller.listPhieuNhap.length.toString(),
                          style: AppTheme.lightTextTheme.titleSmall,
                        ),
                      ),
                      const Text(
                        ' phiếu - SL: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Obx(
                        () => Text(
                          FunctionHelper.formNum(controller
                              .tinhTongHangNhapTuListPhieuNhap(
                                  controller.listPhieuNhap)
                              .toString()),
                          style: AppTheme.lightTextTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Tổng tiền:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Obx(
                        () => Text(
                          FunctionHelper.formNum(controller
                              .tinhTongTienNhapHang(controller.listPhieuNhap)
                              .toString()),
                          style: AppTheme.lightTextTheme.titleSmall,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  _buildChooseNgayThangNam(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false, // ngăn việc tắt modal khi chạm bên ngoài
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Từ ngày',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 221, 221, 221)),
                  child: ListTile(
                    onTap: () {
                      // mở nhập ngày
                      _selectDate(context, true);
                    },
                    title: Obx(
                      () => Text(
                        FunctionHelper.formatDateString(
                            controller.ngayBatDau.value.toString()),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    trailing: const Icon(Icons.event),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: ColorClass.color_thanh_ke,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Đến ngày',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 221, 221, 221)),
                  child: ListTile(
                    onTap: () {
                      // mở nhập ngày
                      _selectDate(context, false);
                    },
                    title: Obx(
                      () => Text(
                        FunctionHelper.formatDateString(
                            controller.ngayKetThuc.value.toString()),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    trailing: const Icon(Icons.event),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        controller.traVeNgayCu();
                      },
                      child: const Text(
                        'HUỶ',
                        style: TextStyle(
                            color: ColorClass.color_cancel,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        // gọi check kiểm tra bằng
                        controller.soSanhVaSetLaiNgayKetThuc();
                        controller.setNgayCu();
                        // sau đó gọi getlist
                        await controller.getlistPhieuNhap(
                            ngayBatDau: controller.ngayBatDau.value,
                            ngayKetThuc: controller.ngayKetThuc.value,
                            trangThai: controller.trangThai.value,
                            maCuaHang: controller.maCuaHang.value,
                            maNhanVien: controller.maNhanVien.value,
                            thongTinHangHoa: controller.thongTinHangHoa.text,
                            thongTinLoHang: controller.thongTinLoHang.text,
                            thongTinPhieuNhap:
                                controller.thongTinPhieuNhap.text,
                            thongTinNhaCungCap:
                                controller.thongTinNhaCungCap.text);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            color: ColorClass.color_xanh_it_dam,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }

  // them ngay mo/dong
  Future<void> _selectDate(BuildContext context, bool BatDau) async {
    final DateTime seleted = await BatDau == true &&
            controller.ngayBatDau.isNotEmpty
        ? // ngày đưa vào khách rỗng
        (FunctionHelper.getDataTimeVnFormStringUTC(controller.ngayBatDau.value))
        : ((controller.ngayBatDau.isNotEmpty)
            ? (FunctionHelper.getDataTimeVnFormStringUTC(
                controller.ngayKetThuc.value))
            : DateTime.now()); // lấy thời gian ngày hôm nay
    // set ngay thang
    // ignore: use_build_context_synchronously
    final DateTime? pickedDate = await showDatePicker(
      // mở modal chọn ngày tháng năm
      // mở ngày
      context: context,
      initialDate: seleted, // thời gian chọn mặc định
      firstDate: DateTime(1900), // bắt đầu
      lastDate: DateTime(2100), // kết thúc
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // chỉnh màu
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      // cập nhật giá trị khi đã chọn xong
      if (BatDau == true) {
        controller.setNgayBatDau(pickedDate);
      } else {
        controller.setNgayKetThuc(pickedDate);
      }
    }
  }
}
