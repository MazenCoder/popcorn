import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:popcorn/features/rooms/widgets/card_room.dart';
import '../../../core/widgets_helper/gift_widget.dart';
import '../../../core/widgets_helper/loading_dialog.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/usecases/constants.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:popcorn/core/usecases/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mime_type/mime_type.dart';
import '../../../core/usecases/keys.dart';
import 'package:http/http.dart' as http;
// import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import '../models/speak_model.dart';
import '../widgets/create_room.dart';
import '../models/room_model.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'room_state.dart';
import 'dart:io';



class RoomLogic extends GetxController {
  static RoomLogic instance = Get.find();
  final state = RoomState();

  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //
  //   super.onReady();
  // }


  // void stateJoinedRoom(bool val) {
  //   state.isJoined.value = val;
  // }

  // void stateVolumeHigh(bool val) {
  //   state.volumeHigh.value = val;
  // }

  void userJoinedRoom(String idRoom, UserModel user) async {
    final model = SpeakerModel(
      uid: user.uid, uniqueKey: user.uniqueKey,
      volume: 0, photoProfile: user.photoProfile,
      isSpeaking: false,
    );
    await roomsRef.doc(idRoom).collection(Keys.users)
        .doc(user.uid).set(model.toJson(), SetOptions(merge: true));
  }

  void userLeftRoom({
    required String idRoom,
    required int remoteUid,
    required String uid
  }) async {
    removeUserFromRoom(remoteUid);
    await roomsRef.doc(idRoom).collection(Keys.users)
        .doc(uid).get().then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
    });
  }

  void stateMute(bool val) {
    state.isMuted.value = val;
  }

  void statePlayEffect(bool val) {
    state.playEffect.value = val;
  }

  void stateMicUse(bool val) {
    state.micUsing.value = val;
  }

  // final spaceRoom = SizedBox(
  //   width: Get.width-40,
  //   child: Card(
  //     child: ListTile(
  //       onTap: () => Get.to(() => const CreateRoom()),
  //       leading: const ClipOval(
  //         child: SizedBox(
  //           height: 40, width: 40,
  //           child: Icon(Icons.add),
  //         ),
  //       ),
  //       trailing: const Icon(Icons.flag),
  //       title: Text('create_my_room'.tr,
  //       ),
  //       subtitle: Text('start_journey'.tr),
  //     ),
  //   ),
  // );

  ///! ------------------- Rooms By Uid -------------------
  Future<RoomModel?> getRoomsByUid({required String uid}) async {
    try {

      int status = roomLogic.getIdStatusRoom('actively'.tr);
      QuerySnapshot query = await roomsRef
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: status)
          .orderBy('timestamp', descending: true)
          .get();

      final doc = query.docs.first;
      if (doc.exists) {
        final json = doc.data() as Map<String, dynamic>;
        return RoomModel.fromJson(json);
      }
    } catch(e){
      logger.e(e);
    }
    return null;
  }

  Future initNewRooms([bool listener = false]) async {
    try {

      setLoadingState(load: listener);
      state.rooms.clear();
      state.isMooreAvailable.value = true;

      int status = roomLogic.getIdStatusRoom('actively'.tr);
      QuerySnapshot query = await roomsRef
          .where('status', isEqualTo: status)
          .orderBy('timestamp', descending: true)
          .limit(numLimit)
          .get();

      if (query.docs.isEmpty) {
        setAvailabilityState(isMoor: false);
        return;
      }

      if (query.docs.length < numLimit) {
        setAvailabilityState(isMoor: false);
      }

      lastDocument(query.docs.last);

      for (QueryDocumentSnapshot doc in query.docs) {
        if (doc.exists) {
          final json = doc.data() as Map<String, dynamic>;
          final room = RoomModel.fromJson(json);
          addRooms(room);
        }
      }

      if (listener) {
        setLoadingState(load: false);
      }

    } catch(e) {
      logger.e(e);
      if (listener) {
        setLoadingState(load: false);
      }
    }
  }

  Future<void> getMoreNewRooms([bool listener = false]) async {
    try {
      if (!state.isMooreAvailable.value || state.lastDocument == null) return;

      setLoadingState(load: listener);

      int status = roomLogic.getIdStatusRoom('actively'.tr);
      QuerySnapshot query = await roomsRef
          .where('status', isEqualTo: status)
          .orderBy('timestamp', descending: true)
          .limit(numLimit)
          .get();

      if (query.docs.isEmpty) {
        setAvailabilityState(isMoor: false);
        if (listener) {
          setLoadingState(load: false);
        }
        return;
      }

      if (query.docs.length < numLimit) {
        setAvailabilityState(isMoor: false);
      }

      lastDocument(query.docs.last);

      for (QueryDocumentSnapshot doc in query.docs) {
        if (doc.exists) {
          final json = doc.data() as Map<String, dynamic>;
          final room = RoomModel.fromJson(json);
          addRooms(room);
        }
      }

      if (listener) {
        setLoadingState(load: false);
      }

    } catch (e) {
      logger.e('error: $e');
      if (listener) {
        setLoadingState(load: false);
      }
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
    }
  }

  void lastDocument(QueryDocumentSnapshot<Object?> last) {
    state.lastDocument = last;
    update();
  }

  void setLoadingState({required bool load}) {
    state.loading.value = load;
  }

  void setAvailabilityState({required bool isMoor}) {
    state.isMooreAvailable.value = isMoor;
  }

  void addRooms(RoomModel room) {
    final key = Key(room.id);
    final card = state.rooms.firstWhereOrNull((element) => element.key == key);
    if (card == null) {
      state.rooms.add(CardRoom(room: room));
    }
  }


  /*
  Future<bool> createRoom(BuildContext context, RoomModel model) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        AgoraRtmClient? client = await AgoraRtmClient.createInstance(appId);
        if (model.photoRoom != null) {
          final url = await _uploadImage(File('${model.photoRoom}'), model.id);
          await roomsRef.doc(model.id).set(model.toJsonPhoto(url));
        } else {
          await roomsRef.doc(model.id).set(model.toJson());
        }
        await client.createChannel(model.id);
        await getRoomsByUid(uid: model.uid).then((room) async {
          if (room != null) {
            await getMyRoom();
            addRooms(room);
          }
        });
        LoadingDialog.hide(context: context);
        return true;
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected,
        );
        return false;
      }
    } catch(e) {
      LoadingDialog.hide(context: context);
      logger.e('$e');
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
      return false;
    }
  }
  */

  Future<bool> createRoom(BuildContext context, RoomModel model) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        if (model.photoRoom != null) {
          final url = await _uploadImage(File('${model.photoRoom}'), model.id);
          await roomsRef.doc(model.id).set(model.toJsonPhoto(url));
        } else {
          await roomsRef.doc(model.id).set(model.toJson());
        }
        await getRoomsByUid(uid: model.uid).then((room) async {
          if (room != null) {
            await getMyRoom();
            addRooms(room);
          }
        });
        LoadingDialog.hide(context: context);
        return true;
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected,
        );
        return false;
      }
    } catch(e) {
      LoadingDialog.hide(context: context);
      logger.e('$e');
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
      return false;
    }
  }

  Future<String> _uploadImage(File file, String roomId) async {
    String name = basename(file.path);
    String? typeImage = mime(name);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("rooms/$roomId");
    firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
      contentType: '$typeImage', customMetadata: {'picked-file-path': file.path},
    );
    return await ref.putFile(file, metadata).then((firebase_storage.TaskSnapshot snapshot) async {
      return await snapshot.ref.getDownloadURL();
    });
  }

  Future<bool> editRoom({
    required BuildContext context,
    required String id,
    required String name,
    required String description,
    required String? photoRoomUrl,
    required String? photoRoomPath,
  }) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        if (photoRoomPath != null) {
          if (photoRoomUrl != null) {
            await deletePhotoUrl(photoRoomUrl);
          }
          final url = await _uploadImage(File(photoRoomPath), id);
          await roomsRef.doc(id).update({
            'name': name,
            'description': description,
            'photoRoom': url,
          });
        } else {
          await roomsRef.doc(id).update({
            'name': name,
            'description': description,
          });
        }
        // await getRoomsByUid(uid: model.uid).then((room) async {
        //   if (room != null) {
        //     await getMyRoom();
        //     addRooms(room);
        //   }
        // });
        LoadingDialog.hide(context: context);
        return true;
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected,
        );
        return false;
      }
    } catch(e) {
      LoadingDialog.hide(context: context);
      logger.e('$e');
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
      return false;
    }
  }

  Future<void> deletePhotoUrl(String url) async {
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

  // void addUserToRoom(SpeakerModel model) {
  //   state.usersJoined.add(model);
  // }

  void removeUserFromRoom(int remoteUid) {
    if (checkUserIsJoined(remoteUid)) {
      state.speakers.removeWhere((key, value) => key == remoteUid);
    }
  }

  bool checkUserIsJoined(int remoteUid) {
    if (state.speakers.isEmpty) {
      return false;
    } else {
     return (state.speakers[remoteUid] != null);
    }
  }

  Future<void> getMyRoom() async {
    QuerySnapshot query = await roomsRef
        .where('uid', isEqualTo: userState.user!.uid)
        .where('status', isEqualTo: statusRoom.keys.first)
        .orderBy('timestamp', descending: true)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final json = doc.data() as Map<String, dynamic>;
      state.myRoom = CardRoom(room: RoomModel.fromJson(json));
      update();
    }
  }


  int getIdStatusRoom(String val) {
    return statusRoom.keys.firstWhere(
          (k) => statusRoom[k] == val,
      orElse: () => statusRoom.keys.last,
    );
  }

  void setStateSpeaker({
    required String roomId,
    required bool state, 
    required String uid,
  }) async {
    await roomsRef.doc(roomId).collection(Keys.users)
        .doc(uid).get().then((doc) {
          if (doc.exists) {
            doc.reference.update({'isSpeaking': state});
          }  
    });
  }

  void updateVolumeSpeaker({
    required String roomId,
    required bool state,
    required String uid,
  }) async {
    await roomsRef.doc(roomId).collection(Keys.users)
        .doc(uid).get().then((doc) {
      if (doc.exists) {
        doc.reference.update({'isSpeaking': state});
      }
    });
  }

  // void updateMicCard(int idx, Widget card) {
  //   state.micsCard[idx] = card;
  //   update();
  // }


  Future<void> sendGift(BuildContext context) async {
    late http.Response response;
    try {
      GiftWidget.show(context: context,
        url: 'https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true',
      );
      await Future.delayed(const Duration(seconds: 12));
      GiftWidget.hide(context: context);
      /*
      response = await http.post(
        Uri.parse('https://zego-example-server-nextjs.vercel.app/api/send_gift'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'app_id': yourAppID,
          'server_secret': yourServerSecret,
          'room_id': widget.roomID,
          'user_id': localUserID,
          'user_name': 'user_$localUserID',
          'gift_type': 1001,
          'gift_count': 1,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      if (response.statusCode == 200) {
        // When the gift giver calls the gift interface successfully,
        // the gift animation can start to be displayed
        GiftWidget.show(context: context,
          url: 'https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true',
        );
      }
       */

    } on Exception catch (error) {
      debugPrint("[ERROR], store fcm token exception, ${error.toString()}");
    }
  }

}