import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../features/posts/widgets/card_save_post.dart';
import '../../features/posts/widgets/create_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/posts/widgets/card_post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';
import '../widgets_helper/loading_dialog.dart';
import '../theme/generateMaterialColor.dart';
import '../models/comment_reply_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:flutter/material.dart';
import '../models/algolia_model.dart';
import 'package:path/path.dart' as p;
import '../models/comment_model.dart';
import '../usecases/constants.dart';
import '../util/flash_helper.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import 'package:path/path.dart';
import '../usecases/enums.dart';
import 'package:uuid/uuid.dart';
import '../usecases/keys.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';




class PostController extends GetxController {
  static PostController instance = Get.find();

  /// ------  Saved Post ------
  RxList<Widget> posts = <Widget>[].obs;

  RxBool isMooreAvailable = true.obs;

  DocumentSnapshot? _lastDocument;
  List<String> postUserId = [];
  RxBool isSaved = false.obs;
  RxBool loading = false.obs;
  List<String> usersId = [];
  RxList<Widget> savedPost = <Widget>[].obs;
  RxBool isMooreSavedAvailable = true.obs;

  /// ------  Saved Post ------
  DocumentSnapshot? _lastSavedDocument;
  // RxBool loadingSaved = false.obs;



  @override
  void onInit() {
    if (userState.user != null) {
      setupPost();
    }
    super.onInit();
  }


  final spacePost = SizedBox(
    height: 110,
    child: Material(
      shadowColor: primaryColor,
      color: Colors.white,
      elevation: 1,
      child: Column(
        children: [
          InkWell(
            onTap: () => Get.to(() => const CreatePost(
              action: ActionCreatePost.text,
            )),
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 0.8,
                    // color: greyColor
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(20)
                ),
              ),
              child: Row(
                children: [
                  Icon(MdiIcons.squareEditOutline,
                    // color: greyColor,
                  ),
                  const SizedBox(width: 5),
                  Text('start_post'.tr,
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  // overlayColor: MaterialStateProperty.all<Color>(primaryColor),
                ),
                icon: Icon(Icons.photo,
                  color: primaryColor,
                ),
                label: Text('photo'.tr,
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
                onPressed: () => Get.to(() => const CreatePost(
                  action: ActionCreatePost.gallery,
                )),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  // overlayColor: MaterialStateProperty.all<Color>(primaryColor),
                ),
                icon: Icon(MdiIcons.camera,
                  color: primaryColor,
                ),
                label: Text('camera'.tr,
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
                onPressed: () => Get.to(() => const CreatePost(
                  action: ActionCreatePost.camera,
                )),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Future<List<PostModel>> fetchPost(String queryText) async {
    List<PostModel> list = [];
    try {
      // AlgoliaQuery query = algolia.instance.index('posts')
      //     .query(queryText).setHitsPerPage(numLimit);
      // AlgoliaQuerySnapshot snap = await query.getObjects();
      // if (!snap.empty) {
      //   final map = json.encode(snap.toMap());
      //   AlgoliaModel model = algoliaModelFromJson(map);
      //   for (Hit hit in model.hits) {
      //     final post = await getPostById(hit.objectId);
      //     if (post != null) {
      //       list.add(post);
      //     }
      //   }
      // }
      return list;
    } catch(e) {
      logger.e(e);
      return list;
    }
  }

  Future<void> setupPost({bool listener = false}) async {
    try {
      setLoadingPostState(load: true, listener: listener);
      isMooreAvailable.value = true;
      posts.clear();
      addPost(widget: spacePost, listener: listener);

      QuerySnapshot snapshot = await postsRef
          .orderBy('timestamp', descending: true)
          .where('isBanned', isEqualTo: false)
          .where('isArchive', isEqualTo: false)
          .limit(numLimit)
          .get();

      if (snapshot.docs.isEmpty) {
        setLoadingPostState(load: false, listener: listener);
        isMooreAvailable.value = false;
        return;
      }

      _lastDocument = snapshot.docs.last;

      for (var doc in snapshot.docs) {
        if (doc.exists) {

          final json = doc.data() as Map<String, dynamic>;
          PostModel post = PostModel.fromJson(json);
          final key = Key(post.id);

          final userAuthor = await userLogic.getUserById(post.uid);
          final isBlocked = await userLogic.isBlockedUser(uid: userAuthor!.uid);
          if (!isBlocked) {
            bool isLiked = await didLikePost(post: post);
            bool isComment = await didCommentPost(post: post);
            bool isFollowing = await isFollowingUser(userId: post.uid);

            logger.i('postId: ${post.id} isLiked: $isLiked');

            final card = CardPost(
              userAuthor: userAuthor,
              post: post, key: key,
              isLiked: isLiked,
              isComment: isComment,
              isFollow: isFollowing,
            );

            addPost(widget: card, listener: listener);
          }
        }
      }
      setLoadingPostState(load: false, listener: listener);
    } catch(e) {
      logger.e('error: $e');
      setLoadingPostState(load: false, listener: listener);
    }
  }

  Future<void> getMorePost({required BuildContext context, bool listener = false}) async {
    if (!isMooreAvailable.value || _lastDocument == null) return;

    try {
      QuerySnapshot snapshot = await postsRef
          .orderBy('timestamp', descending: true)
          .where('isBanned', isEqualTo: false)
          .where('isArchive', isEqualTo: false)
          .startAfterDocument(_lastDocument!)
          .limit(numLimit)
          .get();

      if (snapshot.docs.isEmpty) {
        isMooreAvailable.value = false;
        return;
      }

      if (snapshot.docs.length < numLimit) {
        isMooreAvailable.value = false;
      }

      _lastDocument = snapshot.docs.last;

      for (var doc in snapshot.docs) {
        if (doc.exists) {
          final json = doc.data() as Map<String, dynamic>;
          PostModel post = PostModel.fromJson(json);
          logger.i('postId: ${post.id}');

          final userAuthor = await userLogic.getUserById(post.uid);
          bool isLiked = await didLikePost(post: post);
          bool isComment = await didCommentPost(post: post);
          bool isFollowing = await isFollowingUser(userId: post.uid);

          if (userAuthor != null) {
            final key = Key(post.id);
            final card = CardPost(
              userAuthor: userAuthor,
              post: post, key: key,
              isLiked: isLiked,
              isComment: isComment,
              isFollow: isFollowing,
            );
            addPost(widget: card, listener: listener);
          }
        }
      }
    } catch(e) {
      logger.e('error: $e');
      FlashHelper.errorBar(context: context, message: '$e');
    }
  }

  void setLoadingPostState({required bool load, bool listener = false}) {
    loading.value = load;
    if (listener) {
      update();
    }
  }

  void setAllPosts(List<Widget> val) {
    posts.value = val;
    update();
  }

  void addPost({required Widget widget, bool listener = false}) {
    posts.add(widget);
    if (listener) {
      update();
    }
  }

  void addSavedPost({required Widget widget, bool listener = false}) {
    savedPost.add(widget);
    if (listener) {
      update();
    }
  }

  void insertPost({required Widget widget, bool listener = false, int index = 1}) {
    if (posts.isEmpty) {
      posts.add(spacePost);
      posts.add(widget);
    } else {
      posts.insert(index, widget);
    }
    if (listener) {
      update();
    }
  }

  void updatePostWidget({required Widget widget, required PostModel model}) {
    final index = posts.indexWhere((element) => element.key == Key(model.id));
    if (index != -1) {
      posts.removeAt(index);
      posts.insert(index, widget);
      update();
    }
  }

  void unlikePost({required PostModel post}) async {
    if (networkState.isConnected) {

      if (post.likeCounter <= 0) return;
      int likeCount = post.likeCounter;
      await postsRef.doc(post.id).update({'likeCounter': likeCount + -1}).then((value) {
        likesRef.doc(post.id)
            .collection(Keys.likesPost)
            .doc(userState.user!.uid)
            .get()
            .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
      });

      PostModel? newPost = await getPostById(post.id);
      if (newPost != null) {
        updatePost(post: newPost);
        deleteActivityItem(
          comment: null,
          currentUserId: userState.user!.uid,
          isFollowEvent: false,
          post: newPost,
          isCommentEvent: false,
          isLikeMessageEvent: false,
          isLikeEvent: true,
          isMessageEvent: false,
        );
      }
    }
  }

  void likePost({required PostModel post}) async {
    if (networkState.isConnected) {
      int likeCount = post.likeCounter;
      postsRef.doc(post.id).update({'likeCounter': likeCount + 1});

      likesRef.doc(post.id).collection(Keys.likesPost)
          .doc(userState.user!.uid).set({
        'uid': userState.user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      PostModel? newPost = await getPostById(post.id);
      if (newPost != null) {
        updatePost(post: newPost);
      }

      final author = await userLogic.getUserById(post.uid);
      addActivityItem(
        currentUserId: userState.user!.uid,
        post: post,
        comment: post.content,
        isFollowEvent: false,
        isLikeMessageEvent: false,
        isLikeEvent: true,
        isCommentEvent: false,
        isMessageEvent: false,
        receiverToken: author?.token??'',
      );
    }
  }

  Future<void> updatePost({required PostModel post}) async {
    final userAuthor = await userLogic.getUserById(post.uid);
    bool isLiked = await didLikePost(post: post);
    bool isComment = await didCommentPost(post: post);
    bool isFollowing = await isFollowingUser(userId: post.uid);

    if (userAuthor != null) {

      final key = Key(post.id);

      final card = CardPost(
        userAuthor: userAuthor,
        post: post, key: key,
        isLiked: isLiked,
        isComment: isComment,
        isFollow: isFollowing,
      );

      updatePostWidget(
        widget: card,
        model: post,
      );
    }
  }

  void deleteActivityItem({
    required String currentUserId,
    required PostModel post,
    String? comment,
    required bool isFollowEvent,
    required bool isCommentEvent,
    required bool isLikeEvent,
    required bool isMessageEvent,
    required bool isLikeMessageEvent
  }) async {
    late String boolCondition;

    if (isFollowEvent) {
      boolCondition = 'isFollowEvent';
    } else if (isCommentEvent) {
      boolCondition = 'isCommentEvent';
    } else if (isLikeEvent) {
      boolCondition = 'isLikeEvent';
    } else if (isMessageEvent) {
      boolCondition = 'isMessageEvent';
    } else if (isLikeMessageEvent) {
      boolCondition = 'isLikeMessageEvent';
    }

    QuerySnapshot activities = await activitiesRef
        .doc(post.uid)
        .collection('userActivities')
        .where('fromUserId', isEqualTo: currentUserId)
        .where('postId', isEqualTo: post.id)
        .where(boolCondition, isEqualTo: true)
        .get();

    for (var element in activities.docs) {
      activitiesRef.doc(post.uid)
          .collection('userActivities')
          .doc(element.id)
          .delete();
    }
  }

  void addActivityItem({
    required String currentUserId,
    required PostModel post,
    String? comment,
    required bool isFollowEvent,
    required bool isCommentEvent,
    required bool isLikeEvent,
    required bool isMessageEvent,
    required bool isLikeMessageEvent,
    required String receiverToken,
  }) {
    if (currentUserId != post.uid) {
      activitiesRef.doc(post.uid).collection('userActivities').add({
        'fromUserId': currentUserId,
        'postId': post.id,
        'postImageUrl': post.urlImage,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
        'isFollowEvent': isFollowEvent,
        'isCommentEvent': isCommentEvent,
        'isLikeEvent': isLikeEvent,
        'isMessageEvent': isMessageEvent,
        'isLikeMessageEvent': isLikeMessageEvent,
        'receiverToken': receiverToken,
      });
    }
  }

  void commentOnPost({
    required String currentUserId, required
    PostModel post, required String content,
    CommentReplyModel? replyModel}) async {
    final id = const Uuid().v4();

    if (replyModel != null) {
      final comment = CommentModel(
        id: id, content: content,
        authorId: currentUserId,
        replyTo: replyModel.uid,
        timestamp: FieldValue.serverTimestamp(),
      );

      await postsRef.doc(post.id).collection(Keys.commentsPost)
          .doc(replyModel.idComment)
          .collection(Keys.replayComment)
          .doc(id)
          .set(comment.toJson());

    } else {

      final comment = CommentModel(
        id: id, content: content,
        authorId: currentUserId,
        timestamp: FieldValue.serverTimestamp(),
      );

      await postsRef.doc(post.id)
          .collection(Keys.commentsPost)
          .doc(id).set(comment.toJson());
    }


    incrementCommentsPost(post: post);

    final author = await userLogic.getUserById(post.uid);
    addActivityItem(
      currentUserId: currentUserId,
      post: post,
      comment: content,
      isFollowEvent: false,
      isLikeMessageEvent: false,
      isCommentEvent: true,
      isLikeEvent: false,
      isMessageEvent: false,
      receiverToken: author?.token??'',
    );
  }

  void incrementCommentsPost({required PostModel post}) async {
    if (networkState.isConnected) {

      int comments = post.commentCounter;
      await postsRef.doc(post.id).update({'commentCounter': comments + 1});

      PostModel? newPost = await getPostById(post.id);
      if (newPost != null) {
        updatePost(post: newPost);
      }
    }
  }

  Future<PostModel?> getPostById(String postId) async {
    try {
      final doc = await postsRef.doc(postId).get();
      if (doc.exists) {
        final json = doc.data() as Map<String, dynamic>;
        return PostModel.fromJson(json);
      }
      return null;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  void decrementCommentsPost({required PostModel post}) async {
    if (networkState.isConnected) {
      int comments = post.commentCounter;
      if (comments > 0) {
        await postsRef.doc(post.id).update({'commentCounter': comments - 1});

        PostModel? newPost = await getPostById(post.id);
        if (newPost != null) {
          updatePost(post: newPost);
        }
      }
    }
  }

  Future<bool> removeCommentAlert({
    required BuildContext context,
    required CommentModel comment,
    required String postId,
  }) async {
    return await showDialog(
      context: context, builder: (context) => AlertDialog(
        title: Text('delete_comment'.tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.bold,
              color: headlineColor,
              fontSize: 16
          ),
        ),
        content: Text('msg_delete_comment'.tr,
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.normal,
              fontSize: 14
          ),
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Navigator.pop(context, false),
          ),

          TextButton(
            child: Text('delete'.tr),
            onPressed: () {
              removeComment(postId, comment);
              Navigator.pop(context, true);
            },
          ),
        ]),
    ) ?? false;
  }


  Future<void> removeComment(String postId, CommentModel comment) async {
    await postsRef.doc(postId).collection(Keys.commentsPost).doc(comment.id).delete();
    PostModel? newPost = await getPostById(postId);
    if (newPost != null) {
      decrementCommentsPost(post: newPost);
    }
  }

  Future<bool> removeReplyCommentAlert({
    required String replyCommentId,
    required BuildContext context,
    required CommentModel comment,
    required String postId,
  }) async {
    return await showDialog(
      context: context, builder: (context) => AlertDialog(
        title: Text('delete_comment'.tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.bold,
              color: headlineColor,
              fontSize: 16
          ),
        ),
        content: Text('msg_delete_comment'.tr,
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.normal,
              fontSize: 14
          ),
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Navigator.pop(context, false),
          ),

          TextButton(
            child: Text('delete'.tr),
            onPressed: () {
              removeReplyComment(postId, comment, replyCommentId);
              Navigator.pop(context, true);
            },
          ),
        ]),
    ) ?? false;
  }


  Future<void> removeReplyComment(String postId, CommentModel comment, String replyCommentId) async {
    await postsRef.doc(postId).collection(Keys.commentsPost).doc(replyCommentId)
        .collection(Keys.replayComment).doc(comment.id).delete();
    PostModel? newPost = await getPostById(postId);
    if (newPost != null) {
      decrementCommentsPost(post: newPost);
    }
  }


  Future<void> removePostUser(BuildContext context, UserModel user) async {
    try {
      List<String> keys = [];
      for (Widget widget in posts) {
        if (widget.runtimeType == CardPost) {
          CardPost card = widget as CardPost;
          if (card.userAuthor.uid == user.uid) {
            keys.add(card.post.id);
          }
        }
      }

      for (String id in keys) {
        posts.removeWhere((element) => element.key == Key(id));
      }
      update();

      if (posts.length < 20) {
        await getMorePost(context: context);
      }

    } catch(e) {
      logger.e(e);
    }
  }

  Future<bool> editPost(BuildContext context, PostModel model, File? file) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        String? url = model.urlImage;
        if (file != null) {
          if (model.urlImage != null) {
            await deletePhotoFromUrl(model.urlImage!);
          }
          url = await _uploadImagePost(file, model);
        }
        await postsRef.doc(model.id).update(model.updateJsonUrlImg(url));
        PostModel? newPost = await getPostById(model.id);
        if (newPost != null) {
          updatePost(post: newPost);
        }
        LoadingDialog.hide(context: context);
        FlashHelper.successBar(context: context, message: 'completed_success'.tr);
        return true;
      } else {
        FlashHelper.errorBar(context: context, message: 'error_connection'.tr);
        return false;
      }
    } catch(e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      FlashHelper.errorBar(context: context, message: 'error_wrong'.tr);
      return false;
    }
  }

  Future<void> deletePost(BuildContext context, PostModel post) async {
    return await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('delete_post'.tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.bold,
              color: headlineColor,
              fontSize: 16
          ),
        ),
        content: Text('msg_delete_post'.tr,
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.normal,
              fontSize: 14
          ),
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Navigator.pop(context, false),
          ),

          TextButton(
            child: Text('delete'.tr),
            onPressed: () {
              _archivePost(post);
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    });
  }

  Future<void> _archivePost(PostModel post) async {
    try {
      await postsRef.doc(post.id).update({'isArchive': true});
      final index = posts.indexWhere((element) => element.key == Key(post.id));
      if (index != -1) {
        posts.removeAt(index);
        update();
      }
    } catch(e) {
      logger.e(e);
    }
  }

  Future<bool> createPost(BuildContext context, PostModel model, File? file) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        String? url;
        if (file != null) {
          url = await _uploadImagePost(file, model);
        }
        await postsRef.doc(model.id).set(model.toJsonUrlImg(url));
        _insertPost(model);
        LoadingDialog.hide(context: context);
        utilsLogic.showSnack(
          type: SnackBarType.success,
          title: 'create_post'.tr,
          message: 'completed_success'.tr,
        );
        return true;
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected
        );
        return false;
      }
    } catch(e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      utilsLogic.showSnack(
        type: SnackBarType.unconnected,
      );
      return false;
    }
  }

  static Future<String?> _uploadImagePost(File file, PostModel model) async {
    try {
      String name = basename(file.path);
      String? typeImage = mime(name);
      final refStorage = "${Keys.users}/${model.uid}/${Keys.posts}/${model.id}/$name";
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(refStorage);
      firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
        contentType: '$typeImage', customMetadata: {'picked-file-path': file.path},
      );

      return await ref.putFile(file, metadata).then((firebase_storage.TaskSnapshot snapshot) async {
        return await snapshot.ref.getDownloadURL();
      });

    } catch(e) {
      logger.e('e: $e');
      return null;
    }
  }

  Future<void> _insertPost(PostModel model) async {
    try {
      PostModel? post = await getPostById(model.id);
      if (post != null) {
        final userAuthor = await userLogic.getUserById(post.uid);
        // List<SurveyModel> surveys = await appUtils.getSurveyById(post.uid);
        bool isLiked = await didLikePost(post: post);
        bool isComment = await didCommentPost(post: post);
        bool isFollowingU = await isFollowingUser(userId: post.uid);

        if (userAuthor != null) {
          final key = Key(post.id);
          final card = CardPost(
            userAuthor: userAuthor,
            post: post, key: key,
            isLiked: isLiked,
            isComment: isComment,
            isFollow: isFollowingU,
          );
          insertPost(widget: card, listener: true);
        }
      }
    } catch(e) {
      logger.e(e);
    }
  }

  Future<bool> isFollowingUser({required String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(userId)
        .collection(Keys.userFollowers)
        .doc(auth.currentUser!.uid)
        .get();

    return followingDoc.exists;
  }

  Future<bool> didCommentPost({required PostModel post}) async {
    if (networkState.isConnected) {

      QuerySnapshot userDoc = await postsRef.doc(post.id).collection(Keys.commentsPost)
          .where('authorId', isEqualTo: auth.currentUser!.uid)
          .get();

      return userDoc.docs.isBlank ?? false;
    } else {
      return false;
    }
  }

  Future<bool> didLikePost({required PostModel post}) async {
    if (networkState.isConnected) {
      DocumentSnapshot userDoc = await likesRef
          .doc(post.id)
          .collection(Keys.likesPost)
          .doc(auth.currentUser!.uid)
          .get();
      return userDoc.exists;
    } else {
      return false;
    }
  }

  Future<bool> deleteImagePost(BuildContext context, PostModel post) async {
    try {
      return await showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text('confirm'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
                color: headlineColor,
                fontSize: 16
            ),
          ),
          content: Text('msg_delete_image'.tr,
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.normal,
                fontSize: 14
            ),
          ),
          actions: [
            TextButton(
              child: Text('cancel'.tr),
              onPressed: () => Navigator.pop(context, false),
            ),

            TextButton(
              child: Text('delete'.tr),
              onPressed: () async {
                bool val = await _deleteImagePost(context, post);
                Navigator.pop(context, val);
              },
            ),
          ],
        );
      });
    } catch(e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> _deleteImagePost(BuildContext context, PostModel post) async {
    try {
      LoadingDialog.show(context: context);
      var fileUrl = Uri.decodeFull(p.basename(post.urlImage!)).replaceAll(RegExp(r'(\?alt).*'), '');
      await storage.ref(fileUrl).delete().then((value) async {
        await postsRef.doc(post.id).update({'urlImage': null});
        PostModel? newPost = await getPostById(post.id);
        if (newPost != null) {
          updatePost(post: newPost);
        }
      });
      LoadingDialog.hide(context: context);
      return true;
    } catch(e) {
      LoadingDialog.hide(context: context);
      FlashHelper.errorBar(context: context, message: '$e');
      logger.e(e);
      return false;
    }
  }

  Future<bool> deletePhotoFromUrl(String url) async {
    try {
      var fileUrl = Uri.decodeFull(p.basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');
      await storage.ref(fileUrl).delete();
      return true;
    } catch(e) {
      logger.e(e);
      return false;
    }
  }

  Future<void> postSavePost(BuildContext context, PostModel post) async {
    try {
      final ref = usersRef.doc(userState.user!.uid).collection(Keys.savePosts).doc(post.id);
      final document = await ref.get();
      if (document.exists) {
        await ref.delete();
        isSaved.value = false;
        removeSavePostCard(post);
      } else {
        await ref.set({'postId': post.id});
        isSaved.value = true;
      }
      // update();
    } catch(e) {
      logger.e(e);
    }
  }

  void checkPostSaved(PostModel post) async {
    try {
      final ref = usersRef.doc(userState.user!.uid).collection(Keys.savePosts).doc(post.id);
      final document = await ref.get();
      if (document.exists) {
        isSaved.value = false;
      } else {
        isSaved.value = true;
      }
      update();
    } catch(e) {
      logger.e(e);
    }
  }

  Future<void> getSavedPost({bool listener = false}) async {
    try {
      setLoadingPostState(load: true, listener: listener);
      isMooreSavedAvailable.value = true;
      savedPost.clear();

      QuerySnapshot snapshot = await usersRef
          .doc(userState.user!.uid)
          .collection(Keys.savePosts)
          .limit(numLimit)
          .get();

      if (snapshot.docs.isEmpty) {
        setLoadingPostState(load: false, listener: listener);
        isMooreSavedAvailable.value = false;
        return;
      }

      _lastSavedDocument = snapshot.docs.last;

      for (var doc in snapshot.docs) {
        if (doc.exists) {
          PostModel? post = await getPostById(doc.id);
          if (post != null) {
            final key = Key(post.id);
            final userAuthor = await userLogic.getUserById(post.uid);
            final isBlocked = await userLogic.isBlockedUser(uid: userAuthor!.uid);
            if (!isBlocked) {
              bool isLiked = await didLikePost(post: post);
              bool isComment = await didCommentPost(post: post);
              bool isFollowing = await isFollowingUser(userId: post.uid);

              logger.i('postId: ${post.id} isLiked: $isLiked');

              final card = CardSavePost(
                userAuthor: userAuthor,
                post: post, key: key,
                isLiked: isLiked,
                isComment: isComment,
                isFollow: isFollowing,
              );

              addSavedPost(widget: card, listener: listener);
            }
          }
        }
      }
      setLoadingPostState(load: false, listener: listener);
    } catch(e) {
      logger.e('error: $e');
      setLoadingPostState(load: false, listener: listener);
    }
  }

  Future<void> getMoreSavedPost({required BuildContext context, bool listener = false}) async {
    if (!isMooreSavedAvailable.value || _lastDocument == null) return;

    try {
      QuerySnapshot snapshot = await usersRef
          .doc(userState.user!.uid)
          .collection(Keys.savePosts)
          .startAfterDocument(_lastSavedDocument!)
          .limit(numLimit)
          .get();

      if (snapshot.docs.isEmpty) {
        isMooreSavedAvailable.value = false;
        return;
      }

      if (snapshot.docs.length < numLimit) {
        isMooreSavedAvailable.value = false;
      }

      _lastSavedDocument = snapshot.docs.last;

      for (var doc in snapshot.docs) {
        if (doc.exists) {
          PostModel? post = await getPostById(doc.id);
          if (post != null) {
            final userAuthor = await userLogic.getUserById(post.uid);
            bool isLiked = await didLikePost(post: post);
            bool isComment = await didCommentPost(post: post);
            bool isFollowing = await isFollowingUser(userId: post.uid);

            if (userAuthor != null) {
              final key = Key(post.id);
              final card = CardSavePost(
                userAuthor: userAuthor,
                post: post, key: key,
                isLiked: isLiked,
                isComment: isComment,
                isFollow: isFollowing,
              );
              addSavedPost(widget: card, listener: listener);
            }
          }
        }
      }
    } catch(e) {
      logger.e('error: $e');
      FlashHelper.errorBar(context: context, message: '$e');
    }
  }

  void removeSavePostCard(PostModel post) {
    if (savedPost.isNotEmpty) {
      final index = savedPost.indexWhere((element) => element.key == Key(post.id));
      if (index != -1) {
        savedPost.removeAt(index);
        update();
      }
    }
  }

  void unlikeComment({
    bool reply = false,
    required String postId,
    String? replyCommentId,
    required CommentModel comment}) async {
    if (networkState.isConnected) {

      if (comment.likeCounter <= 0) return;
      int likeCount = comment.likeCounter;
      if (reply) {
        final ref = postsRef.doc(postId).collection(Keys.commentsPost)
            .doc(replyCommentId).collection(Keys.replayComment)
            .doc(comment.id);
        final doc = await ref.get();
        if (doc.exists) {
          ref.update({'likeCounter': likeCount + -1}).then((value) {
            likesRef.doc(postId)
                .collection(Keys.likesComment)
                .doc(userState.user!.uid+comment.id)
                .get()
                .then((doc) {
              if (doc.exists) {
                doc.reference.delete();
              }
            });
          });
        }

      } else {
        final ref = postsRef.doc(postId).collection(Keys.commentsPost)
            .doc(comment.id);

        final doc = await ref.get();
        if (doc.exists) {
          ref.update({'likeCounter': likeCount + -1}).then((value) {
            likesRef.doc(postId)
                .collection(Keys.likesComment)
                .doc(userState.user!.uid+comment.id)
                .get()
                .then((doc) {
              if (doc.exists) {
                doc.reference.delete();
              }
            });
          });
        }
      }


      // PostModel? newPost = await getPostById(postId);
      // if (newPost != null) {
      // updatePost(post: newPost);
      // deleteActivityItem(
      //   comment: null,
      //   currentUserId: userState.user!.uid,
      //   isFollowEvent: false,
      //   post: newPost,
      //   isCommentEvent: false,
      //   isLikeMessageEvent: false,
      //   isLikeEvent: true,
      //   isMessageEvent: false,
      // );
      // }
    }
  }

  void likeComment({required String postId,
    bool reply = false,
    String? replyCommentId,
    required CommentModel comment}) async {
    if (networkState.isConnected) {
      int likeCount = comment.likeCounter;

      if (reply) {
        final ref = postsRef.doc(postId)
            .collection(Keys.commentsPost)
            .doc(replyCommentId)
            .collection(Keys.replayComment)
            .doc(comment.id);

        final doc = await ref.get();
        if (doc.exists) {
          ref.update({'likeCounter': likeCount + 1});

          likesRef.doc(postId).collection(Keys.likesComment)
              .doc(userState.user!.uid+comment.id).set({
            'commentId': comment.id,
            'uid': userState.user!.uid,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }


      } else {
        final ref = postsRef.doc(postId)
            .collection(Keys.commentsPost)
            .doc(comment.id);

        final doc = await ref.get();
        if (doc.exists) {
          ref.update({'likeCounter': likeCount + 1});
          likesRef.doc(postId).collection(Keys.likesComment)
              .doc(userState.user!.uid+comment.id).set({
            'commentId': comment.id,
            'uid': userState.user!.uid,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }

      // PostModel? newPost = await getPostById(post.id);
      // if (newPost != null) {
      //   updatePost(post: newPost);
      // }
      //
      // final author = await appUtils.getUserById(post.uid);
      //
      // addActivityItem(
      //   currentUserId: userState.user!.uid,
      //   post: post,
      //   comment: post.content,
      //   isFollowEvent: false,
      //   isLikeMessageEvent: false,
      //   isLikeEvent: true,
      //   isCommentEvent: false,
      //   isMessageEvent: false,
      //   receiverToken: author?.token??'',
      // );
    }
  }

  String timeagoComment(CommentModel model) {
    try {
      if (model.timestamp != null) {
        return timeago.format(model.timestamp.toDate(), locale: 'en_short');
      } else {
        return 'now'.tr;
      }
    } catch(e) {
      return 'now'.tr;
    }
  }

  String timePost(PostModel post) {
    try {
      return timeago.format(post.timestamp.toDate(), locale: 'en_short');
    } catch(e) {
      logger.e(e);
      return '';
    }
  }

}