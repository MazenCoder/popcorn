import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'edit_post.dart';




class HeaderAnonymousPost extends StatefulWidget {
  final UserModel author;
  final PostModel post;
  final bool isFollow;
  const HeaderAnonymousPost({
    Key? key,
    required this.author,
    required this.post,
    required this.isFollow,
  }) : super(key: key);

  @override
  State<HeaderAnonymousPost> createState() => _HeaderAnonymousPostState();
}

class _HeaderAnonymousPostState extends State<HeaderAnonymousPost> {



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
    // followingController.updateUnfollowUser(widget.author);
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
          chatCircleAvatar(null, 22),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.author.uid == userState.user?.uid)
                Text('stealth_user_you'.tr,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Text('stealth_user'.tr,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            ),
        ],
      ),
    );
  }
}