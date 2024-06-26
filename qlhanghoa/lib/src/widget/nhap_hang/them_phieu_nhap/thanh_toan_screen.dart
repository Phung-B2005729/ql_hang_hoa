// ignore_for_file: unused_element, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/them_phieu_nhap_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';

import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ThanhToanScreen extends GetView<ThemPhieuNhapController> {
  const ThanhToanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        () => controller.loading != true
            ? Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, bottom: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorClass.color_thanh_ke
                                      .withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(3, 0),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Phương thức',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  'Tiền mặt',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          __buildContrainerTongCong(),
                        ],
                      ),
                    ),
                  ),
                  _buildButtonXuLy(),
                ],
              )
            : const LoadingCircularFullScreen(),
      ),
    );
  }

  Container _buildButtonXuLy() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.green),
                ),
                onPressed: () {
                  // lưu tạm
                },
                child: const Text(
                  'Lưu tạm',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
            ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                ),
                onPressed: () {
                  // lưu tạm
                },
                child: const Text(
                  'Hoàn thành',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
        ));
  }

  Container __buildContrainerTongCong() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: ColorClass.color_thanh_ke.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(3, 0),
          ),
        ],
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: [
              _buildRowTongCong(),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: Column(
            children: [
              _buildRowGiaGiam(),
            ],
          ),
        ),
        Container(
          //margin: EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(left: 15, top: 10, right: 20),
          child: Column(
            children: [
              _buildRowCanTra(),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, left: 15, right: 20),
          child: Column(
            children: [
              _buildTienDaTraNhaCungCap(),
            ],
          ),
        ),
      ]),
    );
  }

  Row _buildRowTongCong() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tổng cộng',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        GetBuilder<ThemPhieuNhapController>(
          builder: (controller) => Text(
            FunctionHelper.formNum((controller.tinhTongTien()).toString()),
            style: const TextStyle(
                color: ColorClass.color_xanh_it_dam, fontSize: 16),
          ),
        )
      ],
    );
  }

  Row _buildRowCanTra() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Cần trả NCC',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        GetBuilder<ThemPhieuNhapController>(
          builder: (controller) => Text(
            FunctionHelper.formNum(
                (controller.tinhTongTien(truTongGiam: true)).toString()),
            style: const TextStyle(
                color: ColorClass.color_xanh_it_dam, fontSize: 16),
          ),
        )
      ],
    );
  }

  Row _buildRowGiaGiam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Giá giảm',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(
          width: 50,
        ),
        Expanded(child: _buildTextFormFileGiaGiam())
      ],
    );
  }

  TextFormField _buildTextFormFileGiaGiam() {
    return TextFormField(
      textAlign: TextAlign.end,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      controller: controller.giaGiamController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          try {
            //   var va = newValue.text.toString().replaceAll(',', '');
            final int parsedValue = int.parse(newValue.text);
            // ignore: avoid_print
            print(parsedValue);

            if (parsedValue < 0 || parsedValue > 999999999) {
              return oldValue; // Giữ nguyên giá trị cũ nếu nằm ngoài khoảng
            }

            if (parsedValue > controller.tinhTongTien()) {
              // ignore: curly_braces_in_flow_control_structures
              GetShowSnackBar.warningSnackBar(
                  'Giá giảm nhập không vượt quá thành tiền');
              return oldValue;
            }
          } catch (e) {
            // Xử lý ngoại lệ nếu có
          }
          return newValue; // Trả về giá trị mới nếu hợp lệ
        }),
      ],
      validator: (value) {
        var va = value.toString().replaceAll(',', '');
        if (int.tryParse(va) == null) {
          return 'Vui lòng nhập vào giá trị số';
        }
        if (int.parse(va) < 0) {
          return 'Giá trị phải lớn hơn hoặc bằng 0';
        }
        return null;
      },
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        hintText: '0',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          controller.giaGiamController.text = '0';
          controller.changeGiaGiam('0');
        }

        if (int.tryParse(value) != null) {
          //  print(FunctionHelper.formNum(value));

          controller.changeGiaGiam(value);
          controller.giaGiamController.text = FunctionHelper.formNum(value);
        }
      },
    );
  }

  Row _buildTienDaTraNhaCungCap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tiền trả NCC',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        Expanded(child: buildTextFormFileTienDaTraNhaCungCap())
      ],
    );
  }

  TextFormField buildTextFormFileTienDaTraNhaCungCap() {
    return TextFormField(
      textAlign: TextAlign.end,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      controller: controller.daTraNCCController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          try {
            //   var va = newValue.text.toString().replaceAll(',', '');
            final int parsedValue = int.parse(newValue.text);
            // ignore: avoid_print
            print(parsedValue);
            if (parsedValue < 0 ||
                parsedValue > controller.tinhTongTien(truTongGiam: true)) {
              if (parsedValue > controller.tinhTongTien(truTongGiam: true)) {
                // ignore: curly_braces_in_flow_control_structures
                GetShowSnackBar.warningSnackBar(
                    'Tiền trả không vượt quá tổng tiền');
              }
              return oldValue; // Giữ nguyên giá trị cũ nếu nằm ngoài khoảng
            }
          } catch (e) {
            // Xử lý ngoại lệ nếu có
          }
          return newValue; // Trả về giá trị mới nếu hợp lệ
        }),
      ],
      validator: (value) {
        var va = value.toString().replaceAll(',', '');
        if ((va.isEmpty)) {
          return 'Vui lòng nhập giá bán';
        }
        if (int.tryParse(va) == null) {
          return 'Vui lòng nhập vào giá trị số';
        }
        if (int.parse(va) < 0) {
          return 'Giá trị phải lớn hơn hoặc bằng 0';
        }
        return null;
      },
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        hintText: '0',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          controller.daTraNCCController.text = '0';
        }

        if (int.tryParse(value) != null) {
          //  print(FunctionHelper.formNum(value));

          controller.daTraNCCController.text = FunctionHelper.formNum(value);
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        titleSpacing: 3,
        title: const Text(
          // ignore: unnecessary_null_comparison
          'Thanh toán',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.navigate_before,
              color: ColorClass.color_outline_icon,
              size: 26,
            )));
  }

  // lô
}
