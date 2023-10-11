import 'package:popcorn/features/rooms/models/room_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/models/user_model.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/usecases/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'card_shimmer_room.dart';
import 'package:get/get.dart';



class ForumsRoom extends StatefulWidget {
  final UserModel user;
  final bool isNew;
  final bool descending;
  final SearchFrom searchFrom;

  const ForumsRoom({Key? key,
    required this.user,
    required this.isNew,
    required this.searchFrom,
    this.descending = true,
  }) : super(key: key);

  @override
  State<ForumsRoom> createState() => _ForumsRoomState();
}

class _ForumsRoomState extends State<ForumsRoom> {

  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final FocusNode inputNode = FocusNode();


  Stream<List<RoomModel>> getRooms() async* {
    List<RoomModel> dataToReturn = [];
    Stream<QuerySnapshot> stream = roomsRef
        .orderBy('timestamp', descending: widget.descending)
        .snapshots();

    await for (QuerySnapshot q in stream) {
      for (QueryDocumentSnapshot document in q.docs) {
        final json = document.data() as Map<String, dynamic>;
        RoomModel chatFromDoc = RoomModel.fromJson(json);
        List<dynamic> memberIds = chatFromDoc.memberIds!;
        logger.i('memberIds: $memberIds');
        List<UserModel> membersInfo = [];
        for (var userId in memberIds)  {
          final doc = await usersRef.doc(userId).get();
          final json = doc.data() as Map<String, dynamic>;
          final receiverUser = UserModel.fromJson(json);
          membersInfo.add(receiverUser);
        }

        RoomModel chatWithUserInfo = RoomModel(
          id: chatFromDoc.id,
          uid: chatFromDoc.uid,
          name: chatFromDoc.name,
          description: chatFromDoc.description,
          memberIds: chatFromDoc.memberIds,
          memberInfo: membersInfo,
          idRoom: chatFromDoc.idRoom,
          photoRoom: chatFromDoc.photoRoom,
          readStatus: chatFromDoc.readStatus,
          recentMessage: chatFromDoc.recentMessage,
          recentSender: chatFromDoc.recentSender,
          welcomeMessage: chatFromDoc.welcomeMessage,
          timestamp: chatFromDoc.timestamp,
          status: chatFromDoc.status,
        );

        dataToReturn.removeWhere((chat) => chat.id == chatWithUserInfo.id);

        dataToReturn.add(chatWithUserInfo);
      }
      yield dataToReturn;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (roomState.loading.value) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return const CardShimmerRoom();
            },
          );
        } else {
          return SmartRefresher(
            controller: refreshController,
            header: const WaterDropHeader(),
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              await roomLogic.initNewRooms(true);
              return refreshController.refreshCompleted();
            },
            onLoading: () async {
              await roomLogic.getMoreNewRooms(false);
              return refreshController.loadComplete();
            },
            footer: CustomFooter(
              builder: (context, mode) {
                Widget body;
                if (roomState.loading.value) {
                  body =  const CupertinoActivityIndicator();
                } else if (!roomState.isMooreAvailable.value) {
                  body = Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 0),
                    child: Text("no_more_posts".tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else if (mode == LoadStatus.idle) {
                  body =  Text("pull_up_load".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                } else if (mode == LoadStatus.loading) {
                  body =  const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("load_failed".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("pull_refresh".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                } else {
                  body = Text("no_more_posts".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                  );
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 5, bottom: 8),
              itemCount: roomState.rooms.length,
              itemBuilder: (context, index) {
                return roomState.rooms[index];
              },
            ),
          );
        }
      }),
      /*
      body: StreamBuilder<List<RoomModel>>(
        stream: getRooms(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.waiting: return const Center(
              child: CircularProgressIndicator(),
            );
            default:
              if (snapshot.hasError || !snapshot.hasData) {
                return Container();
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                itemBuilder: (BuildContext context, int index) {
                  final room = snapshot.data![index];
                  return CardRoom(room: room);
                },
                itemCount: snapshot.data?.length??0,
              );
          }
        },
      ),
      */
    );
  }
}
