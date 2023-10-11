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
  // Future<String?> uploadImageRoom(BuildContext context, File image);
  Future<void> updateToken(UserCredential currentUser);
  Future<UserCredential?> signInWithEmailAndPass({required BuildContext context, required String email, required String pass});
  Future<UserCredential?> signInWithGoogle();
  Future<UserCredential?> signInWithFacebook();
  Future<UserCredential?> signInWithApple();
  Future<void> resetPassword(BuildContext context, String email);
  Future<UserCredential?> createAccount({required BuildContext context, required UserModel model});
  // Future<UserModel?> getUserById(String uid);
  // Future<Chat?> getChatByUsers(List<String> users);
  // void setChatRead(BuildContext context, Chat chat, bool read);
  // Future<Chat> createChat(List<UserModel> users, List<String> userIds);
  // Future<String?> uploadMessageImage(File imageFile);
  // void sendChatMessage(Chat chat, Message message, UserModel receiverUser);
  // void sendChatGroupMessage({
  //   required MessageGroup message,
  //   required List<UserModel> receiverUser,
  //   required RoomModel lounge,
  // });
  // void setChatGroupRead(BuildContext context, RoomModel lounges, bool read);
  Future<void> likeUnlikeMessage(Message message, String chatId,
      bool isLiked, UserModel receiverUser, String currentUserId);
  String parseTimestamp(dynamic timestamp);
  Future<void> logOut(BuildContext context);
  Future<void> removeToken();
  Future<File?> croppedFile(File file);
  // Future<String> startDirectCharge(BuildContext context, PaymentMethod paymentMethod, double costPrice);
}
