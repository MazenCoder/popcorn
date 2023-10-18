import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/util/img.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';




class CardRoomShimmer extends StatelessWidget {
  const CardRoomShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor.shade800,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: primaryColor.shade200,
        enabled: true,
        child: Row(
          children: [
            imageCardRoom(null),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width/3.3,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: Get.width/2,
                      height: 32,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Lottie.asset(IMG.jsonWave, width: 25, height: 25),
                Icon(MdiIcons.account, color: primaryColor),
              ],
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
