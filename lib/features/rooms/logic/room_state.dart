// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/user_model.dart';
import 'package:flutter/material.dart';
import '../models/speak_model.dart';
import 'package:get/get.dart';


class RoomState {

  late int numberPage;
  late RxList<UserModel> receiverUsers;
  late RxMap<int, SpeakerModel> speakers;
  // late RxList<SpeakerModel> usersJoined;
  late Widget? myRoom;
  late RxList<Widget> rooms;
  DocumentSnapshot? lastDocument;
  late RxBool isMooreAvailable;
  late RxBool loading;

  late bool loadingMyRoom;
  late RxBool enableSpeakerphone;
  late RxBool openMicrophone;
  late RxBool playEffect;
  // late RtcEngine engine;
  // late RxBool isJoined;
  late RxBool micUsing;
  late RxBool isMuted;
  late RxBool joined;

  RoomState() {
    numberPage = 1;
    receiverUsers = <UserModel>[].obs;
    speakers = <int, SpeakerModel>{}.obs;
    rooms = <Widget>[].obs;
    myRoom = null;
    lastDocument = null;
    // engine = createAgoraRtcEngine();
    isMooreAvailable = false.obs;
    loading = false.obs;
    loadingMyRoom = false;
    enableSpeakerphone = false.obs;
    openMicrophone = false.obs;
    playEffect = false.obs;
    // usersJoined = <SpeakerModel>[].obs;
    // volumeHigh = false.obs;
    // isJoined = false.obs;
    micUsing = false.obs;
    joined = false.obs;
    isMuted = false.obs;
  }
}
