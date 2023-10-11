import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:popcorn/core/models/message_group_model.dart';
import 'package:popcorn/core/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mime_type/mime_type.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import '../../usecases/constants.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'chat_state.dart';
import 'dart:io';



class ChatLogic extends GetxController {
  static ChatLogic instance = Get.find();
  final state = ChatState();


  Future<Chat?> getChatById(String chatId) async {
    DocumentSnapshot chatDocSnapshot = await chatsRef.doc(chatId).get();
    if (chatDocSnapshot.exists) {
      return Chat.fromDoc(chatDocSnapshot);
    }
    return null;
  }


  Future<void> setChatRead({required Chat chat, required bool read}) async {
    String currentUserId = auth.currentUser!.uid;
    return chatsRef.doc(chat.id).update({
      'readStatus.$currentUserId': read,
    });
  }

  Future<void> setAcceptStatus({required String chatId, required String currentUserId, required bool state}) async {
    return chatsRef.doc(chatId).update({
      'acceptStatus.$currentUserId': state,
    });
  }


  Future<Chat> createChat(List<UserModel> users, List<String> userIds) async {
    Map<String, dynamic> readStatus = {};
    Map<String, dynamic> acceptStatus = {};

    for (UserModel user in users) {
      readStatus[user.uid] = false;

      if (user.uid == userState.user?.uid) {
        acceptStatus[user.uid] = true;
      } else {
        acceptStatus[user.uid] = false;
      }
    }

    DocumentReference res = await chatsRef.add({
      'recentMessage': 'Chat Created',
      'recentSender': '',
      'recentTimestamp': FieldValue.serverTimestamp(),
      'memberIds': userIds,
      'readStatus': readStatus,
      'acceptStatus': acceptStatus,
    });

    return Chat(
      id: res.id,
      recentMessage: 'Chat Created',
      recentSender: '',
      recentTimestamp: FieldValue.serverTimestamp(),
      memberIds: userIds,
      readStatus: readStatus,
      memberInfo: users,
    );
  }

  Future<void> sendChatMessage({
    required Chat chat,
    required Message message,
    required UserModel receiverUser,
  }) async {
    final ref = chatsRef.doc(chat.id).collection('messages').doc(message.id);
    await ref.set(message.toJson());

    Map<String, dynamic> readStatus = {};

    readStatus[userState.user!.uid] = true;
    readStatus[receiverUser.uid] = false;

    chatsRef.doc(chat.id).update({
      "recentTimestamp": FieldValue.serverTimestamp(),
      "recentSender": auth.currentUser!.uid,
      "recentMessage": message.text,
      "readStatus": readStatus,
    });

    /*
    addActivityItem(
      comment: message.text,
      currentUserId: message.senderId,
      isCommentEvent: false,
      isFollowEvent: false,
      isLikeEvent: false,
      isMessageEvent: true,
      post: PostModel(authorId: receiverUser.uid),
      receiverToken: receiverUser.token,
    );
    */
  }

  Future<Chat?> getChatByUsers(List<String> users) async {
    QuerySnapshot snapshot = await chatsRef.where('memberIds', whereIn: [
      [users[1], users[0]]
    ]).get();

    if (snapshot.docs.isEmpty) {
      snapshot = await chatsRef.where('memberIds', whereIn: [
        [users[0], users[1]]
      ]).get();
    }

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> map = snapshot.docs.first.data() as Map<String, dynamic>;
      String id = snapshot.docs.first.id;
      return Chat.fromJson(id, map);
    }
    return null;
  }

  Future<String?> uploadMessageImage(File imageFile) async {
    String? downloadUrl = await _uploadChatImage(imageFile);
    return downloadUrl;
  }

  Future<String?> _uploadChatImage(File file) async {
    try {
      Uuid uuid = const Uuid();
      String name = basename(file.path);
      String? typeImage = mime(name);

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("chats/${uuid.v4()}/$name");
      firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
        contentType: '$typeImage',
        customMetadata: {'picked-file-path': file.path},
      );

      return await ref.putFile(file, metadata).then((firebase_storage.TaskSnapshot snapshot) async {
        return await snapshot.ref.getDownloadURL();
      });
    } catch (e) {
      logger.e('e: $e');
      return null;
    }
  }


  void sendChatGroupMessage({
    required MessageGroup message,
    required List<UserModel> receiverUser,
    required RoomModel lounge,
  }) async {
    final uuid = const Uuid().v4();
    final ref = roomsRef.doc(lounge.id).collection('messages').doc(uuid);

    await ref.set({
      'id': uuid,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'text': message.text,
      'imageUrl': message.imageUrl,
      'timestamp': message.timestamp,
      'isLiked': message.isLiked,
    });

    await roomsRef.doc(lounge.id).update({
      "recentTimestamp": FieldValue.serverTimestamp(),
      "recentSender": auth.currentUser!.uid,
      "recentMessage": message.text,
    });

    // addActivityItem(
    //   comment: message.text,
    //   currentUserId: message.senderId,
    //   isCommentEvent: false,
    //   isFollowEvent: false,
    //   isLikeEvent: false,
    //   isMessageEvent: true,
    //   post: PostModel(authorId: receiverUser!.uid),
    //   receiverToken: receiverUser.token,
    // );
  }


}