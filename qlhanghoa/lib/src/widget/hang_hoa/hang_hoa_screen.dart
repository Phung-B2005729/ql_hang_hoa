import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlhanghoa/src/controller/account/auth_controller.dart';
import 'package:qlhanghoa/src/controller/bottom_navigation_controller.dart';
import 'package:qlhanghoa/src/helper/template/app_theme.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';
import 'package:qlhanghoa/src/widget/hang_hoa/edit_create_hang_hoa/them_hang_hoa_screen.dart';

class HangHoaScreen extends StatelessWidget {
  final AuthController controller = Get.find();
  final BottomNavigationController bottomController = Get.find();

  HangHoaScreen({super.key});
  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
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
                  margin: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                      onPressed: () {
                        // chuyển trang nhập tìm kiếm
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 57, 57, 57),
                        size: 30,
                      )),
                )
              ],
              bottom: _buildBottomAppBar(),
            ),
          ),
        ),
      ),
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
        child: ListView.builder(
            padding: const EdgeInsets.only(left: 20, right: 20),
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorClass.color_thanh_ke)),
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
                      child: Image.asset(
                        'assets/logo/logo_xanh_vang_x2.png',
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
                                'Vinasake nhỏ',
                                style: AppTheme.lightTextTheme.bodyLarge,
                              ),
                              Text(
                                '70000',
                                style: AppTheme.lightTextTheme.bodyMedium,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SP00002',
                                style: AppTheme.lightTextTheme.displaySmall,
                              ),
                              Text(
                                '70000',
                                style: AppTheme.lightTextTheme.titleSmall,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // chuyển đến
          Get.to(() => ThemHangHoaScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSize _buildBottomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: Column(
          children: [
            const Divider(
              color: Color.fromARGB(255, 114, 114, 114),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'sl',
                          style: AppTheme.lightTextTheme.titleSmall,
                        ),
                        const Text(
                          ' hàng hoá - Tồn kho ',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '1200',
                          style: AppTheme.lightTextTheme.titleSmall,
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        'Chi nhánh ....',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 53, 53, 53),
                        ),
                      ),
                    ),
                  ],
                ),
                Text('Giá bán', style: AppTheme.lightTextTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
