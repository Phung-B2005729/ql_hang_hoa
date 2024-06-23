import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorDialogTryAgain extends StatelessWidget {
  const ErrorDialogTryAgain(
      {Key? key, this.onClose, required this.message, this.onRetry})
      : super(key: key);

  final Function? onClose;
  final Function? onRetry;
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
                  "assets/images/error.png",
                )),
            const SizedBox(height: 26),
            const Text("Thất bại",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 26),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 26),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 90, maxWidth: 100),
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      onClose?.call();
                    },
                    child: const Text(
                      "ĐÓNG",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 90, maxWidth: 100),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onRetry?.call();
                    },
                    child: const Text(
                      "Thử lại",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
