import '../../features/network/presentation/widgets/card_followers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../theme/generateMaterialColor.dart';
import '../usecases/constants.dart';
import '../util/flash_helper.dart';
import '../models/user_model.dart';
import '../usecases/keys.dart';
import 'package:get/get.dart';




class FollowersController extends GetxController {
  static FollowersController instance = Get.find();


  /// ------  Followers ------
  RxList<Widget> cardFollowers = <Widget>[].obs;
  RxBool isMooreAvailable = true.obs;
  DocumentSnapshot? _lastDocument;
  RxInt followersNbr = 0.obs;
  RxBool loading = false.obs;



  Future<void> getNbrFollowers({required String uid, bool listener = false}) async {
    QuerySnapshot followersSnapshot = await followersRef
        .doc(uid).collection(Keys.userFollowers).get();

    setFollowersNbr(length: followersSnapshot.docs.length, listener: listener);
    // return followersSnapshot.docs.length;
  }

  Future<List<String>> getFollowersIds({required String uid, bool listener = false}) async {
    isMooreAvailable.value = true;
    QuerySnapshot followersSnapshot = await followersRef
        .doc(uid).collection(Keys.userFollowers)
        .limit(numLimit).get();

    if (followersSnapshot.docs.isEmpty) {
      isMooreAvailable.value = false;
      return [];
    }

    if (followersSnapshot.docs.length < numLimit) {
      isMooreAvailable.value = false;
    }

    _lastDocument = followersSnapshot.docs.last;

    List<String> followers = followersSnapshot.docs.map((doc) => doc.id).toList();
    return followers;
  }

  Future<void> getFollowers({required String uid, bool listener = false}) async {
    setLoadingState(load: true, listener: listener);
    cardFollowers.clear();

    List<String> followersUserIds = await getFollowersIds(uid: uid, listener: listener);

    for (var userId in followersUserIds) {
      UserModel? user = await userLogic.getUserById(userId);
      final isFollowed = await userLogic.isFollowingUser(uid: user!.uid);
      final isBlocked = await userLogic.isBlockedUser(uid: user.uid);
      if (!isBlocked) {
        final key = Key(user.uid);
        final card = CardFollowers(
          key: key, user: user,
          isFollowed: isFollowed,
        );
        cardFollowers.add(card);
      }
    }

    await getNbrFollowers(uid: uid, listener: listener);
    setLoadingState(load: false, listener: listener);
    logger.i('followers: ${cardFollowers.length}');
  }

  Future<List<String>> getMoreFollowersIds({required String uid, bool listener = false}) async {
    QuerySnapshot followersSnapshot = await followersRef
        .doc(uid)
        .collection(Keys.userFollowers)
        .startAfterDocument(_lastDocument!)
        .limit(numLimit)
        .get();

    if (followersSnapshot.docs.isEmpty) {
      isMooreAvailable.value = false;
      return [];
    }

    if (followersSnapshot.docs.length < numLimit) {
      isMooreAvailable.value = false;
    }

    List<String> followers = followersSnapshot.docs.map((doc) => doc.id).toList();
    return followers;
  }

  Future<void> getMoreFollowers({required BuildContext context, required String uid, bool listener = false}) async {
    logger.i('get More Followers');
    if (!isMooreAvailable.value || _lastDocument == null) return;
    try {

      List<String> followersUserIds = await getMoreFollowersIds(uid: uid, listener: listener);

      for (var userId in followersUserIds) {
        UserModel? user = await userLogic.getUserById(userId);
        if (user != null) {
          final isFollowed = await userLogic.isFollowingUser(uid: user.uid);
          final isBlocked = await userLogic.isBlockedUser(uid: user.uid);
          if (!isBlocked) {
            final key = Key(user.uid);
            final card = CardFollowers(
              key: key, user: user,
              isFollowed: isFollowed,
            );
            cardFollowers.add(card);
          }
        }

      }
    } catch(e) {
      logger.e('error: $e');
      FlashHelper.errorBar(context: context, message: '$e');
    }
  }


  void setFollowersNbr({required int length, bool listener = false}) {
    followersNbr.value = length;
    if (listener) {
      update();
    }
  }

  void updateUnfollowUserNbr() {
    if (followersNbr.value > 0) {
      followersNbr--;
      update();
    }
  }

  void updateFollowUserCount() {
    followersNbr++;
    update();
  }

  void setLoadingState({required bool load, bool listener = false}) {
    loading.value = load;
    if (listener) {
      update();
    }
  }



  Future<void> updateCard(UserModel user) async {
    try {
      if (cardFollowers.isEmpty) return;
      final isFollowed = await userLogic.isFollowingUser(uid: user.uid);
      final isBlocked = await userLogic.isBlockedUser(uid: user.uid);
      if (!isBlocked) {
        final key = Key(user.uid);
        final index = cardFollowers.indexWhere((element) => element.key == key);
        if (index != -1) {
          cardFollowers.removeAt(index);
        }

        final card = CardFollowers(
          key: key, user: user,
          isFollowed: isFollowed,
        );
        cardFollowers.add(card);
        update();
      }
    } catch(e) {
      logger.e(e);
    }
  }

  Future<void> removeFollowerDialog(BuildContext context, UserModel user) async {
    await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('remove_follower'.tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
            color: headlineColor,
            fontSize: 16
          ),
        ),
        content: Text('msg_remove_follower'.trArgs([user.displayName]),
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
            child: Text('remove'.tr),
            onPressed: () async {
              removeFollower(user);
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  Future<void> removeFollower(UserModel user) async {
    await followingRef.doc(user.uid)
        .collection(Keys.userFollowing)
        .doc(userState.user!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // Remove current user from user's followers collection
    await followersRef.doc(userState.user!.uid)
        .collection(Keys.userFollowers)
        .doc(user.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    if (cardFollowers.isEmpty) return;

    final index = cardFollowers.indexWhere((element) => element.key == Key(user.uid));
    if (index != -1) {
      cardFollowers.removeAt(index);
    }
    updateUnfollowUserNbr();
  }

}