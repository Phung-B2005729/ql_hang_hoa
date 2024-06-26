// ignore_for_file: unused_element, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/nhap_hang/them_phieu_nhap/nhap_lo_controller.dart';
import 'package:qlhanghoa/src/helper/function_helper.dart';

import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/nhap_hang/them_phieu_nhap/nhap_lo_screen.dart';

import 'package:qlhanghoa/src/widget/shared/loading_circular_fullscreen.dart';
import 'package:qlhanghoa/src/widget/shared/show_snack_bar.dart';

// ignore: must_be_immutable
class NhapHangTheoTungHangHoa extends GetView<NhapLoController> {
  const NhapHangTheoTungHangHoa({super.key, this.chuyenTuTimKiem});
  final bool? chuyenTuTimKiem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        // ignore: unnecessary_null_comparison
        () => controller.chiTietPhieuNhap.value.hangHoa != null
            ? SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.only(left: 10),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: (controller.chiTietPhieuNhap.value
                                                .hangHoa!.hinhAnh !=
                                            null &&
                                        controller.chiTietPhieuNhap.value
                                            .hangHoa!.hinhAnh!.isNotEmpty)
                                    ? Image.network(
                                        controller.chiTietPhieuNhap.value
                                            .hangHoa!.hinhAnh![0].linkAnh!,
                                        fit: BoxFit.contain,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                              'assets/images/hang_hoa_mac_dinh.png',
                                              fit: BoxFit.contain);
                                        },
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: const Color.fromARGB(
                                                    255, 185, 185, 185),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GetBuilder<NhapLoController>(
                                      builder: (controller) => Text(
                                        controller.chiTietPhieuNhap.value
                                                .hangHoa!.tenHangHoa ??
                                            '',
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.black,

                                            // fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                    ),
                                    GetBuilder<NhapLoController>(
                                      builder: (controller) => Text(
                                        controller.chiTietPhieuNhap.value
                                                .hangHoa!.donViTinh ??
                                            ''.toString(),
                                        style: const TextStyle(
                                            color: ColorClass.color_cancel,
                                            // fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      GetBuilder<NhapLoController>(
                        builder: (controller) =>
                            (controller.chiTietPhieuNhap.value.hangHoa !=
                                        null &&
                                    controller.chiTietPhieuNhap.value.hangHoa!
                                            .quanLyTheoLo !=
                                        null &&
                                    controller.chiTietPhieuNhap.value.hangHoa!
                                            .quanLyTheoLo ==
                                        true)
                                ? _buildContainerNhapTungLo()
                                : _buildContainerNhapKhongTheoLo(),
                      ),
                      _builContainerThanhTien(),
                      _buildContanerGhiChu(),
                    ],
                  ),
                ),
              )
            : const LoadingCircularFullScreen(),
      ),
    );
  }

  Widget _buildContainerNhapTungLo() {
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
        child: Column(
          children: [
            _buildSoLuongNhap(),
            _BuildLoHang(),
            ListTile(
              onTap: () {
                // chuyển giao diện thêm lô
                // setUpDate cho thêm lô
                controller.reSetDataThemLo();
                controller.setUpControllerThemLo();
                Get.to(() => const ThemLoScreen(
                      themMoi: false,
                    ));
              },
              minLeadingWidth: 0,
              title: const Text(
                'Thêm lô',
                style: TextStyle(
                    color: Color.fromARGB(214, 62, 62, 62), fontSize: 16),
              ),
              leading: const Icon(
                Icons.add_circle_outline_rounded,
                color: ColorClass.color_button_nhat,
              ),
            )
          ],
        ));
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

  Container _builContainerThanhTien() {
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
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 20),
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              _buildTonKho(),
              const SizedBox(
                height: 5,
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
        Container(
          padding:
              const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 20),
          margin: const EdgeInsets.only(bottom: 15),
          child: Column(
            children: [
              _buildRowThanhTien(),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: ColorClass.color_thanh_ke,
              )
            ],
          ),
        ),
      ]),
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
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        GetBuilder<NhapLoController>(
          builder: (controller) => Text(
            FunctionHelper.formNum((controller.chiTietPhieuNhap.value.soLuong! *
                    controller.chiTietPhieuNhap.value.donGiaNhap!) -
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
            if (parsedValue >
                    (controller.chiTietPhieuNhap.value.soLuong! *
                        controller.chiTietPhieuNhap.value.donGiaNhap!) &&
                (controller.chiTietPhieuNhap.value.soLuong! *
                            controller.chiTietPhieuNhap.value.donGiaNhap! -
                        controller.chiTietPhieuNhap.value.giaGiam!) >=
                    0) {
              // ignore: curly_braces_in_flow_control_structures
              GetShowSnackBar.warningSnackBar(
                  'Giá giảm nhập không vượt quá thành tiền');
              return oldValue;
            } // Giữ nguyên giá trị cũ nếu nằm ngoài khoảng
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

  Widget _buildTonKho() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tồn kho',
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        Text(
          FunctionHelper.formNum(controller.tongTonKho().toString()),
          style: const TextStyle(color: Colors.black, fontSize: 15),
        )
      ],
    );
  }

  Container _buildSoLuongNhap() {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 20),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Số lượng nhập',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              GetBuilder<NhapLoController>(
                builder: (controller) => Text(
                  FunctionHelper.formNum(
                      controller.chiTietPhieuNhap.value.soLuong ?? '0'),
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            color: ColorClass.color_thanh_ke,
          )
        ],
      ),
    );
  }

  GetBuilder<NhapLoController> _BuildLoHang() {
    return GetBuilder<NhapLoController>(
      builder: (controller) {
        var loNhap = controller.chiTietPhieuNhap.value.loNhap;
        if (loNhap == null || loNhap.isEmpty) {
          return const SizedBox();
        }

        return Column(
          children: List.generate(loNhap.length, (index) {
            var chiTiet = loNhap[index];
            //   var textController = controller.textEditingControllers[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    // gọi xoá lô
                  },
                  icon: const Icon(
                    Icons.do_not_disturb_on_outlined,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                              color: ColorClass.color_button_nhat,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                            ),
                            child: const Center(
                              child: Text(
                                'Lô',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            chiTiet.soLo.toString(),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                'HSD : ${FunctionHelper.formatDateString(chiTiet.hanSuDung.toString())}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // giảm số lượng
                                    controller.giamSoLuongLoHang(index);
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Color.fromARGB(255, 47, 47, 47),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    // initialValue: '2',
                                    controller: controller
                                        .textEditingControllers[index],
                                    onSaved: (newValue) {},
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]'),
                                      ),
                                      TextInputFormatter.withFunction(
                                          (oldValue, newValue) {
                                        try {
                                          //   var va = newValue.text.toString().replaceAll(',', '');
                                          final double parsedValue =
                                              double.parse(newValue.text);
                                          // ignore: avoid_print
                                          print(parsedValue);
                                          if (parsedValue < 0 ||
                                              parsedValue > 999999999) {
                                            print(controller.chiTietPhieuNhap
                                                .value.hangHoa!.giaVon);
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
                                        controller.textEditingControllers[index]
                                            .text = '0';
                                        controller.changeSoLuongLo(
                                            index: index, soLuong: '0');
                                      }
                                      int count = value.split('.').length - 1;
                                      print('đếm');
                                      print(count);
                                      if (count > 1) {
                                        value = value
                                            .substring(0, value.length - 1)
                                            .toString();
                                      }

                                      if (double.tryParse(value) != null &&
                                          !value.endsWith('.')) {
                                        print('gọi');
                                        controller.changeSoLuongLo(
                                            index: index, soLuong: value);
                                        controller.textEditingControllers[index]
                                                .text =
                                            FunctionHelper.formNum(value);
                                      }
                                    },
                                    onEditingComplete: () {
                                      controller.changeSoLuongLo(
                                          index: index,
                                          soLuong: controller
                                              .textEditingControllers[index]
                                              .text);
                                      controller.textEditingControllers[index]
                                              .text =
                                          FunctionHelper.formNum(controller
                                              .textEditingControllers[index]
                                              .text);
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // thêm số lượng
                                    controller.tangSoLuongLoHang(index);
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color.fromARGB(255, 47, 47, 47),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: ColorClass.color_thanh_ke),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildContainerNhapKhongTheoLo() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
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
            _buildSoLuong(),
          ],
        ));
  }

  Container _buildSoLuong() {
    return Container(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 20),
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Số lượng nhập',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          // giảm số lượng
                          controller.giamSoLuongHang();
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
                            controller: controller.soLuongNhapController,
                            onSaved: (newValue) {},
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                try {
                                  //   var va = newValue.text.toString().replaceAll(',', '');
                                  final double parsedValue =
                                      double.parse(newValue.text);
                                  // ignore: avoid_print
                                  print(parsedValue);
                                  if (parsedValue < 0 ||
                                      parsedValue > 999999999) {
                                    print(controller.chiTietPhieuNhap.value
                                        .hangHoa!.giaVon);
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
                                controller.soLuongNhapController.text = '0';
                                controller.changeSoLuong('0');
                              }
                              int count = value.split('.').length - 1;
                              print('đếm');
                              print(count);
                              if (count > 1) {
                                value = value
                                    .substring(0, value.length - 1)
                                    .toString();
                              }
                              if (double.tryParse(value) != null &&
                                  !value.endsWith('.')) {
                                print('gọi');
                                controller.changeSoLuong(value);
                                controller.soLuongNhapController.text =
                                    FunctionHelper.formNum(value);
                              }
                            },
                            onEditingComplete: () {
                              controller.changeSoLuong(
                                  controller.soLuongNhapController.text);
                              controller.soLuongNhapController.text =
                                  FunctionHelper.formNum(
                                      controller.soLuongNhapController.text);
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // thêm số lượng

                          controller.tangSoLuongHang();
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
              ],
            ),
            const Divider(
              color: ColorClass.color_thanh_ke,
            )
          ],
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
        titleSpacing: 3,
        title: GetBuilder<NhapLoController>(
          builder: (controller) => Text(
            // ignore: unnecessary_null_comparison
            (controller.chiTietPhieuNhap.value.hangHoa != null &&
                    controller.chiTietPhieuNhap.value.hangHoa!.maHangHoa !=
                        null)
                ? controller.chiTietPhieuNhap.value.hangHoa!.maHangHoa
                    .toString()
                : '',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              // chuyển về trang them hang hoa
              controller.reSetData();
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
                // ignore: avoid_print
                print(
                    'gọi save update lại chi tiết nhập hàng + giá vốn của hàng hoá');
                await controller.saveChiTiet();
                Get.back();
                if (chuyenTuTimKiem != null && chuyenTuTimKiem == true)
                  Get.back();
              },
              child: const Text(
                'Xong',
                style: TextStyle(
                  fontSize: 18,
                  color: ColorClass.color_xanh_it_dam,
                ),
              )),
        ]);
  }

  // lô
}
