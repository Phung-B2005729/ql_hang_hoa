// ignore_for_file: unused_element, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/nhap_lo_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';

import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class ThemLoScreen extends GetView<NhapLoController> {
  const ThemLoScreen({super.key, this.themMoi});
  final bool? themMoi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        // ignore: unnecessary_null_comparison
        () => controller.chiTietPhieuNhap.value.hangHoa != null
            ? SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, bottom: 10, right: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    ColorClass.color_thanh_ke.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(3, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildTonKho(),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                color: ColorClass.color_thanh_ke,
                              ),
                              _buildRowSoLo(),
                              GetBuilder<NhapLoController>(
                                builder: (controller) =>
                                    // ignore: unnecessary_null_comparison
                                    (controller.filteredList != null &&
                                            // ignore: prefer_is_empty
                                            controller.filteredList.length >
                                                0 &&
                                            controller.chonLo.value != true)
                                        ? const SizedBox()
                                        : const SizedBox(
                                            height: 20,
                                          ),
                              ),

                              // thêm gợi ý ở đây
                              GetBuilder<NhapLoController>(
                                  builder: (controller) =>
                                      // ignore: unnecessary_null_comparison
                                      (controller.filteredList != null &&
                                              // ignore: prefer_is_empty
                                              controller.filteredList.length >
                                                  0 &&
                                              controller.chonLo.value != true)
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, left: 60),
                                              padding: const EdgeInsets.only(
                                                  left: 25,
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 15),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 243, 243, 243),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color.fromARGB(
                                                            255, 255, 255, 255)
                                                        .withOpacity(0.2),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(3, 0),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  for (var lo in controller
                                                      .filteredList)
                                                    GestureDetector(
                                                      onTap: () {
                                                        // set lô hàng
                                                        print('gọi lô');
                                                        controller
                                                            .setUpDataThemLo(
                                                                lo);
                                                        controller
                                                            .changeChonLo(true);
                                                      },
                                                      child: Container(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  lo.soLo!,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: ColorClass
                                                                          .color_cancel),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Divider(
                                                                color: ColorClass
                                                                    .color_thanh_ke,
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            )
                                          : _buildHanSuDung(context)),
                              GetBuilder<NhapLoController>(
                                  builder: (controller) =>
                                      // ignore: unnecessary_null_comparison
                                      (controller.filteredList != null &&
                                              // ignore: prefer_is_empty
                                              controller.filteredList.length >
                                                  0 &&
                                              controller.chonLo.value != true)
                                          ? const SizedBox()
                                          : const SizedBox(
                                              height: 10,
                                            )),
                              GetBuilder<NhapLoController>(
                                  builder: (controller) =>
                                      // ignore: unnecessary_null_comparison
                                      (controller.filteredList != null &&
                                              // ignore: prefer_is_empty
                                              controller.filteredList.length >
                                                  0 &&
                                              controller.chonLo.value != true)
                                          ? const SizedBox()
                                          : const Divider(
                                              color: ColorClass.color_thanh_ke,
                                            )),

                              GetBuilder<NhapLoController>(
                                  builder: (controller) =>
                                      // ignore: unnecessary_null_comparison
                                      (controller.filteredList != null &&
                                              // ignore: prefer_is_empty
                                              controller.filteredList.length >
                                                  0 &&
                                              controller.chonLo.value != true)
                                          ? const SizedBox()
                                          : _buildSoLuong()),
                              GetBuilder<NhapLoController>(
                                  builder: (controller) =>
                                      // ignore: unnecessary_null_comparison
                                      (controller.filteredList != null &&
                                              // ignore: prefer_is_empty
                                              controller.filteredList.length >
                                                  0 &&
                                              controller.chonLo.value != true)
                                          ? const SizedBox()
                                          : const SizedBox(
                                              height: 10,
                                            )),
                              GetBuilder<NhapLoController>(
                                  builder: (controller) =>
                                      // ignore: unnecessary_null_comparison
                                      (controller.filteredList != null &&
                                              // ignore: prefer_is_empty
                                              controller.filteredList.length >
                                                  0 &&
                                              controller.chonLo.value != true)
                                          ? const SizedBox()
                                          : const Divider(
                                              color: ColorClass.color_thanh_ke,
                                            )),
                            ],
                          )),
                      (themMoi != null && themMoi == true)
                          ? _builContainerDonGiaGiaGiam()
                          : const SizedBox(),
                      (themMoi != null && themMoi == true)
                          ? _builContainerThanhTien()
                          : const SizedBox(),
                      (themMoi != null && themMoi == true)
                          ? _buildContanerGhiChu()
                          : const SizedBox(),
                    ],
                  ),
                ),
              )
            : const LoadingCircularFullScreen(),
      ),
    );
  }

  Container _buildContanerGhiChu() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 25),
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
      child: _buildFileGhiChu(),
    );
  }

  Container _builContainerDonGiaGiaGiam() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      // padding: const EdgeInsets.only(left: 15, right: 20),
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
          padding: const EdgeInsets.only(bottom: 10, left: 15, right: 20),
          child: Column(
            children: [
              _buildRowDonGia(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, left: 15, right: 20),
          child: Column(
            children: [
              _buildRowGiaGiam(),
            ],
          ),
        ),
      ]),
    );
  }

  Container _builContainerThanhTien() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 15, right: 25, top: 20, bottom: 5),
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
      child: Column(
        children: [
          _buildRowThanhTien(),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: ColorClass.color_thanh_ke,
          )
        ],
      ),
    );
  }

  Widget _buildFileGhiChu() {
    return TextFormField(
      maxLines: null,
      minLines: 4,
      controller: controller.ghiChuController,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      onChanged: (value) {
        controller.chiTietPhieuNhap.value.ghiChu = value;
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorClass.color_button, width: 1.2),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: 'Ghi chú',
        hintStyle: const TextStyle(
          color: Color.fromARGB(43, 10, 4, 126),
          fontSize: 14,
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Row _buildRowThanhTien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Thành tiền',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800),
        ),
        GetBuilder<NhapLoController>(
          builder: (controller) => Text(
            FunctionHelper.formNum(
                ((controller.loHangModel.value.soLuongNhap ?? 0) *
                        (controller.chiTietPhieuNhap.value.donGiaNhap ?? 0)) -
                    (controller.chiTietPhieuNhap.value.giaGiam ?? 0)),
            style: const TextStyle(
                color: ColorClass.color_xanh_it_dam,
                fontSize: 15,
                fontWeight: FontWeight.w600),
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
          style: TextStyle(color: Colors.black, fontSize: 15),
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
      style: const TextStyle(color: Colors.black, fontSize: 15),
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
              print(controller.chiTietPhieuNhap.value.hangHoa!.giaVon);
              // Thay đổi giá trị tối đa và tối thiểu ở đây

              return oldValue; // Giữ nguyên giá trị cũ nếu nằm ngoài khoảng
            }
            print(controller.loHangModel.value.soLuongNhap! *
                controller.chiTietPhieuNhap.value.donGiaNhap!);
            if ((parsedValue >
                    (controller.loHangModel.value.soLuongNhap! *
                        controller.chiTietPhieuNhap.value.donGiaNhap!)) &&
                (controller.loHangModel.value.soLuongNhap! *
                            controller.chiTietPhieuNhap.value.donGiaNhap! -
                        controller.chiTietPhieuNhap.value.giaGiam!) >=
                    0) {
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

  Row _buildRowDonGia() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Đơn giá',
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        Expanded(child: _buildTextFormFileDonGia())
      ],
    );
  }

  TextFormField _buildTextFormFileDonGia() {
    return TextFormField(
      textAlign: TextAlign.end,
      style: const TextStyle(color: Colors.black, fontSize: 15),
      controller: controller.donGiaController,
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
              print(controller.chiTietPhieuNhap.value.hangHoa!.giaVon);
              // Thay đổi giá trị tối đa và tối thiểu ở đây
              if (parsedValue > 999999999)
                // ignore: curly_braces_in_flow_control_structures
                GetShowSnackBar.warningSnackBar(
                    'Đơn giá nhập không vượt quá 999,999,999');
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
          controller.donGiaController.text = '0';
          controller.changeGiaVon('0');
        }

        if (int.tryParse(value) != null) {
          //  print(FunctionHelper.formNum(value));

          controller.changeGiaVon(value);
          controller.donGiaController.text = FunctionHelper.formNum(value);
        }
      },
    );
  }

  Row _buildRowSoLo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Lô',
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        const SizedBox(
          width: 50,
        ),
        GetBuilder<NhapLoController>(
          builder: (controller) => (controller.chonLo.value != true)
              ? Expanded(child: _buildTextFormFileSoLo())
              : Row(
                  children: [
                    Text(controller.loHangModel.value.soLo.toString()),
                    GestureDetector(
                      onTap: () {
                        // loại bỏ lô hàng chỉ giữa lại số lượng nhập, trả textSoLo = '';
                        controller.loaiBoSoLo();
                      },
                      child: const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Center(
                              child: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 241, 241, 241),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
        )
      ],
    );
  }

  TextFormField _buildTextFormFileSoLo() {
    return TextFormField(
      textAlign: TextAlign.end,
      style: const TextStyle(color: Colors.black, fontSize: 15),
      controller: controller.soLoController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập vào số lô';
        }

        return null;
      },
      onChanged: (value) {
        controller.loHangModel.value =
            controller.loHangModel.value.copyWith(soLo: value);
      },
      onEditingComplete: () {
        controller.filteredList();
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
        hintText: 'Số lô',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
    );
  }

  Widget _buildTonKho() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tồn kho',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        Text(
          FunctionHelper.formNum(controller.tongTonKho().toString()),
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _buildHanSuDung(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Hạn Sử dụng',
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),

        // text thêm hạn sử dụng
        Expanded(
          child: GetBuilder<NhapLoController>(
            builder: (ontroller) => GestureDetector(
              onTap: () async {
                // mở nhập ngày
                if (controller.chonLo.value != true) {
                  await _selectDate(controller, context, true);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (controller.loHangModel.value.hanSuDung != '' &&
                          controller.loHangModel.value.hanSuDung != null)
                      ? Text(
                          FunctionHelper.formatDateVNStringVN(controller
                              .loHangModel.value.hanSuDung
                              .toString()),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        )
                      : const Text(
                          'Hạn sử dụng',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 116, 116, 116)),
                        ),
                  const SizedBox(
                    width: 5,
                  ),
                  (controller.chonLo.value != true)
                      ? const Icon(Icons.event)
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
      NhapLoController controller, BuildContext context, bool BatDau) async {
    final DateTime seleted = controller.loHangModel.value.hanSuDung != null &&
            controller.loHangModel.value.hanSuDung != ''
        ? // ngày đưa vào khách rỗng
        (FunctionHelper.getDateTimeVnFormStringVN(
            controller.loHangModel.value.hanSuDung!))
        : DateTime.now(); // lấy thời gian ngày hôm nay
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
      // kiểm tra nhỏ hơn ngày hiện tại
      DateTime today = DateTime.now();
      DateTime currentDate = DateTime(today.year, today.month, today.day);
      if (pickedDate.isAfter(currentDate) ||
          pickedDate.isAtSameMomentAs(currentDate)) {
        // If picked date is today or in the future, update the value
        controller.setHanSuDung(pickedDate);
      } else {
        // Handle the case where the picked date is in the past
        // For example, show an error message or a notification
        GetShowSnackBar.warningSnackBar(
            'Hạn sử dụng phải lớn hơn hoặc bằng ngày hiện tại');
      }
    }
  }

  Widget _buildSoLuong() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text(
        'Số lượng nhập',
        style: TextStyle(color: Colors.black, fontSize: 15),
      ),
      const SizedBox(
        width: 50,
      ),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                // giảm số lượng
                print('gọi giảm số lượng');
                controller.giamSoLuongLoHang(-1);
              },
              icon: const Icon(
                Icons.remove,
                color: Color.fromARGB(255, 47, 47, 47),
              ),
            ),
            Expanded(
              child: GetBuilder<NhapLoController>(
                builder: (controller) => TextFormField(
                  textAlign: TextAlign.center,
                  controller: controller.soLuongController,
                  onSaved: (newValue) {},
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9.]'),
                    ),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      try {
                        //   var va = newValue.text.toString().replaceAll(',', '');
                        final double parsedValue = double.parse(newValue.text);
                        // ignore: avoid_print
                        print(parsedValue);
                        if (parsedValue < 0 || parsedValue > 999999999) {
                          print(controller
                              .chiTietPhieuNhap.value.hangHoa!.giaVon);
                          // Thay đổi giá trị tối đa và tối thiểu ở đây
                          if (parsedValue > 999999999)
                            // ignore: curly_braces_in_flow_control_structures
                            GetShowSnackBar.warningSnackBar(
                                'Số lượng nhập không vượt quá 999,999,999');
                          return oldValue; // Giữ nguyên giá trị cũ nếu nằm ngoài khoảng
                        }
                      } catch (e) {
                        // Xử lý ngoại lệ nếu có
                      }
                      return newValue; // Trả về giá trị mới nếu hợp lệ
                    }),
                  ],
                  validator: (value) {
                    var va = value?.replaceAll(',', '') ?? '';
                    if (va.isEmpty) {
                      return 'Vui lòng nhập số lượng nhập';
                    }
                    if (double.tryParse(va) == null) {
                      return 'Vui lòng nhập vào giá trị số';
                    }
                    if (double.parse(va) < 0) {
                      return 'Giá trị phải lớn hơn hoặc bằng 0';
                    }
                    return null;
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    errorStyle: TextStyle(fontSize: 12),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorClass.color_button,
                        width: 1.2,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(43, 10, 4, 126),
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.soLuongController.text = '0';
                      controller.changeSoLuongLo(index: -1, soLuong: '0');
                    }
                    int count = value.split('.').length - 1;
                    print('đếm');
                    print(count);
                    if (count > 1) {
                      value = value.substring(0, value.length - 1).toString();
                    }

                    if (double.tryParse(value) != null &&
                        !value.endsWith('.')) {
                      print('gọi');
                      controller.changeSoLuongLo(index: -1, soLuong: value);
                      controller.soLuongController.text =
                          FunctionHelper.formNum(value);
                    }
                  },
                  onEditingComplete: () {
                    controller.changeSoLuongLo(
                        index: -1, soLuong: controller.soLuongController.text);
                    controller.soLuongController.text = FunctionHelper.formNum(
                        controller.soLuongController.text);
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // thêm số lượng

                controller.tangSoLuongLoHang(-1);
              },
              icon: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 47, 47, 47),
              ),
            ),
          ],
        ),
      ),
      const Divider(color: ColorClass.color_thanh_ke),
    ]);
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 3,
      title: Text(
        // ignore: unnecessary_null_comparison
        (controller.chiTietPhieuNhap.value.hangHoa != null &&
                controller.chiTietPhieuNhap.value.hangHoa!.tenHangHoa != null)
            ? 'Nhập lô (${controller.chiTietPhieuNhap.value.hangHoa!.tenHangHoa})'
            : 'Nhập lô',
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
          onPressed: () {
            // trả reSet data thêm lô và trở về trang trước
            if (themMoi != null && themMoi == true) {
              // reset lại tất cả
              controller.reSetDataThemLo(reSetThemMoi: true);
              controller.reSetData();
            } else {
              controller.reSetDataThemLo();
            }
            Get.back();
          },
          icon: const Icon(
            Icons.close,
            color: ColorClass.color_outline_icon,
            size: 26,
          )),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: TextButton(
              onPressed: () async {
                // tiến hành thm hoặc update chi tiết lô
                if ((controller.loHangModel.value.soLo == null ||
                        controller.loHangModel.value.soLo == '') &&
                    (controller.loHangModel.value.hanSuDung == null ||
                        controller.loHangModel.value.hanSuDung == '')) {
                  GetShowSnackBar.errorSnackBar(
                      'Bạn chưa nhập vào số lô và hạn sử dụng');
                } else if (controller.loHangModel.value.soLo == null ||
                    controller.loHangModel.value.soLo == '') {
                  GetShowSnackBar.errorSnackBar('Bạn chưa nhập số lô');
                } else if (controller.loHangModel.value.hanSuDung == null ||
                    controller.loHangModel.value.hanSuDung == '') {
                  GetShowSnackBar.errorSnackBar(
                      'Bạn chưa nhập vào hạn sử dụng');
                } else {
                  print('gọi save update lại lô');
                  controller.addUpdateLoHang(controller.loHangModel.value);
                  await controller.saveChiTiet();
                  Get.back();
                  if (themMoi != null && themMoi == true) {
                    print('gọi get backend');
                    Get.back();
                  }
                }
              },
              child: const Text(
                'Xong',
                style: TextStyle(
                  fontSize: 18,
                  color: ColorClass.color_xanh_it_dam,
                ),
              )),
        )
      ],
    );
  }

  // lô
}
