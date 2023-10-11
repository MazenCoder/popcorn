import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/controllers/user/user_logic.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'edit_post.dart';




class HeaderPost extends StatefulWidget {
  final UserModel author;
  final PostModel post;
  final bool isFollow;
  const HeaderPost({
    Key? key,
    required this.author,
    required this.post,
    required this.isFollow,
  }) : super(key: key);

  @override
  State<HeaderPost> createState() => _HeaderPostState();
}

class _HeaderPostState extends State<HeaderPost> {



  @override
  void initState() {
    if (mounted) {
      _setupIsFollowing();
    }
    super.initState();
  }


  _setupIsFollowing() {
    if (!mounted) return;
    userLogic.setFollowingState(widget.isFollow, false);
  }

  Future<void> _followOrUnfollow() async {
    if (userLogic.state.isFollowing) {
      await _unfollowUser();
    } else {
      await _followUser();
    }
    postController.updatePost(post: widget.post);
  }

  Future<void> _unfollowUser() async {
    await userLogic.unfollowUser(userId: widget.author.uid);
    userLogic.setFollowingState(false);
    followingController.updateUnfollowUser(widget.author);
  }

  Future<void> _followUser() async {
    await userLogic.followUser(
      userId: widget.author.uid,
      receiverToken: widget.author.token??'',
    );
    if (!mounted) return;
    userLogic.setFollowingState(true);
    followingController.updateFollowUser(widget.author);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // if (utilsController.isUser(widget.author.email)) {
              //   Get.to(() => UserProfilePage(user: widget.author));
              // } else {
              //   Get.to(() => CompanyProfilePage(user: widget.author));
              // }
            },
            child: chatCircleAvatar(widget.author, 22),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // if (utilsController.isUser(widget.author.email)) {
                  //   Get.to(() => UserProfilePage(user: widget.author));
                  // } else {
                  //   Get.to(() => CompanyProfilePage(user: widget.author));
                  // }
                },
                child: getUsername(user: widget.author,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(postController.timePost(widget.post),
                    style: GoogleFonts.notoSans(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
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
                  Text(typesPost[widget.post.idTypesPost]!,
                    style: GoogleFonts.notoSans(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
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

                  Text(visibilityOptions[widget.post.idVisibility]!,
                    style: GoogleFonts.notoSans(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
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

                  visibilityIconPost[widget.post.idVisibility]!,
                ],
              )
            ],
          ),
          const Expanded(child: SizedBox()),

          if (widget.author.uid == userState.user?.uid)
            PopupMenuButton(
              icon: const Icon(MdiIcons.dotsHorizontal),
              onSelected: (value) async {
                switch(value) {
                  case 1: {
                    Get.to(() => EditPost(post: widget.post));
                  }
                  break;
                  case 2: {
                    await postController.deletePost(context, widget.post);
                  }
                  break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("edit".tr,),
                  value: 1,
                ),

                PopupMenuItem(
                  child: Text("delete".tr),
                  value: 2,
                ),

              ],
            )
          else
            GetBuilder<UserLogic>(
              init: UserLogic(),
              builder: (controller) {
                if (controller.state.isFollowing) {
                  return Container(
                    height: 38.0,
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.lightBlue.withOpacity(0.2),
                      onTap: _followOrUnfollow,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                            style: BorderStyle.solid,
                            width: 1.9,
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.check,
                              color: primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Center(
                              child: Text('following'.tr,
                                style: GoogleFonts.notoSans(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 38.0,
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.lightBlue.withOpacity(0.2),
                      onTap: _followOrUnfollow,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                            style: BorderStyle.solid,
                            width: 1.9,
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.add,
                              color: primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Center(
                              child: Text('follow'.tr,
                                style: GoogleFonts.notoSans(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}