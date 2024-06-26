import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/hang_hoa/them_and_edit_hang_hoa_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ThietLapGiaBanScreen extends GetView<ThemHangHoaController> {
  const ThietLapGiaBanScreen({super.key, this.themPhieuNhap});
  final bool? themPhieuNhap;

  @override
  Widget build(Object context) {
    return Stack(children: [
      Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
              child: Form(
                  key: controller.formKey,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 0),
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
                      child: _buildRowGiaBan())))),
      Obx(() => controller.loading.value
          ? const LoadingCircularFullScreen()
          : const SizedBox())
    ]);
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 3,
      title: Obx(
        () => Text(
          controller.edit.value == true
              ? controller.hangHoaModel.value.maHangHoa.toString()
              : 'Thiết lập giá bán',
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
            Icons.close,
            color: ColorClass.color_outline_icon,
            size: 28,
          )),
      actions: [
        TextButton(
            onPressed: () async {
              print('gọi');
              await controller.upDate(themPhieuNhap: themPhieuNhap);
              // xử lý thêm  hàng hoá
            },
            child: const Text(
              'Lưu',
              style: TextStyle(
                fontSize: 18,
                color: ColorClass.color_xanh_it_dam,
              ),
            )),
      ],
    );
  }

  Row _buildRowGiaBan() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Bảng giá chung',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildFileGiaBan(),
        )
      ],
    );
  }

  Widget _buildFileGiaBan() {
    return TextFormField(
      textAlign: TextAlign.end,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onSaved: (newValue) {
        var va = newValue.toString().replaceAll(',', '');
        controller.hangHoaModel.value =
            controller.hangHoaModel.value.copyWith(donGiaBan: int.parse(va));
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          try {
            var va = newValue.text.toString().replaceAll(',', '');
            final int parsedValue = int.parse(va);
            // ignore: avoid_print
            print(parsedValue);
            if (parsedValue < 0) {
              print(controller.hangHoaModel.value.giaVon);
              // Thay đổi giá trị tối đa và tối thiểu ở đây

              return oldValue; // Giữ nguyên giá trị cũ nếu nằm ngoài khoảng
            }
          } catch (e) {
            // Xử lý ngoại lệ nếu có
          }
          return newValue; // Trả về giá trị mới nếu hợp lệ
        }),
      ],
      validator: (value) {
        // loại bỏ các dấu "," khỏi chuỗi
        var va = value.toString().replaceAll(',', '');
        // sao đó kiểm tra
        if ((va.isEmpty)) {
          return 'Vui lòng nhập giá bán';
        }
        if (int.tryParse(va) == null) {
          return 'Vui lòng nhập vào giá trị số';
        }
        if (int.parse(va) < 0) {
          return 'Giá trị phải lớn hơn hoặc bằng 0';
        }
        if (int.parse(va) < controller.hangHoaModel.value.giaVon!) {
          print(controller.hangHoaModel.value.giaVon);
          // Thay đổi giá trị tối đa và tối thiểu ở đây
          GetShowSnackBar.warningSnackBar(
              'Giá bán phải lớn hơn giá vốn nhập vào');
          return 'Giá bán phải lớn hơn giá vốn nhập vào';
        }
        return null;
      },
      controller: controller.giaBanController,
      // style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: '0',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          controller.giaBanController.text = '0';
        }
        if (int.tryParse(value) != null) {
          //  print(FunctionHelper.formNum(value));
          controller.giaBanController.text = FunctionHelper.formNum(value);
        }
        //controller.text = FunctionHelper.formNum(value);
      },
      onEditingComplete: () {
        //  print('gọi complete');
        controller.giaBanController.text =
            controller.giaBanController.text.replaceAll(',', '');

        if (double.tryParse(controller.giaBanController.text) == null) {
          print('giá trị null');
          controller.giaBanController.text = '0';
        } else {
          controller.giaBanController.text =
              FunctionHelper.formNum(controller.giaBanController.text);
        }
      },
    );
  }
}
