import '../../features/network/presentation/widgets/card_following.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../theme/generateMaterialColor.dart';
import '../usecases/constants.dart';
import '../util/flash_helper.dart';
import '../models/user_model.dart';
import '../usecases/keys.dart';
import 'package:get/get.dart';




class FollowingController extends GetxController {

  static FollowingController instance = Get.find();

  /// ------  Followers ------
  RxList<Widget> cardFollowing = <Widget>[].obs;
  RxBool isMooreAvailable = true.obs;
  DocumentSnapshot? _lastDocument;
  RxInt followingNbr = 0.obs;
  RxBool loading = false.obs;


  Future<void> getNbrFollowing({required String uid, bool listener = false}) async {
    QuerySnapshot followingSnapshot = await followingRef
        .doc(uid).collection(Keys.userFollowing).get();

    setFollowingNbr(length: followingSnapshot.docs.length, listener: listener);
    // return followingSnapshot.docs.length;
  }

  void setFollowingNbr({required int length, bool listener = false}) {
    followingNbr.value = length;
    if (listener) {
      update();
    }
  }


  Future<List<String>> getUserFollowingIds(String uid) async {
    isMooreAvailable.value = true;
    QuerySnapshot followingSnapshot = await followingRef
        .doc(uid).collection(Keys.userFollowing)
        .limit(numLimit)
        .get();

    if (followingSnapshot.docs.isEmpty) {
      isMooreAvailable.value = false;
      return [];
    }

    if (followingSnapshot.docs.length < numLimit) {
      isMooreAvailable.value = false;
    }

    _lastDocument = followingSnapshot.docs.last;

    List<String> following = followingSnapshot.docs.map((doc) => doc.id).toList();
    return following;
  }

  Future<void> getFollowing({required String uid, bool listener = false}) async {
    setLoadingState(load: true, listener: listener);
    cardFollowing.clear();

    List<String> followingUserIds = await getUserFollowingIds(uid);

    for (var userId in followingUserIds) {
      UserModel? user = await userLogic.getUserById(userId);
      if (user != null) {
        final isFollowed = await userLogic.isFollowingUser(uid: user.uid);
        final isBlocked = await userLogic.isBlockedUser(uid: user.uid);
        if (!isBlocked) {
          final key = Key(user.uid);
          final card = CardFollowing(
            key: key, user: user,
            isFollowed: isFollowed,
          );
          cardFollowing.add(card);
        }
      }
    }

    await getNbrFollowing(uid: uid, listener: listener);
    setLoadingState(load: false, listener: listener);
    logger.i('following: ${cardFollowing.length}');
  }


  Future<List<String>> getMoreFollowingIds({required String uid, bool listener = false}) async {
    QuerySnapshot snapshot = await followingRef
        .doc(uid)
        .collection(Keys.userFollowing)
        .startAfterDocument(_lastDocument!)
        .limit(numLimit)
        .get();

    if (snapshot.docs.isEmpty) {
      isMooreAvailable.value = false;
      return [];
    }

    if (snapshot.docs.length < numLimit) {
      isMooreAvailable.value = false;
    }

    List<String> followers = snapshot.docs.map((doc) => doc.id).toList();
    return followers;
  }

  Future<void> getMoreFollowing({required BuildContext context, required String uid, bool listener = false}) async {
    logger.i('get More Followers');
    if (!isMooreAvailable.value || _lastDocument == null) return;
    try {

      List<String> followingUserIds = await getMoreFollowingIds(uid: uid, listener: listener);

      for (var userId in followingUserIds) {
        UserModel? user = await userLogic.getUserById(userId);
        if (user != null) {
          final isFollowed = await userLogic.isFollowingUser(uid: user.uid);
          final isBlocked = await userLogic.isBlockedUser(uid: user.uid);
          if (!isBlocked) {
            final key = Key(user.uid);
            final card = CardFollowing(
              key: key, user: user,
              isFollowed: isFollowed,
            );
            cardFollowing.add(card);
          }
        }
      }
    } catch(e) {
      logger.e('error: $e');
      FlashHelper.errorBar(context: context, message: '$e');
    }
  }


  void setLoadingState({required bool load, bool listener = false}) {
    loading.value = load;
    if (listener) {
      update();
    }
  }

  updateFollowUser(UserModel user) async {
    final isFollowed = await userLogic.isFollowingUser(uid: user.uid);
    final isBlocked = await userLogic.isBlockedUser(uid: user.uid);
    if (!isBlocked) {
      final key = Key(user.uid);
      final card = CardFollowing(
        key: key, user: user,
        isFollowed: isFollowed,
      );
      cardFollowing.add(card);
      _updateFollowUserNbr();
    }
  }

  updateUnfollowUser(UserModel user) async {
    if (cardFollowing.isNotEmpty) {
      final index = cardFollowing.indexWhere((element) => element.key == Key(user.uid));
      if (index != -1) {
        cardFollowing.removeAt(index);
      }
      _updateUnfollowUserNbr();
    }
  }

  void _updateFollowUserNbr() {
    followingNbr++;
    update();
  }

  void _updateUnfollowUserNbr() {
    if (followingNbr.value > 0) {
      followingNbr--;
      update();
    }
  }


  Future<void> unFollowDialog(BuildContext context, UserModel user) async {
    await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('unfollow'.tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.bold,
              color: headlineColor,
              fontSize: 16
          ),
        ),
        content: Text('msg_unfollow'.trArgs([user.displayName]),
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.normal,
              fontSize: 14
          ),
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Navigator.pop(context),
          ),

          TextButton(
            child: Text('unfollow'.tr),
            onPressed: () async {
              await userLogic.unfollowUser(userId: user.uid);
              updateUnfollowUser(user);
              followersController.updateCard(user);
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

}