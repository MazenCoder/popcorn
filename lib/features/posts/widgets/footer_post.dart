import 'package:popcorn/packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/theme/generateMaterialColor.dart';
import '../../../core/controllers/post_controllerl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../account/widgets/report_block_fit.dart';
import '../../../core/usecases/constants.dart';
import 'package:like_button/like_button.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/user_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/usecases/keys.dart';
import '../../../core/mobx/mobx_app.dart';
import 'package:flutter/material.dart';
import 'card_footer_icon.dart';
import 'package:get/get.dart';
import 'comment_post.dart';




class FooterPost extends StatefulWidget {
  final PostModel post;
  final UserModel author;
  final bool isLiked;
  final bool isComment;
  const FooterPost({Key? key,
    required this.post,
    required this.author,
    required this.isLiked,
    required this.isComment,
  }) : super(key: key);

  @override
  State<FooterPost> createState() => _FooterPostState();
}

class _FooterPostState extends State<FooterPost> {


  final _postController = Get.find<PostController>();
  final MobxApp _mobxApp = MobxApp();

  @override
  void initState() {
    if (mounted) {
      _mobxApp.onLikePost(widget.isLiked);
      _mobxApp.onChangeLikeCount(widget.post.likeCounter);
      _mobxApp.onCommentPost(!widget.isComment);
      _mobxApp.onChangeCommentCount(widget.post.commentCounter);
    }
    super.initState();
  }


  @override
  didUpdateWidget(FooterPost oldWidget) {
    if (oldWidget.post.likeCounter != widget.post.likeCounter) {
      _mobxApp.onChangeLikeCount(widget.post.likeCounter);
      _mobxApp.onLikePost(widget.isLiked);
    }

    if (oldWidget.post.commentCounter != widget.post.commentCounter) {
      _mobxApp.onChangeCommentCount(widget.post.commentCounter);
      _mobxApp.onCommentPost(!widget.isComment);
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<bool> _likePost(bool val) async {
    if (_mobxApp.isLiked) {
      // Unlike Post
      _postController.unlikePost(post: widget.post);
      _mobxApp.onLikePost(false);
      _mobxApp.onChangeLikeCount(_mobxApp.likeCount-1);
    } else {
      // Like Post
      _postController.likePost(
        post: widget.post,
      );
      _mobxApp.onLikePost(true);
      _mobxApp.onChangeLikeCount(_mobxApp.likeCount+1);
    }
    return !val;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: _likePost,
            likeCount: _mobxApp.likeCount,
            isLiked: _mobxApp.isLiked,
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
          InkWell(
            onTap: () => Get.to(() => CommentPost(
              author: widget.author,
              post: widget.post,
            )),
            child: AbsorbPointer(
              absorbing: true,
              child: LikeButton(
                size: 20,
                likeCount: _mobxApp.commentCount,
                isLiked: _mobxApp.isComment,
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
          ),

          //! Share
          CardFooterIcon(
            text: 'share'.tr,
            icon: const Icon(
              MdiIcons.shareOutline,
              color: Colors.black54,
              size: 20,
            ),
            onTap: () async {
              await Share.share(widget.post.content, subject: 'name_app'.tr,);
            },
          ),

          PopupMenuButton(
            icon: const Icon(MdiIcons.dotsHorizontal),
            onSelected: (value) async {
              switch(value) {
                case 1: {
                  bool? isBlocked = await showMaterialModalBottomSheet(
                    expand: true, context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ReportBlockFit(user: widget.author),
                  );
                  if (isBlocked != null && isBlocked) {
                    await _postController.removePostUser(context, widget.author);
                  }
                }
                break;
                case 2: {
                  _postController.postSavePost(context, widget.post);
                }
                break;
              }
            },
            itemBuilder: (context) => [
              if (widget.post.uid != userState.user?.uid)
                PopupMenuItem(
                  value: 1,
                  child: Text("report_block".tr),
                ),
              PopupMenuItem(
                value: 2,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: usersRef.doc(userState.user!.uid)
                      .collection(Keys.savePosts)
                      .doc(widget.post.id).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data?.exists??false) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("saved".tr),
                          Icon(Icons.bookmark,
                            color: primaryColor,
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("save".tr),
                          Icon(Icons.bookmark_border,
                            // color: greyColor,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
