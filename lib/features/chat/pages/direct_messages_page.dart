import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/theme/generateMaterialColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/chat_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/usecases/enums.dart';
import 'package:flutter/material.dart';
import '../../../core/util/img.dart';
import 'package:lottie/lottie.dart';
import 'chat_screen_page.dart';
import 'package:get/get.dart';
import 'dart:async';




class DirectMessagesPage extends StatefulWidget {
  final SearchFrom searchFrom;
  final UserModel currentUser;

  const DirectMessagesPage({Key? key,
    this.searchFrom = SearchFrom.messagesScreen,
    required this.currentUser}) : super(key: key);

  @override
  _DirectMessagesPageState createState() => _DirectMessagesPageState();
}

class _DirectMessagesPageState extends State<DirectMessagesPage> {

  late Stream<List<Chat>> chatsStream;

  Stream<List<Chat>> getChats() async* {
    List<Chat> dataToReturn = [];

    Stream<QuerySnapshot> stream = chatsRef
        .orderBy('recentTimestamp', descending: true)
        .where('memberIds', arrayContains: widget.currentUser.uid)
        .snapshots();


    await for (QuerySnapshot q in stream) {
      for (QueryDocumentSnapshot document in q.docs) {
        Map<String, dynamic> map = document.data() as Map<String, dynamic>;
        String id = document.id;
        Chat chatFromDoc = Chat.fromJson(id, map);
        // Chat chatFromDoc = Chat.fromDoc(document);
        List<dynamic> memberIds = chatFromDoc.memberIds;
        late int receiverIndex;

        // Getting receiver index
        for (var userId in memberIds) {
          if (userId != userState.user?.uid) {
            receiverIndex = memberIds.indexOf(userId);
          }
        }

        List<UserModel> membersInfo = [];

        final doc = await usersRef.doc(memberIds[receiverIndex]).get();
        final json = doc.data() as Map<String, dynamic>;
        final receiverUser = UserModel.fromJson(json);
        membersInfo.add(widget.currentUser);
        membersInfo.add(receiverUser);

        Chat chatWithUserInfo = Chat(
          id: chatFromDoc.id,
          memberIds: chatFromDoc.memberIds,
          memberInfo: membersInfo,
          readStatus: chatFromDoc.readStatus,
          recentMessage: chatFromDoc.recentMessage,
          recentSender: chatFromDoc.recentSender,
          recentTimestamp: chatFromDoc.recentTimestamp,
          acceptStatus: chatFromDoc.acceptStatus,
        );

        dataToReturn.removeWhere((chat) => chat.id == chatWithUserInfo.id);

        dataToReturn.add(chatWithUserInfo);
      }
      yield dataToReturn;
    }
  }

  _buildChat(Chat chat, String currentUserId) {
    List<UserModel> users = chat.memberInfo;
    int receiverIndex = users.indexWhere((user) => user.uid != currentUserId);
    int senderIndex = users.indexWhere((user) => user.uid == currentUserId);
    if (widget.searchFrom == SearchFrom.createStoryScreen) {
      return ListTile(
        leading: SizedBox(
          height: 50, width: 50,
          child: chatCircleAvatar(users[receiverIndex]),
        ),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            getUsername(user: users[receiverIndex],
              // maxLines: 1,
              // style: GoogleFonts.notoSans(
              //   color: Colors.white,
              //   fontSize: 14,
              // ),
            ),
            const SizedBox(width: 4),
            // LevelUser(user: users[receiverIndex]),
            // UserBadges(user: users[receiverIndex]),
          ],
        ),
        trailing: TextButton(
          child: Text('send'.tr,
            // style: GoogleFonts.notoSans(
            //   color: subHeadlineColor,
            // ),
          ),
          onPressed: () => {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (_) => ChatScreenPage(
                  receiverUser: users[receiverIndex],
                  currentUser: users[senderIndex],
                  // imageFile: widget.imageFile,
                ),
              ),
            ),
          },
        ),
      );
    }
    return InkWell(
      onTap: () {
        if (chat.acceptStatus[currentUserId]) {
          Get.to(() => ChatScreenPage(
            receiverUser: users[receiverIndex],
            currentUser: users[senderIndex],
          ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50, width: 50,
              child: chatCircleAvatar(users[receiverIndex], 28),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      getUsername(user: users[receiverIndex]),
                      const SizedBox(width: 4),
                      // LevelUser(user: users[receiverIndex]),
                      // UserBadges(user: users[receiverIndex]),
                    ],
                  ),

                  if (!chat.acceptStatus[currentUserId])
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft),
                      label: Text('accept_chat'.tr),
                      icon: Icon(
                        MdiIcons.checkboxMarkedCircleOutline,
                        color: primaryColor,
                      ),
                      onPressed: () => chatLogic.setAcceptStatus(
                        currentUserId: users[senderIndex].uid,
                        chatId: chat.id,
                        state: true,
                      ),
                    )
                  else ...[
                    chat.recentSender.isEmpty ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text('chat_created'.tr,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chat.recentSender == users[senderIndex].uid)
                          chat.readStatus[users[receiverIndex].uid] ?
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(MdiIcons.checkAll, size: 18, color: primaryColor),
                          ) : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(MdiIcons.checkAll, size: 18, color: Colors.grey),
                          ),
                      ],
                    ) : chat.recentMessage != null ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Text(chat.recentMessage!,
                              overflow: TextOverflow.ellipsis,
                            )),

                        if (chat.recentSender == users[senderIndex].uid)
                          chat.readStatus[users[receiverIndex].uid] ?
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(MdiIcons.checkAll, size: 18, color: primaryColor),
                          ) : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(MdiIcons.checkAll, size: 18, color: Colors.grey),
                          ),
                      ],
                    ) : Row(
                      children: [
                        Flexible(
                          child: Text('sent_attachment'.tr,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chat.recentSender == users[senderIndex].uid)
                          chat.readStatus[users[receiverIndex].uid] ?
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(
                              MdiIcons.checkAll,
                              size: 18, color: primaryColor,
                            )) : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(MdiIcons.checkAll, size: 18, color: Colors.grey),
                          ),
                      ],
                    ),

                    Text(chat.recentTimestamp != null ?
                    timeFormat.format(
                      chat.recentTimestamp.toDate(),
                    ) : '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(width: 5),
            StreamBuilder<DocumentSnapshot>(
              stream: iamonlineRef.doc(users[receiverIndex].uid).snapshots(),
              builder: (context, snapOnline) {
                switch(snapOnline.connectionState) {
                  case ConnectionState.waiting:
                    return const SizedBox.shrink();
                  default:
                    return Center(
                      child: checkOnline(
                        data: snapOnline.data,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                          height: 1,
                        ),
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Chat>>(
        stream: getChats(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.waiting: return const Center(
              child: CircularProgressIndicator(),
            );
            default:
              if (snapshot.hasError) {
                return const SizedBox.shrink();
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Lottie.asset(
                            IMG.jsonEmpty,
                            height: Get.height/3.2,
                          ),
                        ),
                        Text('no_msg_yet'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (BuildContext context, int index) {
                  Chat chat = snapshot.data![index];
                  return _buildChat(chat, widget.currentUser.uid);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(thickness: 1.0);
                },
                itemCount: snapshot.data?.length??0,
              );
          }
        },
      ),
    );
  }
}
