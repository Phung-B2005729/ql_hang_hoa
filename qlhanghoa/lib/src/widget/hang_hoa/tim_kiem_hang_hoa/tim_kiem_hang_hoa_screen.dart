import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/controller/cua_hang/cua_hang_controller.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/nhap_lo_controller.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/them_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/app_theme.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/model/chi_tiet_phieu_nhap_model.dart';
import 'package:qlhanghoa/src/model/cua_hang_model.dart';
import 'package:qlhanghoa/src/model/hang_hoa_model.dart';
import 'package:qlhanghoa/src/model/lo_hang.model.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/xem_chi_tiet/chi_tiet_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/them_phieu_nhap/nhap_hang_tung_hang_hoa_screen.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/them_phieu_nhap/nhap_lo_screen.dart';

class TimKiemHangHoaScreen extends GetView<HangHoaController> {
  TimKiemHangHoaScreen({super.key, this.themPhieuNhap});
  final bool? themPhieuNhap;
  final BottomNavigationController bottomController = Get.find();

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: _builAppBar(),
      body: Container(
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
          child: GetBuilder<HangHoaController>(
              builder: (controller) =>
                  (controller.searchController.text.isNotEmpty)
                      ? (controller.filteredList.isEmpty)
                          ? const Center(
                              child: Text('Không tìm thấy kết quả phù hợp'))
                          : ListView.builder(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 30),
                              itemCount: controller.filteredList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return (themPhieuNhap != null &&
                                        themPhieuNhap == true)
                                    ? _buildContainerHangHoa(controller, index)
                                    : Dismissible(
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
                                        child: _buildContainerHangHoa(
                                            controller, index));
                              })
                      : const SizedBox())),
    );
  }

  GestureDetector _buildContainerHangHoa(
      HangHoaController controller, int index) {
    return GestureDetector(
      onTap: () async {
        if (themPhieuNhap != null && themPhieuNhap == true) {
          // tìm xem hàng hoá này có trong list chi tiêt  hay chưa
          ThemPhieuNhapController themPhieuNhapController = Get.find();
          int indexChiTiet =
              themPhieuNhapController.getIndexHangHoaTrongChiTiet(
                  controller.filteredList[index].maHangHoa!);
          NhapLoController nhapLoController = Get.find();
          if (indexChiTiet >= 0) {
            // đã có trong list chi tiết, không cần thêm hàng hoá chỉ cần chuyển trang

            nhapLoController.setUpData(
                chiTiet:
                    themPhieuNhapController.listChiTietPhieuNhap[indexChiTiet],
                hangHoa: controller.filteredList[index],
                indext: indexChiTiet);
            Get.to(() => const NhapHangTheoTungHangHoa(
                  chuyenTuTimKiem: true,
                ));
          } else {
            // thêm mới vào chi tiết và chuyển trang
            nhapLoController.setUpData(
                chiTiet: ChiTietPhieuNhapModel(
                    maHangHoa: controller.filteredList[index].maHangHoa,
                    soLuong: 0),
                hangHoa: controller.filteredList[index],
                indext: -1);
            if (controller.filteredList[index].quanLyTheoLo != true) {
              // chuyển đến thêm số lượng khôgn quản lý theo lô
              Get.to(() => const NhapHangTheoTungHangHoa(
                    chuyenTuTimKiem: true,
                  ));
            } else {
              // chuyển đến thêm lô mới
              nhapLoController.setUpDataThemLo(LoHangModel(
                maHangHoa: controller.filteredList[index].maHangHoa,
              ));

              Get.to(() => const ThemLoScreen(
                    themMoi: true,
                  ));
            }
          }
        } else {
          // gọi findOne chi tiết hàng hoá data
          await controller
              .getFindOne(controller.filteredList[index].maHangHoa!);
          Get.to(() => ChiTietHangHoaScreen());
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorClass.color_thanh_ke)),
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: (controller.filteredList[index].hinhAnh != null &&
                      controller.filteredList[index].hinhAnh!.isNotEmpty)
                  ? Image.network(
                      controller.filteredList[index].hinhAnh![0].linkAnh!,
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(
                            'assets/images/hang_hoa_mac_dinh.png',
                            fit: BoxFit.contain);
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: const Color.fromARGB(255, 185, 185, 185),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.filteredList[index].tenHangHoa!,
                        style: AppTheme.lightTextTheme.bodyLarge,
                      ),
                      Obx(
                        () => Text(
                          FunctionHelper.formNum(
                              (controller.giaBan.value != true)
                                  ? controller.filteredList[index].giaVon
                                  : controller.filteredList[index].donGiaBan),
                          style: AppTheme.lightTextTheme.bodyMedium,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.filteredList[index].maHangHoa!,
                        style: AppTheme.lightTextTheme.displaySmall,
                      ),
                      Obx(
                        () => Text(
                          "${FunctionHelper.formNum(controller.tongsoLuongTonKhoTrongListLoHang(hangHoa: controller.filteredList[index]).toString())} ${controller.filteredList[index].donViTinh!}",
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

  AppBar _builAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            // back và reset lại tìm kiếm và onsubmit
            controller.searchController.text = '';
            controller.setOnSubmit(false);
            Get.back();
          },
          icon: const Icon(
            Icons.navigate_before,
            size: 45,
            color: Color.fromARGB(193, 17, 17, 17),
          )),
      titleSpacing: 0,
      toolbarHeight: 125,
      //    expandedHeight: 350.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
              10), // Điều này sẽ bo tròn góc dưới của SliverAppBar
        ),
      ),
      actions: [
        Obx(
          () => controller.onsubmit.value == true
              ? Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: IconButton(
                      onPressed: () {
                        // chuyển trang nhập tìm kiếm
                        controller.setOnSubmit(false);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 57, 57, 57),
                        size: 27,
                      )),
                )
              : const SizedBox(),
        ),
        /* Obx(
            () => controller.onsubmit.value == true
                ? Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                        onPressed: () {
                          // chuyển trang lộc hàng hoá
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.filter,
                          size: 20,
                          color: Color.fromARGB(255, 57, 57, 57),
                        )),
                  )
                : const SizedBox(),
          ) */
      ],
      title: _buildTextSearch(),
      bottom: _buildBottomAppBar(),
    );
  }

  Obx _buildTextSearch() {
    return Obx(
      () => (controller.onsubmit.value == true)
          ? Text(
              controller.searchController.text,
              style: const TextStyle(fontSize: 17),
            )
          : Container(
              margin: const EdgeInsets.only(right: 20),
              color: Colors.white,
              height: 50,
              child: Obx(() => TextField(
                    onSubmitted: (value) {
                      controller.setOnSubmit(true);
                      print('gọi submit');
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.iconClose.value = true;
                      } else {
                        controller.iconClose.value = false;
                      }
                    },
                    controller: controller.searchController,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: ColorClass.color_xanh_it_dam, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 64, 64, 64), width: 1),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      fillColor: const Color.fromARGB(255, 246, 246, 246),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 64, 64, 64), width: 1),
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'Tên hàng, thương hiệu, loại hàng..',
                      hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 170, 170, 170)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: ColorClass.color_thanh_ke,
                      ),
                      suffixIcon: controller.iconClose.value == true
                          ? IconButton(
                              onPressed: () {
                                // delete value
                                controller.searchController.text = '';
                              },
                              icon: const Icon(Icons.close),
                              color: ColorClass.color_thanh_ke,
                            )
                          : null,
                    ),
                  ))),
    );
  }

  PreferredSize _buildBottomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(20.0),
      child: Obx(
        () => controller.onsubmit.value != true
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 10, top: 0),
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
                            FunctionHelper.formNum(
                                controller.tongsoLuong().toString()),
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
                                        style:
                                            AppTheme.lightTextTheme.bodySmall),
                                  );
                                }),
                              );
                            }
                            return Obx(
                              () => DropdownButton<String>(
                                value: controller.maCuaHang.value.toString(),
                                items: cuaHangController.listCuaHang.isNotEmpty
                                    ? dropdownItems
                                    : [
                                        DropdownMenuItem<String>(
                                          value: '',
                                          child: Text('',
                                              style: AppTheme
                                                  .lightTextTheme.bodySmall),
                                        )
                                      ],
                                onChanged: (dynamic newValue) {
                                  if (newValue != null) {
                                    controller.maCuaHang.value =
                                        newValue.toString();
                                  }
                                },
                              ),
                            );
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
      ),
    );
  }
}
