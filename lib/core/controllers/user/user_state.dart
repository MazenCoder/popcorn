import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'package:get/get.dart';


class UserState {


  //! Current User
  UserModel? user;
  String? idToken;

  late RxBool loading;
  late bool isFollowing;

  /// ------  User Post ------
  late RxList<Widget> userPosts;
  late RxBool isMoorePostAvailable;
  DocumentSnapshot? _lastPostDocument;

  late DateTime timeServer;

  UserState() {
    loading = false.obs;
    isFollowing = false;
    userPosts = <Widget>[].obs;
    isMoorePostAvailable = true.obs;
    timeServer = DateTime.now();
  }
}
