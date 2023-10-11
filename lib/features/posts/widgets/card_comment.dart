import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/comment_reply_model.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/models/comment_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/usecases/constants.dart';
import 'package:like_button/like_button.dart';
import '../../../core/models/user_model.dart';
import '../../../core/mobx/mobx_app.dart';
import '../../../core/usecases/keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class CardComment extends StatefulWidget {
  final ValueChanged<CommentReplyModel?> replyFunc;
  final MobxApp mobxApp;
  final String postId;
  final bool isLiked;
  final UserModel user;
  final CommentModel comment;
  const CardComment({Key? key,
    required this.replyFunc,
    required this.mobxApp,
    required this.postId,
    required this.isLiked,
    required this.user,
    required this.comment,
  }) : super(key: key);

  @override
  State<CardComment> createState() => _CardCommentState();
}

class _CardCommentState extends State<CardComment> {

  final MobxApp _mobxReply = MobxApp();

  @override
  void initState() {
    if (mounted) {
      _getReply();
      _mobxReply.onLikePost(widget.isLiked);
      _mobxReply.onChangeLikeCount(widget.comment.likeCounter);
    }
    super.initState();
  }


  Future<bool> _likePost(bool val) async {
    if (_mobxReply.isLiked) {
      // Unlike Comment
      postController.unlikeComment(
        comment: widget.comment,
        postId: widget.postId,
        replyCommentId: null,
        reply: false,
      );
      _mobxReply.onLikePost(false);
      _mobxReply.onChangeLikeCount(_mobxReply.likeCount-1);
    } else {
      // Like Comment
      postController.likeComment(
        comment: widget.comment,
        postId: widget.postId,
        replyCommentId: null,
        reply: false,
      );
      _mobxReply.onLikePost(true);
      _mobxReply.onChangeLikeCount(_mobxReply.likeCount+1);
    }
    return !val;
  }


  Future<void> _getReply() async {

    postsRef.doc(widget.postId).collection(Keys.commentsPost)
        .doc(widget.comment.id)
        .collection(Keys.replayComment).snapshots().listen((event) async {

      for (QueryDocumentSnapshot document in event.docs) {
        CommentModel commentModel = CommentModel.fromDoc(document.data());
        UserModel? user = await userLogic.getUserById(commentModel.authorId);

        bool isLiked = await userLogic.didLikeComment(
          commentId: commentModel.id,
          postId: widget.postId,
        );

        final key = Key(commentModel.id);
        if (user != null) {
          final card = ReplyComment(
            replyCommentId: widget.comment.id,
            comment: commentModel,
            postId: widget.postId,
            mobxField: widget.mobxApp,
            mobxReply: _mobxReply,
            user: user, key: key,
            isLiked: isLiked,
            replyFunc: widget.replyFunc,
          );

          if (_mobxReply.replyComments.isEmpty) {
            _mobxReply.replyComments.add(card);
          } else {
            final _index = _mobxReply.replyComments.indexWhere((item) => item.key == key);
            if (_index == -1) {
              _mobxReply.replyComments.add(card);
            }
          }

          logger.i(_mobxReply.replyComments.length);
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // if (utilsController.isUser(widget.user.email)) {
              //   Get.to(() => UserProfilePage(user: widget.user));
              // } else {
              //   Get.to(() => CompanyProfilePage(user: widget.user));
              // }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: chatCircleAvatar(widget.user),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (utilsController.isUser(widget.user.email)) {
                                //   Get.to(() => UserProfilePage(user: widget.user));
                                // } else {
                                //   Get.to(() => CompanyProfilePage(user: widget.user));
                                // }
                              },
                              child: Text(widget.user.displayName,
                                style: GoogleFonts.notoSans(
                                  fontWeight: FontWeight.bold,
                                  color: headlineColor,
                                ),
                              ),
                            ),
                            Text(postController.timeagoComment(widget.comment),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(widget.comment.content,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.comment.authorId.contains(userState.user!.uid))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: LikeButton(
                          size: 20,
                          onTap: _likePost,
                          likeCount: _mobxReply.likeCount,
                          isLiked: _mobxReply.isLiked,
                          // circleColor: CircleColor(
                            // start: blueAccentColor,
                          //   end: primaryColor,
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
                              result = Text('like'.tr);
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

                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('delete'.tr),
                        onPressed: () {
                          postController.removeCommentAlert(
                            context: context, postId: widget.postId,
                            comment: widget.comment,
                          ).then((value) {
                            if (value) {
                              widget.mobxApp.removeComment(idComment: widget.comment.id);
                            }
                          });
                        },
                      )
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: LikeButton(
                          size: 20,
                          onTap: _likePost,
                          likeCount: _mobxReply.likeCount,
                          isLiked: _mobxReply.isLiked,
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
                              result = Text('like'.tr);
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

                      Observer(
                        builder: (_) {
                          if (widget.mobxApp.replyModel != null &&
                              widget.comment.id == widget.mobxApp.commentId) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text('cancel'.tr),
                              onPressed: () {
                                widget.mobxApp.setCommentId(widget.comment.id);
                                widget.replyFunc(null);
                              },
                            );
                          } else {
                            return TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text('reply'.tr),
                              onPressed: () {
                                widget.mobxApp.setCommentId(widget.comment.id);
                                widget.replyFunc(CommentReplyModel(
                                  firstName: widget.user.displayName,
                                  idComment: widget.comment.id,
                                  uid: widget.user.uid,
                                ));
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),

                Observer(
                  builder: (_) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _mobxReply.replyComments.map((card) {
                        return card;
                      }).toList(),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyComment extends StatefulWidget {
  final ValueChanged<CommentReplyModel?> replyFunc;
  final bool isLiked;
  final String replyCommentId;
  final MobxApp mobxField;
  final MobxApp mobxReply;
  final String postId;
  final UserModel user;
  final CommentModel comment;
  const ReplyComment({Key? key,
    required this.isLiked,
    required this.replyFunc,
    required this.mobxField,
    required this.mobxReply,
    required this.postId,
    required this.user,
    required this.replyCommentId,
    required this.comment,
  }) : super(key: key);

  @override
  State<ReplyComment> createState() => _ReplyCommentState();
}

class _ReplyCommentState extends State<ReplyComment> {


  final MobxApp _mobxApp = MobxApp();

  @override
  void initState() {
    if (mounted) {
      _mobxApp.onLikePost(widget.isLiked);
      _mobxApp.onChangeLikeCount(widget.comment.likeCounter);
    }
    super.initState();
  }


  Future<bool> _likePost(bool val) async {
    if (_mobxApp.isLiked) {
      // Unlike Comment
      postController.unlikeComment(
        replyCommentId: widget.replyCommentId,
        comment: widget.comment,
        postId: widget.postId,
        reply: true,
      );
      _mobxApp.onLikePost(false);
      _mobxApp.onChangeLikeCount(_mobxApp.likeCount-1);
    } else {
      // Like Comment
      postController.likeComment(
        replyCommentId: widget.replyCommentId,
        comment: widget.comment,
        postId: widget.postId,
        reply: true,
      );
      _mobxApp.onLikePost(true);
      _mobxApp.onChangeLikeCount(_mobxApp.likeCount+1);
    }
    return !val;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // if (utilsController.isUser(widget.user.email)) {
              //   Get.to(() => UserProfilePage(user: widget.user));
              // } else {
              //   Get.to(() => CompanyProfilePage(user: widget.user));
              // }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: chatCircleAvatar(widget.user),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (utilsController.isUser(widget.user.email)) {
                                //   Get.to(() => UserProfilePage(user: widget.user));
                                // } else {
                                //   Get.to(() => CompanyProfilePage(user: widget.user));
                                // }
                              },
                              child: Text(
                                widget.user.displayName,
                                style: GoogleFonts.notoSans(
                                  fontWeight: FontWeight.bold,
                                  color: headlineColor,
                                ),
                              ),
                            ),
                            Text(postController.timeagoComment(widget.comment),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(widget.comment.content,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.comment.authorId.contains(userState.user!.uid))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: LikeButton(
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
                              result = Text('like'.tr);
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

                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('delete'.tr),
                        onPressed: () {
                          postController.removeReplyCommentAlert(
                            replyCommentId: widget.replyCommentId,
                            comment: widget.comment,
                            postId: widget.postId,
                            context: context,
                          ).then((value) {
                            if (value) {
                              widget.mobxReply.removeReplyComment(
                                  idComment: widget.comment.id);
                            }
                          });
                        },
                      )
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: LikeButton(
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
                              result = Text('like'.tr);
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

                      Observer(
                        builder: (_) {
                          if (widget.mobxField.replyModel != null &&
                              widget.comment.id == widget.mobxField.commentId) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text('cancel'.tr),
                              onPressed: () {
                                widget.mobxField.setCommentId(widget.comment.id);
                                widget.replyFunc(null);
                              },
                            );
                          } else {
                            return TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text('reply'.tr),
                              onPressed: () {
                                widget.mobxField.setCommentId(widget.comment.id);
                                widget.replyFunc(CommentReplyModel(
                                  firstName: widget.user.displayName,
                                  idComment: widget.replyCommentId,
                                  // idComment: comment.id,
                                  uid: widget.user.uid,
                                ));
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
