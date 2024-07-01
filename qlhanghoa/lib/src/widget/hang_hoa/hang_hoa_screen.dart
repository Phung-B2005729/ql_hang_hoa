import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/app_theme.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/model/cua_hang_model.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/xem_chi_tiet/chi_tiet_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/edit_create_hang_hoa/them_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/tim_kiem_hang_hoa/tim_kiem_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class HangHoaScreen extends GetView<HangHoaController> {
  final BottomNavigationController bottomController = Get.find();
  CuaHangController cuaHangController = Get.find();

  HangHoaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Sử dụng WidgetsBinding.instance.addPostFrameCallback để thực hiện thay đổi sau khi build hoàn tất.
      if (cuaHangController.listCuaHang.isEmpty) {
        cuaHangController.getlistCuaHang();
      }

      controller.getlistHangHoa();
    });

    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Obx(
            () => controller.filteredList.isEmpty
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
                      const Text('Chưa có hàng hoá được thêm'),
                      TextButton(
                          onPressed: () async {
                            await controller.getlistHangHoa();
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
                    child: GetBuilder<HangHoaController>(
                        builder: (controller) => ListView.builder(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 30),
                            itemCount: controller.filteredList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                key: Key(controller
                                    .filteredList[index].maHangHoa
                                    .toString()),
                                confirmDismiss: (direction) async {
                                  // Hiển thị hộp thoại xác nhận trước khi xóa
                                  return Get.dialog(_builDiaLogDelete(
                                      controller.filteredList[index]));
                                },
                                direction: DismissDirection.endToStart,
                                child: GestureDetector(
                                  onTap: () async {
                                    // chuyển đến trang thêm + edit

                                    // gọi findOne data
                                    await controller.getFindOne(controller
                                        .filteredList[index].maHangHoa!);
                                    Get.to(() => ChiTietHangHoaScreen());
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  ColorClass.color_thanh_ke)),
                                    ),
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 45,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: (controller.filteredList[index]
                                                          .hinhAnh !=
                                                      null &&
                                                  controller.filteredList[index]
                                                      .hinhAnh!.isNotEmpty)
                                              ? Image.network(
                                                  controller.filteredList[index]
                                                      .hinhAnh![0].linkAnh!,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    print('error image');
                                                    return Image.asset(
                                                        'assets/images/hang_hoa_mac_dinh.png',
                                                        fit: BoxFit.contain);
                                                  },
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              185, 185, 185),
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                )
                                              : Image.asset(
                                                  'assets/images/hang_hoa_mac_dinh.png',
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    controller
                                                        .filteredList[index]
                                                        .tenHangHoa!,
                                                    style: AppTheme
                                                        .lightTextTheme
                                                        .bodyLarge,
                                                  ),
                                                  Obx(
                                                    () => Text(
                                                      FunctionHelper.formNum(
                                                          (controller.giaBan
                                                                      .value !=
                                                                  true)
                                                              ? controller
                                                                  .filteredList[
                                                                      index]
                                                                  .giaVon
                                                              : controller
                                                                  .filteredList[
                                                                      index]
                                                                  .donGiaBan),
                                                      style: AppTheme
                                                          .lightTextTheme
                                                          .bodyMedium,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    controller
                                                        .filteredList[index]
                                                        .maHangHoa!,
                                                    style: AppTheme
                                                        .lightTextTheme
                                                        .displaySmall,
                                                  ),
                                                  Obx(
                                                    () => Text(
                                                      "${FunctionHelper.formNum(controller.tongsoLuongTonKhoTrongListLoHang(hangHoa: controller.filteredList[index]).toString())} ${controller.filteredList[index].donViTinh!}",
                                                      style: AppTheme
                                                          .lightTextTheme
                                                          .titleSmall,
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
                                ),
                              );
                            }))),
          ),
          Obx(() => (controller.loading.value ||
                  cuaHangController.loading.value == true)
              ? const LoadingCircularFullScreen()
              : const SizedBox())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // chuyển đến
          ThemHangHoaController controllerThemHangHoa = Get.find();
          controllerThemHangHoa.reSetData();
          Get.to(() => ThemHangHoaScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
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
          child: AppBar(
            //backgroundColor: Colors.white,
            title: const Text(
              'Hàng Hoá',
            ),
            titleSpacing: 20,
            titleTextStyle: AppTheme.lightTextTheme.titleLarge,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: IconButton(
                    onPressed: () {
                      // chuyển trang nhập tìm kiếm
                      Get.to(() => TimKiemHangHoaScreen());
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 57, 57, 57),
                      size: 30,
                    )),
              ),
            ],
            bottom: _buildBottomAppBar(),
          ),
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
      content: const Text('Bạn có chắc chắn muốn xoá sản phẩm này ?',
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
            // gọi hàm xoá
            controller.delete(hangHoa);
            Get.back();
          },
        ),
      ],
    );
  }

  PreferredSize _buildBottomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 0),
        child: Column(
          children: [
            const Divider(
              color: Color.fromARGB(255, 114, 114, 114),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<HangHoaController>(
                  builder: (controller) => Text(
                    controller.filteredList.length.toString(),
                    style: AppTheme.lightTextTheme.titleSmall,
                  ),
                ),
                const Text(
                  ' hàng hoá - Tồn kho ',
                  style: TextStyle(fontSize: 14),
                ),
                Obx(
                  () => Text(
                    FunctionHelper.formNum(controller.tongsoLuong().toString()),
                    style: AppTheme.lightTextTheme.titleSmall,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<CuaHangController>(
                  builder: (cuaHangController) {
                    List<DropdownMenuItem<String>> dropdownItems = [];

                    // Thêm mục "Tất cả" vào đầu danh sách
                    dropdownItems.add(
                      DropdownMenuItem<String>(
                        value: 'Tất cả',
                        child: Text('Tất cả',
                            style: AppTheme.lightTextTheme.bodySmall),
                      ),
                    );

                    // Thêm các mục từ danh sách cửa hàng
                    if (cuaHangController.listCuaHang.isNotEmpty) {
                      dropdownItems.addAll(
                        cuaHangController.listCuaHang
                            .map((CuaHangModel cuaHang) {
                          return DropdownMenuItem<String>(
                            value: cuaHang.maCuaHang.toString(),
                            child: Text(cuaHang.tenCuaHang!,
                                style: AppTheme.lightTextTheme.bodySmall),
                          );
                        }),
                      );
                    }
                    return cuaHangController.listCuaHang.isNotEmpty
                        ? Obx(
                            () => DropdownButton<String>(
                              value: controller.maCuaHang.value.toString(),
                              items: dropdownItems,
                              onChanged: (dynamic newValue) {
                                if (newValue != null) {
                                  controller.maCuaHang.value =
                                      newValue.toString();
                                }
                              },
                            ),
                          )
                        : const SizedBox();
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Obx(
                    () => DropdownButton<bool>(
                      value: controller.giaBan.value,
                      items: [
                        DropdownMenuItem(
                          value: true,
                          child: Text('Giá bán',
                              style: AppTheme.lightTextTheme.bodySmall),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text('Giá vốn',
                              style: AppTheme.lightTextTheme.bodySmall),
                        ),
                      ],
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          print('gọi');
                          controller.changeHienThiGia(newValue);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
