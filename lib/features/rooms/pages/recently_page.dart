import 'package:popcorn/features/rooms/widgets/card_room.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/usecases/keys.dart';
import 'package:flutter/material.dart';




class RecentlyPage extends StatelessWidget {
  const RecentlyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: usersRef.doc(auth.currentUser!.uid)
          .collection(Keys.recentlyRooms)
          .orderBy('timestamp', descending: true)
          .limit(12).snapshots(),
      builder: (context, snapRecently) {
        switch(snapRecently.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapRecently.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                itemCount: snapRecently.data?.docs.length?? 0,
                itemBuilder: (context, index) {
                  final idRoom = snapRecently.data!.docs[index].id;
                  return FutureBuilder<DocumentSnapshot>(
                    future: roomsRef.doc(idRoom).get(),
                    builder: (context, snapshot) {
                      switch(snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const SizedBox.shrink();
                        default:
                          if (snapshot.data?.exists??false) {
                            final doc = snapshot.data!.data();
                            final json = doc as Map<String, dynamic>;
                            return CardRoom(
                              room: RoomModel.fromJson(json),
                            );
                          }
                          return const SizedBox.shrink();
                      }
                    },
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
        }
      },
    );
  }
}
