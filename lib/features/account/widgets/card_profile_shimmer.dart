import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';



class CardProfileShimmer extends StatelessWidget {
  const CardProfileShimmer({Key? key}) : super(key: key);

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
              child: Shimmer.fromColors(
                highlightColor: primaryColor.shade200,
                baseColor: Colors.grey.shade200,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: chatCircleAvatar(null, 50),
                ),
              ),
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
                Shimmer.fromColors(
                  highlightColor: primaryColor.shade200,
                  baseColor: Colors.grey.shade200,
                  child: Container(
                    width: Get.width /2,
                    color: Colors.white,
                    height: 8.0,
                  ),
                ),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                  highlightColor: primaryColor.shade200,
                  baseColor: Colors.grey.shade200,
                  child: Container(
                    width: Get.width /3,
                    color: Colors.white,
                    height: 8.0,
                  ),
                ),
                Expanded(child: Container()),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    //! Send Gifts
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Shimmer.fromColors(
                            highlightColor: primaryColor.shade200,
                            baseColor: Colors.grey.shade200,
                            child: Container(
                              color: Colors.white,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Shimmer.fromColors(
                          highlightColor: primaryColor.shade200,
                          baseColor: Colors.grey.shade200,
                          child: Container(
                            color: Colors.white,
                            width: 40,
                            height: 8.0,
                          ),
                        ),
                      ],
                    ),

                    //! Magic card
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Shimmer.fromColors(
                            highlightColor: primaryColor.shade200,
                            baseColor: Colors.grey.shade200,
                            child: Container(
                              color: Colors.white,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Shimmer.fromColors(
                          highlightColor: primaryColor.shade200,
                          baseColor: Colors.grey.shade200,
                          child: Container(
                            color: Colors.white,
                            width: 40,
                            height: 8.0,
                          ),
                        ),
                      ],
                    ),

                    //! Mute mic
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Shimmer.fromColors(
                            highlightColor: primaryColor.shade200,
                            baseColor: Colors.grey.shade200,
                            child: Container(
                              color: Colors.white,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Shimmer.fromColors(
                          highlightColor: primaryColor.shade200,
                          baseColor: Colors.grey.shade200,
                          child: Container(
                            color: Colors.white,
                            width: 40,
                            height: 8.0,
                          ),
                        ),
                      ],
                    ),

                    //! Add Friend
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Shimmer.fromColors(
                            highlightColor: primaryColor.shade200,
                            baseColor: Colors.grey.shade200,
                            child: Container(
                              color: Colors.white,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Shimmer.fromColors(
                          highlightColor: primaryColor.shade200,
                          baseColor: Colors.grey.shade200,
                          child: Container(
                            color: Colors.white,
                            width: 40,
                            height: 8.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
