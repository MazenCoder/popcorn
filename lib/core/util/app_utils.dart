import 'package:popcorn/core/models/message_group_model.dart';
import 'package:popcorn/core/models/category_model.dart';
import 'package:popcorn/core/models/message_model.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import 'package:popcorn/core/models/chat_model.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';




abstract class AppUtils {

  Future<void> changeDialog(BuildContext context);
  String accountCreateAt(UserModel account);
  Future<void> likeUnlikeMessage(Message message, String chatId,
      bool isLiked, UserModel receiverUser, String currentUserId);
  String parseTimestamp(dynamic timestamp);
  Future<void> logOut(BuildContext context);
  Future<void> removeToken();
  Future<File?> croppedFile(File file);
}
