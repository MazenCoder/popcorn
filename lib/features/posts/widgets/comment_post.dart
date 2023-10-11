import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:popcorn/features/posts/widgets/header_comment.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/models/comment_reply_model.dart';
import 'package:detectable_text_field/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../account/widgets/report_block_fit.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/models/comment_model.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/mobx/mobx_app.dart';
import '../../../core/usecases/keys.dart';
import '../../widgets/web_view_app.dart';
import 'package:flutter/material.dart';
import 'header_anonymous_comment.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/util/img.dart';
import 'package:get/get.dart';
import 'card_comment.dart';




class CommentPost extends StatefulWidget {
  final UserModel author;
  final PostModel post;
  const CommentPost({Key? key,
    required this.post,
    required this.author,
  }) : super(key: key);

  @override
  State<CommentPost> createState() => _CommentPostState();
}

class _CommentPostState extends State<CommentPost> {


  final TextEditingController _commentController = TextEditingController();
  final MobxApp _mobxApp = MobxApp();
  FocusNode inputNode = FocusNode();


  @override
  void initState() {
    _getComments();
    super.initState();
  }

  Future<void> _getComments() async {
    int? _index;
    postsRef.doc(widget.post.id)
        .collection(Keys.commentsPost)
        .orderBy('timestamp', descending: true)
        .snapshots().listen((event) async {

      for (QueryDocumentSnapshot document in event.docs) {
        CommentModel comment = CommentModel.fromDoc(document.data());
        UserModel? user = await userLogic.getUserById(comment.authorId);
        bool isLiked = await userLogic.didLikeComment(
          commentId: comment.id,
          postId: widget.post.id,
        );

        if (user != null) {
          final key = Key(comment.id);
          final card = CardComment(
            postId: widget.post.id,
            isLiked: isLiked,
            mobxApp: _mobxApp,
            comment: comment,
            user: user,
            key: key,
            replyFunc: (CommentReplyModel? model) {
              _mobxApp.setReplyComment(model);
            },
          );

          if (_mobxApp.cardComments.isNotEmpty) {
            _index = _mobxApp.cardComments.indexWhere((item) => item.key == card.key);
          }

          if (_mobxApp.isLoadedComment) {
            if (_index == null) {
              _mobxApp.cardComments.insert(0, card);
            } else if (_index == -1) {
              _mobxApp.cardComments.insert(0, card);
            }
          } else {
            if (_index == null) {
              _mobxApp.cardComments.add(card);
            } else if (_index == -1) {
              _mobxApp.cardComments.add(card);
            }
          }
        }
      }
      _mobxApp.setLoadedComment(true);
    });
  }


  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final anonymous = widget.post.idVisibility == 2;
    return ResponsiveSafeArea(
      color: Colors.white,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                color: primaryColor,
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              PopupMenuButton(
                icon: Icon(MdiIcons.dotsHorizontal,
                  color: primaryColor,
                ),
                onSelected: (value) async {
                  switch(value) {
                    case 1: {
                      bool? isBlocked = await showMaterialModalBottomSheet(
                        expand: true, context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ReportBlockFit(user: widget.author),
                      );
                      if (isBlocked != null && isBlocked) {
                        await postController.removePostUser(context, widget.author);
                      }
                    }
                    break;
                    case 2: {
                      postController.postSavePost(context, widget.post);
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
          // backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (anonymous)
                  HeaderAnonymousComment(
                    author: widget.author,
                    post: widget.post,
                  )
                else
                  HeaderComment(
                    author: widget.author,
                    post: widget.post,
                  ),

                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
                  child: DetectableText(
                    text: widget.post.content,
                    textAlign: TextAlign.start,
                    detectionRegExp: detectionRegExp()!,
                    onTap: (text) {
                      logger.i(text);
                      if (isDetected(text, urlRegex)) {
                        Get.to(() => WebVewApp(url: text));
                      } else if (isDetected(text, hashTagRegExp)) {
                        // Get.to(() => HashtagPage(hashtag: text));
                      } else if (isDetected(text, atSignRegExp)) {

                      }
                    },
                  ),
                ),

                if (widget.post.urlImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        height: Get.height/2.2,
                        width: Get.width,
                        fit: BoxFit.fill,
                        imageUrl: widget.post.urlImage??'',
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(child: Image.asset(IMG.defaultImg)),
                      ),
                    ),
                  ),

                Observer(
                  builder: (_) {
                    if (_mobxApp.isLoadedComment) {
                      if (_mobxApp.cardComments.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('first_comment'.tr,
                            style: GoogleFonts.notoSans(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          reverse: false,
                          padding: const EdgeInsets.all(8),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _mobxApp.cardComments.length,
                          itemBuilder: (context, index) {
                            return _mobxApp.cardComments[index];
                          },
                        );
                      }
                    } else {
                      return Shimmer.fromColors(
                        highlightColor: primaryColor.shade200,
                        baseColor: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: chatCircleAvatar(null),
                            title: Container(
                              width: Get.width - 200,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              width: Get.width - 100,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: isKeyboardOpen ? MediaQuery.of(context).viewInsets.bottom + 100 : 100),

              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          resizeToAvoidBottomInset: false,
          floatingActionButton: Container(
              margin: isKeyboardOpen ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                : const EdgeInsets.all(1.0),
            color: Colors.white,
            width: Get.width,
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 5),
                chatCircleAvatar(userState.user),
                const SizedBox(width: 5),
                Expanded(
                  child: Observer(
                    builder: (_) {
                      return TextField(
                        autofocus: true,
                        focusNode: inputNode,
                        controller: _commentController,
                        cursorColor: primaryColor,
                        onChanged: (String? val) {
                          final text = (val != null && val.isNotEmpty);
                          _mobxApp.onChangeText(text);
                        },
                        decoration: InputDecoration(
                            hintText: _mobxApp.replyModel != null ?
                              'reply_to'.trArgs([_mobxApp.replyModel!.firstName])
                              : 'leave_thoughts'.tr,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              color: primaryColor,
                              onPressed: _mobxApp.textIsNotEmpty ? () {
                                // FocusManager.instance.primaryFocus?.unfocus();
                                postController.commentOnPost(
                                  post: widget.post,
                                  currentUserId: userState.user!.uid,
                                  content: _commentController.text.trim(),
                                  replyModel: _mobxApp.replyModel,
                                );
                                _mobxApp.setReplyComment(null);
                                _commentController.clear();
                              } : null,
                            )
                        ),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15.0,
                        ),
                      );
                    },
                  )
                ),
              ],
            )
          ),
        );
      },
    );
  }

}
