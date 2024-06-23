import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ErrorDialog extends StatelessWidget {
  ErrorDialog(
      {Key? key, required this.callback, required this.message, this.taiLai})
      : super(key: key);

  final Function callback;
  final String message;
  bool? taiLai;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
                widthFactor: 0.6,
                child: Image.asset(
                  "assets/images/error.png",
                )),
            const SizedBox(height: 26),
            const Text("Thất bại",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 26),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 26),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 120),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  callback();
                },
                child: Text(
                  (taiLai == true) ? 'Thử lại' : "ĐÓNG",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
