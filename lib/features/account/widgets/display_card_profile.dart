import 'package:popcorn/packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/controllers/user/user_logic.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../rooms/widgets/full_screen_image.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../chat/pages/chat_screen_page.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/user_model.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'report_block_fit.dart';
import 'package:get/get.dart';
import 'dart:developer';



class DisplayCardProfile extends StatefulWidget {
  final UserModel user;
  const DisplayCardProfile({
    Key? key, required this.user,
  }) : super(key: key);

  @override
  State<DisplayCardProfile> createState() => _DisplayCardProfileState();
}

class _DisplayCardProfileState extends State<DisplayCardProfile> {


  _followOrUnfollow(bool isFollowing) {
    log('isFollowing: $isFollowing');
    if (isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() async {
    await userLogic.unfollowUser(userId: widget.user.uid);
    userLogic.updateStateFollowing(false);
  }

  void _followUser() async {
    if (!mounted) return;
    userLogic.updateStateFollowing(true);
    await userLogic.updateFollowUser(widget.user);
    userLogic.followUser(
      receiverToken: widget.user.token,
      userId: widget.user.uid,
    );
  }

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.user.uid != userState.user?.uid)
                        IconButton(
                          icon: Icon(MdiIcons.alertOutline),
                          onPressed: () async {
                            bool? isBlocked = await showMaterialModalBottomSheet(
                              expand: true, context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ReportBlockFit(
                                user: widget.user,
                              ),
                            );
                          },
                        )
                      else
                        const SizedBox.shrink(),

                      if (widget.user.uid != userState.user?.uid)
                        IconButton(
                          // icon: Icon(MdiIcons.at),
                          icon: Icon(MdiIcons.chatProcessingOutline),
                          onPressed: () => Get.to(() => ChatScreenPage(
                            currentUser: userState.user!,
                            receiverUser: widget.user,
                          )),
                        )
                      else
                        const SizedBox.shrink(),

                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  if (widget.user.photoProfile != null) {
                    Get.to(() => FullScreenImage(widget.user.photoProfile!));
                  }
                },
                child: chatCircleAvatar(widget.user, 50),
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
                getUsername(user: widget.user,
                  style: context.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(IMG.idIcon,
                      height: 22, width: 22,
                    ),
                    const SizedBox(width: 6),
                    Text('ID: ${widget.user.uid.hashCode}'),
                  ],
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
                          child: Container(
                            color: Colors.white,
                            child: Image.asset(
                              IMG.sendGift,
                              height: 40, width: 40,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        Text('send_gifts'.tr,
                          style: context.textTheme.bodyText1?.copyWith(
                            fontSize: 12,
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
                          child: Container(
                            color: Colors.white,
                            child: Image.asset(
                              IMG.magic,
                              height: 40, width: 40,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        Text('magic_card'.tr,
                          style: context.textTheme.bodyText1?.copyWith(
                            fontSize: 12,
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
                          child: Container(
                            color: Colors.white,
                            height: 40, width: 40,
                            child: Icon(
                              MdiIcons.volumeOff,
                              color: blackColor,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        Text('mute_mic'.tr),
                      ],
                    ),

                    //! Add Friend
                    GetBuilder<UserLogic>(
                      builder: (logic) {
                        bool isFollowing = logic.state.isFollowing;
                        if (isFollowing) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: InkWell(
                                  onTap: () => _followOrUnfollow(isFollowing),
                                  child: Container(
                                    color: Colors.white,
                                    height: 40, width: 40,
                                    child: Icon(
                                      MdiIcons.accountMinus,
                                      color: blackColor,
                                      // color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Text('unfollow'.tr),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: InkWell(
                                  onTap: () => _followOrUnfollow(isFollowing),
                                  child: Container(
                                    color: Colors.white,
                                    height: 40, width: 40,
                                    child: Icon(
                                      MdiIcons.accountPlus,
                                      color: blackColor,
                                      // color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Text('add_friend'.tr),
                            ],
                          );
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
