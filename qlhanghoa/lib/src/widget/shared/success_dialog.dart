import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key, required this.callback, required this.message})
      : super(key: key);

  final Function callback;
  final String message;

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
                  "assets/images/success.png",
                )),
            const SizedBox(height: 26),
            const Text("Thành công",
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
                child: const Text(
                  "ĐÓNG",
                  style: TextStyle(
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
