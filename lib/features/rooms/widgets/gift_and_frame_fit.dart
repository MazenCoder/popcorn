import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:popcorn/core/controllers/utils/utils_logic.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:popcorn/core/theme/generateMaterialColor.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/usecases/constants.dart';



class GiftAndFrameFit extends StatefulWidget {
  const GiftAndFrameFit({Key? key}) : super(key: key);

  @override
  State<GiftAndFrameFit> createState() => _GiftAndFrameFitState();
}

class _GiftAndFrameFitState extends State<GiftAndFrameFit> {

  final List<bool> _selectionsType = List.generate(2, (_)=> false);
  final List<bool> _selectionsNbr = List.generate(2, (_)=> false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height/2,
      width: Get.width,
      child: GetBuilder<UtilsLogic>(
        builder: (logic) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  child: Row(
                    children: [
                      Text('gifts_week'.tr),
                      const SizedBox(width: 8.0),
                      SvgPicture.asset(
                        IMG.giftChatSvg,
                        width: 25, height: 25,
                      ),
                    ],
                  ),
                ),
                TabBar(
                  tabs: [
                    Text("gifts".tr),
                    Text("frames".tr),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(6),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2,
                                  ),
                                  itemCount: logic.state.gifts.length,
                                  itemBuilder: (context, index) {
                                    final gift = logic.state.gifts[index];
                                    return InkWell(
                                        onTap: () {
                                          logic.state.id.value = gift.id;
                                        },
                                        child: Obx(() {
                                          return Container(
                                            margin: const EdgeInsets.all(4),
                                            padding: const EdgeInsets.all(4),
                                            decoration: (logic.state.id.value == gift.id) ?
                                            BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: primaryColor,
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                            ) : null,
                                            child: ShakeAnimatedWidget(
                                              enabled: (logic.state.id.value == gift.id),
                                              duration: const Duration(milliseconds: 1600),
                                              shakeAngle: Rotation.deg(z: 30),
                                              child: CachedNetworkImage(
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.contain,
                                                imageUrl: gift.image,
                                                placeholder: (context, url) => const Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url, error) => Center(
                                                  child: Icon(Icons.info_outline,
                                                    color: errorColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                    );
                                  },
                                  // children: logic.state.gifts.map((gift) {
                                  //   return InkWell(
                                  //       onTap: () {
                                  //         logic.state.id.value = gift.id;
                                  //       },
                                  //       child: Obx(() {
                                  //         return Container(
                                  //           margin: const EdgeInsets.all(4),
                                  //           padding: const EdgeInsets.all(4),
                                  //           decoration: (logic.state.id.value == gift.id) ?
                                  //           BoxDecoration(
                                  //             border: Border.all(
                                  //               width: 1,
                                  //               color: primaryColor,
                                  //             ),
                                  //             borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                  //           ) : null,
                                  //           child: ShakeAnimatedWidget(
                                  //             enabled: (logic.state.id.value == gift.id),
                                  //             duration: const Duration(milliseconds: 1600),
                                  //             shakeAngle: Rotation.deg(z: 30),
                                  //             child: CachedNetworkImage(
                                  //               width: 60,
                                  //               height: 60,
                                  //               fit: BoxFit.contain,
                                  //               imageUrl: gift.image,
                                  //               placeholder: (context, url) => const Center(
                                  //                 child: CircularProgressIndicator(),
                                  //               ),
                                  //               errorWidget: (context, url, error) => Center(
                                  //                 child: Icon(Icons.info_outline,
                                  //                   color: errorColor,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         );
                                  //       })
                                  //   );
                                  // }).toList(),
                                ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: GridView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                ),
                                itemCount: logic.state.frames.length,
                                itemBuilder: (context, index) {
                                  final frame = logic.state.frames[index];
                                  return InkWell(
                                      onTap: () {
                                        logic.state.id.value = frame.id;
                                      },
                                      child: Obx(() {
                                        return Container(
                                          margin: const EdgeInsets.all(4),
                                          padding: const EdgeInsets.all(4),
                                          decoration: (logic.state.id.value == frame.id) ?
                                          BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: primaryColor,
                                            ),
                                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                          ) : null,
                                          child: ShakeAnimatedWidget(
                                            enabled: (logic.state.id.value == frame.id),
                                            duration: const Duration(milliseconds: 1600),
                                            shakeAngle: Rotation.deg(z: 30),
                                            child: CachedNetworkImage(
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.contain,
                                              imageUrl: frame.image,
                                              placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                              errorWidget: (context, url, error) => Center(
                                                child: Icon(Icons.info_outline,
                                                  color: errorColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ToggleButtons(
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                              constraints: const BoxConstraints(
                                minHeight: 30,
                              ),
                              // color: primaryColor,
                              borderColor: primaryColor,
                              focusColor: primaryColor,
                              fillColor: Colors.transparent,
                              selectedBorderColor: primaryColor,
                              // color: primaryColor,
                              isSelected: _selectionsType,
                              onPressed: (int? index) {
                                if (index != null) {
                                  setState(() {
                                    _selectionsType[index] = !_selectionsType[index];
                                  });
                                }
                              },
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(2),
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                                      ),
                                      child: const Icon(
                                        Icons.mic, size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text('everyoneOnMic'.tr,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: Colors.white
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Icons.home, size: 20),
                                ),
                              ],
                            ),
                            ToggleButtons(
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                              constraints: const BoxConstraints(
                                minHeight: 30,
                              ),
                              // color: primaryColor,
                              borderColor: primaryColor,
                              focusColor: primaryColor,
                              fillColor: Colors.transparent,
                              selectedBorderColor: primaryColor,
                              isSelected: _selectionsNbr,
                              onPressed: (int? index) {
                                if (index != null) {
                                  setState(() {
                                    _selectionsNbr[index] = !_selectionsNbr[index];
                                  });
                                }
                              },
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('  1  '),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    roomLogic.sendGift(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text('send'.tr,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
