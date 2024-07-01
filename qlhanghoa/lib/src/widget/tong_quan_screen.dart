import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/tong_quan_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/app_theme.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';

class TongQuanScreen extends StatelessWidget {
  final AuthController controller = Get.find();
  final HangHoaController hangHoaControler = Get.find();
  final TongQuanController tongQuanController = Get.find();

  TongQuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setUpData();
      tongQuanController.setUpData();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Sử dụng WidgetsBinding.instance.addPostFrameCallback để thực hiện thay đổi sau khi build hoàn tất.
      if (hangHoaControler.listHangHoa.isEmpty) {
        hangHoaControler.getlistHangHoa();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ArCH-TP',
          textAlign: TextAlign.start,
        ),
        leading: FractionallySizedBox(
            widthFactor: 0.6,
            child: Image.asset('assets/logo/logo_xanh_vang_x2.png')),
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        titleTextStyle: AppTheme.lightTextTheme.titleLarge,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20.0, top: 10),
            child: const Stack(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: ColorClass.color_outline_icon,
                  size: 30,
                ),
                Positioned(
                  left: 15,
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 146, 146, 146).withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(3, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 15, left: 40),
                padding: const EdgeInsets.only(top: 8, bottom: 10, left: 5),
                width: 170,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(106, 207, 207, 207),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Hôm nay, ${FunctionHelper.formatDateString(DateTime.now().toUtc().toIso8601String())}',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 35, right: 35),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetBuilder<TongQuanController>(
                          builder: (controller) => Text(
                            '${controller.listPhieuNhap.length} đơn nhập hàng',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        GetBuilder<TongQuanController>(
                          builder: (controller) => Text(
                            FunctionHelper.formNum(
                              controller
                                  .tinhTongSoLuongHangNhapTrongListPhieuNhap(
                                      controller.listPhieuNhap),
                            ),
                            style: const TextStyle(
                              color: ColorClass.color_xanh_it_dam,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Text(
                          'Sản phẩm',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'TỔNG TIỀN',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        GetBuilder<TongQuanController>(
                          builder: (controller) => Text(
                            FunctionHelper.formNum(
                              controller.tinhTongTienNhapHang(
                                  controller.listPhieuNhap),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: ColorClass.color_xanh_it_dam,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Text(
                          'VND',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(
                    left: 2, right: 2, top: 20, bottom: 15),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 15, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 146, 146, 146)
                          .withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TỒN KHO',
                        style: TextStyle(
                            color: ColorClass.color_xanh_it_dam,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Obx(
                        () => Text(
                          FunctionHelper.formNum(
                              tongQuanController.tongTonKho.toString()),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 2, right: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: ColorClass.color_thanh_ke.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(3, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 13,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'LÔ HÀNG SẮP ĐẾN HẠN',
                              style: TextStyle(
                                  color: ColorClass.color_xanh_it_dam,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GetBuilder<TongQuanController>(
                                builder: (controller) => Text(
                                  '${controller.listLoHangDenHan.length.toString()} Lô',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 88, 188),
                                      fontSize: 16),
                                ),
                              ),
                              GetBuilder<TongQuanController>(
                                builder: (controller) => Text(
                                  '${FunctionHelper.formNum(controller.tongSanPhamTrongDenHan())} sản phẩm',
                                  style: const TextStyle(
                                      // fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 0, 88, 188),
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Expanded(
                          child: GetBuilder<TongQuanController>(
                              builder: (controller) => ListView.builder(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 30),
                                  itemCount: controller.listLoHangDenHan.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {},
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    controller
                                                                .listLoHangDenHan[
                                                                    index]
                                                                .hangHoa !=
                                                            null
                                                        ? '${controller.listLoHangDenHan[index].hangHoa!.tenHangHoa} (${controller.listLoHangDenHan[index].hangHoa!.donViTinh.toString()})'
                                                        : '',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        //  fontWeight: FontWeight.w600,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                      FunctionHelper.tinhSoNgay(
                                                                  controller
                                                                      .listLoHangDenHan[
                                                                          index]
                                                                      .hanSuDung
                                                                      .toString()) >
                                                              0
                                                          ? '${FunctionHelper.tinhSoNgay(controller.listLoHangDenHan[index].hanSuDung.toString()).toString()} ngày'
                                                          : (FunctionHelper.tinhSoNgay(controller.listLoHangDenHan[index].hanSuDung.toString()) == 0
                                                              ? 'Đến hạn hôm nay'
                                                              : 'Đã hết hạn'),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          //  fontWeight: FontWeight.w600,
                                                          color: FunctionHelper.tinhSoNgay(controller
                                                                      .listLoHangDenHan[
                                                                          index]
                                                                      .hanSuDung
                                                                      .toString()) >
                                                                  10
                                                              ? Colors.green
                                                              : (FunctionHelper.tinhSoNgay(controller.listLoHangDenHan[index].hanSuDung.toString()) ==
                                                                      0
                                                                  ? Colors.orange
                                                                  : Colors.red)))
                                                ],
                                              ),

                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      controller
                                                          .listLoHangDenHan[
                                                              index]
                                                          .maHangHoa
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: ColorClass
                                                              .color_xanh_it_dam)),
                                                  Text(
                                                      controller
                                                                  .listLoHangDenHan[
                                                                      index]
                                                                  .hangHoa !=
                                                              null
                                                          ? "Tồn ${FunctionHelper.formNum(controller.listLoHangDenHan[index].soLuongTon!.toString())} ${controller.listLoHangDenHan[index].hangHoa!.donViTinh}"
                                                          : "Tồn ${FunctionHelper.formNum(controller.listLoHangDenHan[index].soLuongTon!.toString())}",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black)),
                                                ],
                                              ),

                                              const SizedBox(
                                                height: 5,
                                              ),
                                              // ignore: unused_local_variable
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
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
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: const Center(
                                                        child: Text(
                                                          'Lô',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        controller
                                                            .listLoHangDenHan[
                                                                index]
                                                            .soLo
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14)),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    controller
                                                                .listLoHangDenHan[
                                                                    index]
                                                                .hanSuDung !=
                                                            null
                                                        ? Text(
                                                            "HSD ${FunctionHelper.formatDateString(controller.listLoHangDenHan[index].hanSuDung.toString())}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black))
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Divider(
                                                color: Color.fromARGB(
                                                    255, 144, 144, 144),
                                              )
                                            ]),
                                      ),
                                    );
                                  })),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
