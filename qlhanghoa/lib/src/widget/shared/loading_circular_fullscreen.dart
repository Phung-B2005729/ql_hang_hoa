import 'package:flutter/material.dart';
import 'package:qlhanghoa/src/helper/template/color.dart';

class LoadingCircularFullScreen extends StatelessWidget {
  const LoadingCircularFullScreen({
    Key? key,
    this.backgroundColor,
    this.title,
  }) : super(key: key);

  final Color? backgroundColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: ColorClass.color_button_nhat,
            ),
            const SizedBox(height: 30),
            Text(
              // ignore: prefer_interpolation_to_compose_strings
              (title ?? "Đang xử lý") + "...",
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
