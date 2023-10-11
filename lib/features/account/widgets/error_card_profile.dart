import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';




class ErrorCardProfile extends StatelessWidget {
  final String? message;
  const ErrorCardProfile({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  width: Get.width,
                  color: Colors.transparent,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                  ),
                  width: Get.width,
                  height: 60,
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: chatCircleAvatar(null, 50),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: primaryColor,
            width: Get.width,
            child: Column(
              children: [
                Text(message ?? 'user_not_found2'.tr,
                  style: context.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Expanded(
                  child: Lottie.asset(
                    IMG.jsonError,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
