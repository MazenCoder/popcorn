import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/constants.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/util/img.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'card_footer_icon.dart';
import 'package:get/get.dart';




class CardShimmer extends StatelessWidget {
  const CardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _enabled = true;
    return Card(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        // highlightColor: Colors.grey.shade100,
        highlightColor: primaryColor.shade200,
        enabled: _enabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50,
              width: Get.width,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  chatCircleAvatar(null, 22),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Container(
                        width: Get.width/3,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),

                      // Container(
                      //   width: Get.width/2,
                      //   color: Colors.white,
                      //   height: 16,
                      // ),

                      // Container(
                      //   width: Get.width/2,
                      //   color: Colors.white,
                      //   height: 11,
                      // ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Container(
                            width: Get.width/3,
                            color: Colors.white,
                            height: 11,
                          ),

                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 2,
                            width: 4,
                          ),
                          Container(
                            width: Get.width/3,
                            color: Colors.white,
                            height: 11,
                          ),
                        ],
                      )
                    ],
                  ),
                  const Expanded(child: SizedBox()),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  IMG.defaultImg,
                  height: Get.height/2.2,
                  width: Get.width,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Container(
              width: Get.width,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  //! Like
                  LikeButton(
                    size: 20,
                    onTap: (v) async {},
                    // likeCount: _mobxApp.likeCount,
                    // isLiked: _mobxApp.isLiked,
                    // circleColor: CircleColor(
                      // start: blueAccentColor,
                      // end: primaryColor,
                    // ),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: primaryColor,
                      dotSecondaryColor: primaryColor,
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        MdiIcons.thumbUpOutline,
                        color: isLiked ? primaryColor : Colors.black54,
                        size: 20,
                      );
                    },
                    countBuilder: (int? count, bool isLiked, String text) {
                      var color = isLiked ? primaryColor : Colors.black54;
                      Widget result;
                      if (count == 0) {
                        result = Text(
                          'like'.tr,
                          style: TextStyle(color: color),
                        );
                      } else {
                        result = Text(
                          text,
                          style: TextStyle(color: color),
                        );
                      }
                      return result;
                    },
                  ),


                  //! Comment
                  AbsorbPointer(
                    absorbing: true,
                    child: LikeButton(
                      size: 20,
                      // circleColor: CircleColor(
                        // start: blueAccentColor,
                        // end: primaryColor,
                      // ),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: primaryColor,
                        dotSecondaryColor: primaryColor,
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          MdiIcons.commentProcessingOutline,
                          color: isLiked ? primaryColor : Colors.black54,
                          size: 20,
                        );
                      },
                      countBuilder: (int? count, bool isLiked, String text) {
                        var color = isLiked ? primaryColor : Colors.black54;
                        Widget result;
                        if (count == 0) {
                          result = Text(
                            'comment'.tr,
                            style: TextStyle(color: color),
                          );
                        } else {
                          result = Text(
                            text,
                            style: TextStyle(color: color),
                          );
                        }
                        return result;
                      },
                    ),
                  ),

                  //! Share
                  CardFooterIcon(
                    text: 'share'.tr,
                    icon: const Icon(
                      MdiIcons.shareOutline,
                      color: Colors.black54,
                      size: 20,
                    ),
                    onTap: () {},
                  ),

                  IconButton(
                    icon: const Icon(MdiIcons.dotsHorizontal),
                    onPressed: () {},
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
    /*
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Shimmer.fromColors(
            highlightColor: primaryColor.shade200,
            baseColor: Colors.grey.shade200,
            child: SizedBox(
              height: 50,
              width: Get.width,
            ),
          ),


          Shimmer.fromColors(
            highlightColor: primaryColor.shade200,
            baseColor: Colors.grey.shade200,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: Get.width,
              height: 50,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: Get.height/2.2,
            width: Get.width,
            child: Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              child: Container(
                height: Get.height/2.2,
                width: Get.width,
                child: Text('ksdjflk;s'),
              ),
            ),
          ),


          Shimmer.fromColors(
            highlightColor: primaryColor.shade200,
            baseColor: Colors.grey.shade200,
            child: SizedBox(
              width: Get.width,
              height: 45,
            ),
          ),
        ],
      ),
    );

     */
  }
}
