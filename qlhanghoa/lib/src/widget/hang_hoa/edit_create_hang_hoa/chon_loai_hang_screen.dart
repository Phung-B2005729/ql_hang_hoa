import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/controller/loai_hang/loai_hang_controller.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';

// ignore: must_be_immutable
class ChonLoaiHangScreen extends StatelessWidget {
  LoaiHangController loaiHangController = Get.find();
  ThemHangHoaController themHangHoaController = Get.find();
  ChonLoaiHangScreen({super.key});

  @override
  Widget build(Object context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: GetBuilder<LoaiHangController>(
            builder: (controller) => ListView.builder(
                itemCount: controller.filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Dismissible(
                          key: Key(
                              controller.filteredList[index].sId.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            controller.delete(controller.filteredList[index]);
                            controller.filteredList.removeAt(index);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              // cập nhật controllerLoaiHang bên ThemHangHoaController và HangHoaModel.loaiHang = listLoaiHang[index]
                              themHangHoaController
                                  .saveLoaiHang(controller.filteredList[index]);
                              Get.back();
                            },
                            title: Text(
                              controller.filteredList[index].tenLoai!,
                              style: const TextStyle(color: Colors.black),
                            ),
                            selected: themHangHoaController.getIdLoaiHang() ==
                                controller.filteredList[index].sId,
                            trailing: themHangHoaController.getIdLoaiHang() ==
                                    controller.filteredList[index].sId
                                ? const Icon(
                                    Icons.check,
                                    color: ColorClass.color_button_nhat,
                                  )
                                : null,
                          ),
                        ),
                        const Divider(
                          color: ColorClass.color_thanh_ke,
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
        Obx(() => loaiHangController.loading.value == true
            ? const LoadingCircularFullScreen()
            : const SizedBox())
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        titleSpacing: 3,
        title: const Text(
          'Loại hàng',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              // chuyển về trang them hang hoa
              Get.back();
            },
            icon: const Icon(
              Icons.close,
              color: ColorClass.color_outline_icon,
              size: 28,
            )),
        actions: [
          IconButton(
              onPressed: () {
                // mo modal nhap ten loai hang va xu ly them
                Get.dialog(_buildDiaLogThem());
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 28,
              )),
        ],
        bottom: _buildBottomSearch());
  }

  AlertDialog _buildDiaLogThem() {
    return AlertDialog(
      title: const Text(
        'Thêm loại hàng',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      content: TextField(
        controller: loaiHangController.themLoaiHangController,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        cursorColor: Colors.black,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: ColorClass.color_button_nhat, width: 1),
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black,
          )),
          hintText: 'Nhập tên loại hàng',
          hintStyle: TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 170, 170, 170)),
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'HUỶ',
            style: TextStyle(color: ColorClass.color_cancel, fontSize: 18),
          ),
          onPressed: () {
            loaiHangController.themLoaiHangController.text = '';
            Get.back();
          },
        ),
        TextButton(
          child: const Text(
            'LƯU',
            style: TextStyle(color: ColorClass.color_button_nhat, fontSize: 18),
          ),
          onPressed: () async {
            Get.back();
            await loaiHangController
                .addLoaiHang(loaiHangController.themLoaiHangController.text);
          },
        ),
      ],
    );
  }

  PreferredSize _buildBottomSearch() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: Column(
        children: [
          const Divider(
            color: Colors.black,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 0),
            child: _buildTextFieldSearch(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSearch() {
    return Center(
      child: Obx(
        () => TextField(
          controller: loaiHangController.searchController,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: ColorClass.color_thanh_ke, width: 1),
              borderRadius: BorderRadius.circular(11),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 237, 237, 237), width: 1),
              borderRadius: BorderRadius.circular(11),
            ),
            fillColor: const Color(0xFFE6E4E4),
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: ColorClass.color_thanh_ke, width: 1),
                borderRadius: BorderRadius.circular(11)),
            hintText: 'Tên loại hàng',
            hintStyle: const TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 170, 170, 170)),
            prefixIcon: const Icon(
              Icons.search,
              color: ColorClass.color_thanh_ke,
            ),
            suffixIcon: loaiHangController.iconClose.value
                ? IconButton(
                    onPressed: () {
                      // delete value
                      loaiHangController.searchController.text = '';
                    },
                    icon: const Icon(Icons.close),
                    color: ColorClass.color_thanh_ke,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
