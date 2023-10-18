import 'package:popcorn/core/controllers/user/user_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:popcorn/core/models/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../notification/notification_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets_helper/loading_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/generateMaterialColor.dart';
import '../../models/subscription_model.dart';
import 'package:mime_type/mime_type.dart';
import '../../models/activity_model.dart';
import '../../models/address_model.dart';
import '../../usecases/constants.dart';
import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../util/flash_helper.dart';
import '../../models/user_model.dart';
import '../../error/exceptions.dart';
import '../../error/failures.dart';
import '../../usecases/enums.dart';
import 'package:dartz/dartz.dart';
import '../../usecases/keys.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';




class UserLogic extends GetxController {
  static UserLogic instance = Get.find();
  final state = UserState();



  Future<void> initUser(User? user) async {
    if (user != null) {
      state.user = await getUserById(user.uid);
      state.idToken = await user.getIdToken();
      update();
    }
  }

  Future<UserModel> getUserById(String uid) async {
    final url = '$baseUrlApi/v1/user/get/$uid';
    final response = await apiClient.getData(url: url);
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJson(jsonResponse['user']);
  }

  Future<UserModel?> getUserByKey(int id) async {
    if (networkState.isConnected) {
      QuerySnapshot query = await usersRef
        .where('uniqueKey', isEqualTo: id)
        .get();
      if (query.docs.isNotEmpty) {
        final document = query.docs.first;
        final json = document.data() as Map<String, dynamic>;
        return UserModel.fromJson(json);
      }
      return null;
    } else {
      return null;
    }
  }

  Future<bool> didLikeComment({required String postId, required String commentId}) async {
    if (networkState.isConnected) {
      DocumentSnapshot userDoc = await likesRef
          .doc(postId)
          .collection(Keys.likesComment)
          .doc(auth.currentUser!.uid+commentId)
          .get();
      return userDoc.exists;
    } else {
      return false;
    }
  }


  Future<void> getCurrentUser({bool listener = false}) async {
    final document = await usersRef.doc(auth.currentUser!.uid).get();
    final json = document.data() as Map<String, dynamic>;
    final model = UserModel.fromJson(json);
    state.user = model;
    if (listener) {
      update();
    }
  }

  Future<bool> isBlockedUser({required String uid}) async {
    DocumentSnapshot doc = await usersRef.doc(auth.currentUser!.uid)
        .collection(Keys.blockedUsers).doc(uid).get();
    return doc.exists;
  }


  ///! ------------------- Addresses -------------------
  Future<List<AddressModel>> getAddresses() async {
    List<AddressModel> addresses = [];
    try {
      QuerySnapshot query = await usersRef.doc(auth.currentUser!.uid)
          .collection(Keys.addresses)
          .orderBy('timestamp', descending: true)
      //.where('default', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot doc in query.docs) {
        if (doc.exists) {
          final json = doc.data() as Map<String, dynamic>;
          final model = AddressModel.fromJson(json);
          addresses.add(model);
        }
      }
      return addresses;
    } catch(e){
      logger.e(e);
      return addresses;
    }
  }

  Future<bool> saveAddress(BuildContext context, AddressModel model) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        await usersRef.doc(auth.currentUser!.uid)
            .collection(Keys.addresses).doc(model.id)
            .set(model.toJson());
        if (context.mounted) LoadingDialog.hide(context: context);
        return true;
      } else {
        FlashHelper.errorBar(context: context, message: 'error_connection'.tr);
        return false;
      }
    } catch(e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      return false;
    }
  }

  Future<bool> deleteAddress(BuildContext context, String id) async {
    try {
      await usersRef.doc(auth.currentUser!.uid)
          .collection(Keys.addresses).doc(id).delete();
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> updateAddress(BuildContext context, AddressModel model) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        await usersRef.doc(auth.currentUser!.uid)
            .collection(Keys.addresses).doc(model.id)
            .update(model.toUpdateJson());
        if (context.mounted) LoadingDialog.hide(context: context);
        return true;
      } else {
        FlashHelper.errorBar(context: context, message: 'error_connection'.tr);
        return false;
      }
    } catch(e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      return false;
    }
  }


  Future<void> userWebsite({required BuildContext context, required String url}) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        await usersRef.doc(auth.currentUser!.uid)
            .update({'website': url});
        if (context.mounted) LoadingDialog.hide(context: context);
        if (context.mounted) FlashHelper.successBar(context: context, message: 'completed_success'.tr);
        await getCurrentUser(listener: true);
        // UserModel model = await getUserById(firebaseUtil.auth.currentUser!.uid);
        // context.read<AppNotifier>().setUser(model);
      } else {
        FlashHelper.errorBar(context: context, message: 'error_connection'.tr);
      }
    } catch(e) {
      logger.e(e);
      if (context.mounted) FlashHelper.errorBar(context: context, message: 'error_wrong'.tr);
    }
  }

  Future resetPassword(BuildContext context, String email) async {
    final ctx = Get.overlayContext ?? context;
    try {
      LoadingDialog.show(context: ctx);
      await auth.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        LoadingDialog.hide(context: ctx);
        FlashHelper.successBar(context: ctx, message: 'check_email'.tr);
      }
    }  on FirebaseAuthException catch (e) {
      if (context.mounted) LoadingDialog.hide(context: ctx);
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
        if (context.mounted) FlashHelper.errorBar(context: ctx, message: 'user_not_found'.tr);
      } else {
        logger.e(e);
        if (context.mounted) FlashHelper.errorBar(context: ctx, message: 'something_wrong'.tr);
      }
    } catch(e) {
      logger.e(e);
      if (context.mounted) {
        LoadingDialog.hide(context: ctx);
        FlashHelper.errorBar(context: ctx, message: 'something_wrong'.tr);
      }
    }
  }


  Future<List<ActivityModel>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(userId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .get();
    List<ActivityModel> activity = userActivitiesSnapshot.docs
        .map((doc) => ActivityModel.fromDoc(doc))
        .toList();
    return activity;
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
    String? receiverToken,
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

  void deleteActivityItem({
    required String currentUserId,
    required PostModel post,
    String? comment,
    required bool isFollowEvent,
    required bool isCommentEvent,
    required bool isLikeEvent,
    required bool isMessageEvent,
    required bool isLikeMessageEvent,
  }) async {

    String boolCondition = '';

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


  void signOut() {
    state.user == null;
    update();
  }

  Future<void> updateCompanySize({required BuildContext context,
    required String uid, required int sizeId}) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        await usersRef.doc(uid).collection(Keys.companies)
            .doc(uid).set({"sizeId": sizeId}, SetOptions(merge: true));
        if (context.mounted) LoadingDialog.hide(context: context);
        utilsLogic.showSnack(
          type: SnackBarType.success,
          title: 'company_size'.tr,
          message: 'completed_success'.tr,
        );
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected,
        );
      }
    } catch(e) {
      logger.e(e);
      if (context.mounted) LoadingDialog.hide(context: context);
      utilsLogic.showSnack(
        type: SnackBarType.error,
        title: 'company_size'.tr,
        message: '$e',
      );
    }
  }

  Future<void> updateCompanyType({required BuildContext context,
    required String uid, required int typeId}) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        await usersRef.doc(uid).collection(Keys.companies)
            .doc(uid).set({"typeId": typeId}, SetOptions(merge: true));
        if (context.mounted) LoadingDialog.hide(context: context);
        utilsLogic.showSnack(
          type: SnackBarType.success,
          title: 'company_type'.tr,
          message: 'completed_success'.tr,
        );
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected,
        );
      }
    } catch(e) {
      logger.e(e);
      if (context.mounted) LoadingDialog.hide(context: context);
      utilsLogic.showSnack(
        type: SnackBarType.error,
        title: 'company_type'.tr,
        message: '$e',
      );
    }
  }

  Future<void> updateCompanyDateFounded({required BuildContext context,
    required String uid, required DateTime dateFounded}) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        await usersRef.doc(uid).collection(Keys.companies)
            .doc(uid).set({"dateFounded": dateFounded}, SetOptions(merge: true));
        if (context.mounted) LoadingDialog.hide(context: context);
        utilsLogic.showSnack(
          type: SnackBarType.success,
          title: 'year_founded'.tr,
          message: 'completed_success'.tr,
        );
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected,
        );
      }
    } catch(e) {
      logger.e(e);
      if (context.mounted) LoadingDialog.hide(context: context);
      utilsLogic.showSnack(
        type: SnackBarType.error,
        title: 'year_founded'.tr,
        message: '$e',
      );
    }
  }

  Future<void> subscription(SubscriptionModel model) async {
    await usersRef.doc(state.user!.uid)
        .collection(Keys.subscriptions)
        .doc(model.subscriptionId)
        .set(model.toJson());
  }

  Future<bool> reportAccount(BuildContext context, ReportModel model) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        await reportsRef.doc(model.id).set(model.toJson());
        if (context.mounted) {
          LoadingDialog.hide(context: context);
          FlashHelper.successBar(context: context, message: 'submitted_report'.tr);
        }
        return true;
      } else {
        FlashHelper.errorBar(context: context, message: 'error_connection'.tr);
        return false;
      }
    } catch(e) {
      LoadingDialog.hide(context: context);
      FlashHelper.errorBar(context: context, message: '$e');
      return false;
    }
  }

  Future<bool> blockAccount(BuildContext context, UserModel user) async {
    try {
      if (networkState.isConnected) {
        return await showDialog(context: context, builder: (context) {
          return AlertDialog(
              title: Text('block'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                    color: headlineColor,
                    fontSize: 16
                ),
              ),
              content: Text('msg_block'.trArgs([user.displayName]),
                style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.normal,
                    fontSize: 14
                ),
              ),
              actions: [
                TextButton(
                  child: Text('cancel'.tr,
                    style: GoogleFonts.notoSans(
                        fontWeight: FontWeight.normal,
                        color: headlineColor,
                        fontSize: 14
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),

                TextButton(
                  child: Text('block'.tr,
                    style: GoogleFonts.notoSans(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 14
                    ),
                  ),
                  onPressed: () async {
                    unfollowUser(userId: user.uid);
                    await usersRef.doc(user.uid)
                        .collection(Keys.blockedUsers).doc(user.uid).set({
                      "uid": user.uid, 'timestamp': FieldValue.serverTimestamp(),
                    }, SetOptions(merge: true));
                    if (context.mounted) {
                      Navigator.pop(context, true);
                      FlashHelper.successBar(context: context, message: 'completed_success'.tr);
                    }
                  },
                ),
              ]);
        }) ?? false;
      } else {
        FlashHelper.errorBar(context: context, message: 'error_connection'.tr);
        return false;
      }
    } catch(e) {
      LoadingDialog.hide(context: context);
      FlashHelper.errorBar(context: context, message: '$e');
      return false;
    }
  }

  ///! ------------------- Follow and Following -------------------
  Future<void> followUser({required String userId, String? receiverToken}) async {
    // Add user to current user's following collection

    await followingRef.doc(state.user!.uid)
        .collection(Keys.userFollowing)
        .doc(userId)
        .set({'timestamp': FieldValue.serverTimestamp()},
        SetOptions(merge: true)
    );

    // Add current user to user's followers collection
    await followersRef.doc(userId)
        .collection(Keys.userFollowers)
        .doc(state.user!.uid)
        .set({'timestamp': FieldValue.serverTimestamp()},
        SetOptions(merge: true)
    );

    PostModel post = PostModel(
      uid: userId,
      idVisibility: 0,
      isBanned: false,
      content: '0',
      timestamp: FieldValue.serverTimestamp(),
      isArchive: false,
      idTypesPost: 0,
      id: '0',
    );

    addActivityItem(
      comment: null,
      currentUserId: state.user!.uid,
      isFollowEvent: true,
      post: post,
      isCommentEvent: false,
      isLikeEvent: false,
      isLikeMessageEvent: false,
      isMessageEvent: false,
      receiverToken: receiverToken,
    );
  }

  Future<void> unfollowUser({required String userId}) async {
    // Remove user from current user's following collection
    await followingRef.doc(state.user!.uid)
        .collection(Keys.userFollowing)
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // Remove current user from user's followers collection
    await followersRef.doc(userId)
        .collection(Keys.userFollowers)
        .doc(state.user!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    PostModel post = PostModel(
      uid: userId,
      idVisibility: 0,
      isBanned: false,
      content: '0',
      timestamp: FieldValue.serverTimestamp(),
      isArchive: false,
      idTypesPost: 0,
      id: '0',
    );

    deleteActivityItem(
      comment: null,
      currentUserId: state.user!.uid,
      isFollowEvent: true,
      post: post,
      isCommentEvent: false,
      isLikeEvent: false,
      isLikeMessageEvent: false,
      isMessageEvent: false,
    );
  }

  void setFollowingState(bool val, [bool listen = true]) {
    state.isFollowing = val;
    if (listen) {
      update();
    }
  }

  Future<bool> isFollowingUser({required String uid}) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(uid)
        .collection(Keys.userFollowers)
        .doc(auth.currentUser!.uid)
        .get();

    return followingDoc.exists;
  }

  void updateStateFollowing(bool val) {
    state.isFollowing = val;
    update();
  }

  updateFollowUser(UserModel user) {

  }

  Future<void> uploadPhotoProfile(File data) async {
    try {
      if (networkState.isConnected) {
        utilsLogic.showSnack(
          type: SnackBarType.success,
          title: 'photo_profile'.tr,
          message: 'uploading_photo'.tr,
        );

        final photoProfile = state.user?.photoProfile;
        if (photoProfile != null) {
          await _deletePhotoProfile(photoProfile);
        }

        String dir = dirname(data.path);
        String newPath = join(dir, '${state.user!.uid}.jpg');
        final file = data.renameSync(newPath);

        String name = basename(file.path);
        String? typeImage = mime(name);

        logger.i('typeImage: $typeImage');

        // DocumentReference reference = usersRef.doc(state.user!.uid);
        final refStorage = '${Keys.users}/${state.user!.uid}/$name';
        final ref = storage.ref(refStorage);
        final metadata = SettableMetadata(
          contentType: '$typeImage',
          customMetadata: {'picked-file-path': file.path},
        );

        TaskSnapshot snapshot = await ref.putFile(file, metadata);
        final url = await snapshot.ref.getDownloadURL();
        final model = state.user?.copyWith(photoProfile: url);
        if (model != null) await updateCurrentUser(model);
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected,
        );
      }
    } on FirebaseException catch (e) {
      logger.e("Failed with error '${e.code}': ${e.message}");
      utilsLogic.showSnack(
        type: SnackBarType.error,
        title: 'photo_profile'.tr,
        message: '${e.message}',
      );
    } catch (e) {
      logger.e("Failed with error '$e'");
      utilsLogic.showSnack(
        type: SnackBarType.error,
        title: 'photo_profile'.tr,
        message: '$e',
      );
    }
  }

  Future<void> _deletePhotoProfile(String url) async {
    try {
      var fileUrl = Uri.decodeFull(basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');
      return await storage.ref(fileUrl).delete();
    } on FirebaseException catch (e) {
      logger.e("Failed with error '${e.code}': ${e.message}");
    } catch (e) {
      logger.e('error: $e');
      return;
    }
  }

  Future<bool> updateAge(DateTime dateBirth) async {
    try {
      logger.v('updateAge: $dateBirth');
      final uid = state.user!.uid;
      await usersRef.doc(uid).update({'dateBirth': dateBirth});
      state.user = await getUserById(uid);
      update();
      return true;
    } catch(e) {
      logger.e(e);
      return false;
    }
  }

  Future<void> updateInfo({
    required BuildContext context,
    required UserModel user
  }) async {
    try {

      LoadingDialog.show(context: context);
      final url = '$baseUrlApi/v1/user/update/${auth.currentUser?.uid}';
      final response = await apiClient.putData(
        url: url, data: user.toJson(),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        updateUser(UserModel.fromJson(jsonResponse['user']));
      }

      if (context.mounted) LoadingDialog.hide(context: context);
    } on ServerException catch (failure) {
      if (context.mounted) LoadingDialog.hide(context: context);
      logger.e('error: ${failure.message}');
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: failure.message,
      );
    }
  }

  void updateUser(UserModel model) async {
    state.user = model;
    update();
  }

  Future<String?> getIdToken() async {
    return await auth.currentUser?.getIdToken();
  }

  Future<Either<Failure, UserModel>> initApp() async {
    try {
      String? uid = auth.currentUser?.uid;
      await networkLogic.hasConnection();
      if (networkState.isConnected) {
        if (uid != null) {
          final user = await getUserById(uid);
          state.user = user;
          update();
          // await getConfigs(user.uid);
          await checkTimeServer();
          await updateUserToken(token: NotificationController.firebaseAppToken);
          return Right(user);
        } else {
          return Left(NoDataFailure(
            message: 'logout'.tr,
            state: RequestState.logout,
          ));
        }
      } else {
        return Left(NetworkFailure(
          message: 'error_connection'.tr,
          state: RequestState.network,
        ));
      }
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        message: failure.message,
        state: failure.state,
      ));
    }
  }

  Future<void> updateCurrentUser(UserModel model) async {
    try {
      final response = await apiClient.putData(
        url: '$baseUrlApi/v1/user/update/${model.uid}',
        data: model.toJson(),
      );
      logger.v('updateCurrentUser: ${response.statusCode}\n${response.body}');
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        updateUser(UserModel.fromJson(jsonResponse['user']));
      }
    } on ServerException catch (failure) {
      logger.e('error: ${failure.message}');
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: failure.message,
      );
    }
  }

  Future<void> updateUserToken({String? token}) async {
    try {
      final response = await apiClient.postData(
        url: '$baseUrlApi/v1/user/update-token',
        data: {
          'token': token,
          'uid': auth.currentUser?.uid,
          'lastSeen': DateTime.now().toIso8601String(),
        },
      );
      logger.v('updateToken: ${response.statusCode}\n${response.body}');
    } on ServerException catch (failure) {
      throw ServerFailure(
        state: RequestState.error,
        message: failure.message,
      );
    }
  }

  Future<void> checkTimeServer() async {
    try {
      if (networkState.isConnected) {
        const url = "$baseUrl/getTimeServer";
        final response = await apiClient.getData(url: url);
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
          final seconds = jsonResponse['timestamp']['_seconds'];
          state.timeServer = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
          update();
        }
      }
    } on ServerException catch (failure) {
      logger.e('error: ${failure.message}');
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: failure.message,
      );
    }
  }

}