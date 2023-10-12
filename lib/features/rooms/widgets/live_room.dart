import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:popcorn/packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:popcorn/features/rooms/widgets/room_info_fit.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import '../../../core/widgets_helper/gift_widget.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/usecases/enums.dart';
import 'package:flutter/material.dart';
import '../../../core/util/img.dart';
import 'package:get/get.dart';
import 'dart:async';




class LiveRoom extends StatefulWidget {
  final RoomModel room;
  const LiveRoom({Key? key, required this.room}) : super(key: key);

  @override
  State<LiveRoom> createState() => _LiveRoomState();
}

class _LiveRoomState extends State<LiveRoom> {

  late StreamSubscription<ZegoInRoomCommandReceivedData> subscriptions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subscriptions = ZegoUIKit().getInRoomCommandReceivedStream().listen(onInRoomCommandReceived);
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscriptions.cancel();
  }

  void onInRoomCommandReceived(ZegoInRoomCommandReceivedData commandData) {
    final user = userState.user!;
    debugPrint("onInRoomCommandReceived, fromUser:${commandData.fromUser}, command:${commandData.command}");
    // You can display different animations according to gift-type
    if (commandData.fromUser.id != '${user.uniqueKey}') {
      GiftWidget.show(context: context,
        url: 'https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true',
      );
    }
  }

  // if you use reliable message channel, you need subscription this method.
  // void onInRoomTextMessageReceived(List<ZegoSignalingInRoomTextMessage> messages) {
  //   final user = userState.user!;
  //   debugPrint("onInRoomTextMessageStream:$messages");
  //   // You can display different animations according to gift-type
  //   var message = messages.first;
  //   if (message.senderUserID != '${user.uniqueKey}') {
  //     GiftWidget.show(context: context,
  //       url: 'https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true',
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = userState.user!;
    return ZegoUIKitPrebuiltLiveAudioRoom(
      // room: widget.room,
      appSign: '8b6e715d1fe543076ef397e55fe0aef6b3e766947027786d3c2043368171a307',
      userID: '${user.uniqueKey}',
      userName: user.displayName,
      roomID: '${widget.room.idRoom}',
      appID: 698306505,
      // config: null,
      config: ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
        ..takeSeatIndexWhenJoining = -1
        ..background = background()
        ..hostSeatIndexes = getLockSeatIndex(LayoutMode.hostCenter)
        ..layoutConfig = getLayoutConfig(LayoutMode.defaultLayout)
        ..seatConfig = getSeatConfig(LayoutMode.defaultLayout)
        ..audioEffectConfig = ZegoAudioEffectConfig()
        ..seatConfig = ZegoLiveAudioRoomSeatConfig(
          avatarBuilder: (context, size, zegoUser, map) {
            if (zegoUser?.id == '${user.uniqueKey}') {
              return chatCircleAvatar(user, 25);
            }
            return chatCircleAvatar(null, 25);
          },
        )
        ..onLeaveConfirmation = (BuildContext context) async {
          return await utilsLogic.onLeaveConfirmation(context);
        }..seatConfig.avatarBuilder = (BuildContext context, Size size, ZegoUIKitUser? zegUser, Map extraInfo) {
          return (zegUser != null && user.photoProfile != null) ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    '${user.photoProfile}'
                ),
              ),
            ),
          ) : Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                    IMG.logo3,
                ),
              ),
            ),
          );
        }
    );
  }

  List<int> getLockSeatIndex(LayoutMode layoutMode) {
    if (layoutMode == LayoutMode.hostCenter) {
      return [4];
    }
    return [0];
  }

  ZegoLiveAudioRoomLayoutConfig getLayoutConfig(LayoutMode layoutMode) {
    var config = ZegoLiveAudioRoomLayoutConfig();
    switch (layoutMode) {
      case LayoutMode.defaultLayout:
        break;
      case LayoutMode.full:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.hostTopCenter:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.center,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 2,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceEvenly,
          ),
        ];
        break;
      case LayoutMode.hostCenter:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
    }
    return config;
  }

  ZegoLiveAudioRoomSeatConfig getSeatConfig(LayoutMode layoutMode) {
    if (layoutMode == LayoutMode.hostTopCenter) {
      return ZegoLiveAudioRoomSeatConfig(
        backgroundBuilder: (BuildContext context, Size size,
            ZegoUIKitUser? user, Map extraInfo) {
          return Container(color: Colors.grey);
        },
      );
    }

    return ZegoLiveAudioRoomSeatConfig(
      avatarBuilder: avatarBuilder,
    );
  }

  Widget avatarBuilder(BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    final photoProfile = userState.user?.photoProfile;
    return CircleAvatar(
        maxRadius: size.width,
        backgroundImage: (photoProfile != null) ?
        Image.network(photoProfile).image :
        Image.asset(IMG.defaultUser).image,
    );
  }

  Widget? background() {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: Image.asset("assets/images/bg1.webp").image,
        ),
      ),
    );
    return Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset("assets/images/bg1.webp").image,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 10,
          child: GestureDetector(
            onTap: () async {
              print('=============');
              final action = await showMaterialModalBottomSheet(
                builder: (context) => RoomInfoFit(room: widget.room),
                backgroundColor: Colors.transparent,
                context: context,
                expand: true,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.room.name,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "ID: ${widget.room.idRoom}",
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}



























// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:popcorn/core/notifiers/model_notifier.dart';
// import 'package:popcorn/core/usecases/preference_utils.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:popcorn/core/ui/responsive_safe_area.dart';
// import 'package:ms_material_color/ms_material_color.dart';
// import 'package:ripple_animation/ripple_animation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:popcorn/core/models/user_model.dart';
// import 'package:popcorn/core/models/room_model.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:popcorn/core/util/keys.dart';
// import 'package:popcorn/core/util/img.dart';
// import 'package:agora_rtm/agora_rtm.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../constants.dart';
// import 'package:get/get.dart';
// import 'card_mic.dart';
// import 'dart:convert';
// import 'dart:async';
//
//
// bool _volumeHigh = true;
// RtcEngine _engine;
//
//
//
// class LiveRoom extends StatefulWidget {
//   final RoomModel room;
//   const LiveRoom({this.room, Key key}) : super(key: key);
//
//   @override
//   _LiveRoomState createState() => _LiveRoomState(room);
// }
//
// class _LiveRoomState extends State<LiveRoom> {
//   final RoomModel room;
//   _LiveRoomState(this.room);
//
//
//   final _infoStrings = <String>[];
//   List<Widget> micRoom = [];
//   bool _isInChannel = false;
//   AgoraRtmChannel _channel;
//   AgoraRtmClient _client;
//   bool _micUsing = false;
//   bool _isLogin = false;
//   bool _switch = false;
//   bool _joined = false;
//   // UserModel _userModel;
//   bool _mute = true;
//   int _remoteUid = 0;
//   bool isJoined = false,
//       openMicrophone = true,
//       enableSpeakerphone = true,
//       playEffect = false;
//   int _indexMic = 0;
//
//   @override
//   void initState() {
//     // initPlatformState();
//     // _setRecentlyRoom();
//     _initUser();
//     super.initState();
//   }
//
//   _setRecentlyRoom() async {
//     final recentlyRef = usersRef
//         .doc(firebaseUtil.currentUser.uid)
//         .collection(KEYS.RECENTLY_ROOM)
//         .doc(widget.room.id);
//     final doc = await recentlyRef.get();
//     if (!doc.exists) {
//       await recentlyRef.set({
//         "idChannel": widget.room.id,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     }
//   }
//
//   Future<void> initPlatformState() async {
//     _client = await AgoraRtmClient.createInstance(APP_ID);
//     // Create RTC client instance
//     RtcEngineConfig config = RtcEngineConfig(APP_ID);
//
//     _engine = await RtcEngine.createWithConfig(config);
//     // Define event handling logic
//     // _client.onTokenExpired();
//     // _client.login(token, userId)
//     // await _client.renewToken(widget.room.token);
//     await _engine.renewToken(widget.room.token);
//     _engine.setEventHandler(RtcEngineEventHandler(
//           joinChannelSuccess: (String channel, int uid, int elapsed) async {
//         print('joinChannelSuccess $channel $uid');
//         await _engine.setEnableSpeakerphone(true);
//         // await _engine.setLocalVoicePitch(0.5);
//         setState(() {
//           _joined = true;
//         });
//       }, userJoined: (int uid, int elapsed) {
//         print('userJoined: $uid elapsed: $elapsed');
//         setState(() {
//           _remoteUid = uid;
//         });
//       }, userOffline: (int uid, UserOfflineReason reason) {
//         print('userOffline $uid');
//         setState(() {
//           _remoteUid = 0;
//         });
//       }),
//     );
//     print('room: ${widget.room.name}');
//     await _engine.joinChannel(
//         widget.room.token, widget.room.id, null, 0);
//     _engine.adjustRecordingSignalVolume(100);
//   }
//
//   void _initUser() {
//     micRoom = List<Widget>.generate(room.micNumber, (counter) => CardMic(index: counter+1));
//   }
//
//   _switchMicrophone() {
//     _engine.enableLocalAudio(!openMicrophone).then((value) {
//       setState(() {
//         openMicrophone = !openMicrophone;
//       });
//     }).catchError((err) {
//       print('enableLocalAudio $err');
//     });
//   }
//
//   _switchSpeakerphone() {
//     _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
//       setState(() {
//         enableSpeakerphone = !enableSpeakerphone;
//       });
//     }).catchError((err) {
//       print('setEnableSpeakerphone $err');
//     });
//   }
//
//   _switchEffect() async {
//     if (playEffect) {
//       _engine.stopEffect(1).then((value) {
//         setState(() {
//           playEffect = false;
//         });
//       }).catchError((err) {
//         print('stopEffect $err');
//       });
//     } else {
//       _engine.playEffect(
//           1,
//           // await (_engine.getAssetAbsolutePath("assets/Sound_Horizon.mp3")
//           await (_engine.getEffectDuration("assets/Sound_Horizon.mp3")
//           as FutureOr<String>),
//           -1,
//           1,
//           1,
//           100,
//           true,
//       ).then((value) {
//         setState(() {
//           playEffect = true;
//         });
//       }).catchError((err) {
//         print('playEffect $err');
//       });
//     }
//   }
//
//
//   @override
//   void dispose() {
//     _engine?.destroy();
//     super.dispose();
//   }
//
//
//   Widget build(BuildContext context) {
//     final _user = context.watch<ModelNotifier>().user;
//     return Container(
//       decoration: BoxDecoration(
//         color: greyColor,
//         image: DecorationImage(
//           image: AssetImage(IMG.BG4),
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(6.0),
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           color: bluAccentColor,
//                           child: (room.urlImage != null)
//                             ? CachedNetworkImage(
//                             imageUrl: "${room.urlImage}",
//                             fit: BoxFit.fill,
//                             height: 40,
//                             width: 40,
//                             placeholder: (context, url) =>
//                                 Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                             errorWidget: (context, url, error) =>
//                                 Center(
//                                   child: Image.asset(
//                                     IMG.DEFAULT_IMG,
//                                     fit: BoxFit.contain,
//                                     height: 40,
//                                     width: 40,
//                                   ),
//                                 ),
//                           )
//                               : Image.asset(
//                             IMG.DEFAULT_IMG,
//                             fit: BoxFit.fill,
//                             height: 40,
//                             width: 40,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${room.name}',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text('id_room'.trArgs([room.idRoom.toString()]),
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           MdiIcons.share,
//                           color: Colors.white,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           Icons.power_settings_new,
//                           color: Colors.white,
//                         ),
//                         onPressed: () => Get.back(),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30),
//             Expanded(
//               child: Wrap(
//                 children: micRoom.map((item) {
//                   int idx = micRoom.indexOf(item);
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: InkWell(
//                       onTap: () async {
//                         if (_micUsing) {
//                           setState(() {
//                             micRoom[idx] = CardMic(index: idx+1);
//                             _micUsing = false;
//                           });
//                         } else {
//                           this._micUsing = await Get.dialog(AlertDialog(
//                             backgroundColor: greyColor,
//                             title: Text('become_member'.tr,
//                               style: GoogleFonts.lato(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             actions: [
//                               TextButton(
//                                 child: Text('cancel'.tr,
//                                   style: GoogleFonts.lato(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 onPressed: () => Get.back(result: false),
//                               ),
//                               TextButton(
//                                 child: Text('join'.tr,
//                                   style: GoogleFonts.lato(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 onPressed: () => Get.back(result: true),
//                               ),
//                             ],
//                           )??false);
//                           if (_micUsing??false) {
//                             setState(() {
//                               micRoom[idx] = CardMic(
//                                 index: idx,
//                                 username: _user.firstName,
//                                 urlImage: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6",
//                                 // urlImage: _userModel.photoURL,
//                               );
//                             });
//                           }
//                         }
//                       },
//                       child: item
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             /*
//             Expanded(
//                 child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.max,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(6.0),
//                                     child: Container(
//                                       height: 40,
//                                       width: 40,
//                                       color: bluAccentColor,
//                                       child: (room.url != null)
//                                           ? CachedNetworkImage(
//                                               imageUrl: "${room.url}",
//                                               fit: BoxFit.fill,
//                                               height: 40,
//                                               width: 40,
//                                               placeholder: (context, url) =>
//                                                   Center(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               ),
//                                               errorWidget: (context, url, error) =>
//                                                       Center(
//                                                 child: Image.asset(
//                                                   IMG.DEFAULT_IMG,
//                                                   fit: BoxFit.contain,
//                                                   height: 40,
//                                                   width: 40,
//                                                 ),
//                                               ),
//                                             )
//                                           : Image.asset(
//                                               IMG.DEFAULT_IMG,
//                                               fit: BoxFit.fill,
//                                               height: 40,
//                                               width: 40,
//                                             ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '${room.channelName}',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         'id_room'
//                                             .trArgs([room.idRoom.toString()]),
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(
//                                       MdiIcons.share,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: Icon(
//                                       Icons.power_settings_new,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: () => Get.back(),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 30),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   _switchMicrophone();
//                                   // print("_mute: $_mute");
//                                   // if (!_mute) {
//                                   //   _engine.enableLocalAudio(true);
//                                   // } else {
//                                   //   _engine.enableLocalAudio(false);
//                                   // }
//                                   // _mute = !_mute;
//                                 },
//                                 child: Column(
//                                   children: [
//                                     ClipOval(
//                                       child: Container(
//                                         color: Colors.white.withOpacity(0.8),
//                                         child: IconButton(
//                                           icon: Icon(
//                                             Icons.mic,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       '1',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.normal,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '2',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '3',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '4',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '5',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '6',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '7',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '8',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '9',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   ClipOval(
//                                     child: Container(
//                                       color: Colors.white.withOpacity(0.8),
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.mic,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     '10',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     )),
//               ),
//
//             */
//             ChatForm(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class ChatForm extends StatefulWidget {
//   const ChatForm({Key key}) : super(key: key);
//
//   @override
//   _ChatFormState createState() => _ChatFormState();
// }
//
// class _ChatFormState extends State<ChatForm> {
//
//   TextEditingController _messageController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.transparent,
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           IconButton(
//             icon: Icon(_volumeHigh ? MdiIcons.volumeHigh : MdiIcons.volumeOff),
//             color: Colors.white,
//             onPressed: () {
//               setState(() {
//                 if (_volumeHigh) {
//                   _engine.disableAudio();
//                 } else {
//                   _engine.enableAudio();
//                 }
//                 _volumeHigh = !_volumeHigh;
//               });
//             },
//           ),
//           Expanded(
//             child: Container(
//               // margin: EdgeInsets.all(15.0),
//               height: 61,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(35.0),
//                         boxShadow: [
//                           BoxShadow(
//                             offset: Offset(0, 3),
//                             blurRadius: 5,
//                             color: Colors.grey,
//                           )
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _messageController,
//                               onChanged: mobxApp.setMessage,
//                               // focusNode: inputNode,
//                               autofocus: false,
//                               // onTap: () => FocusScope.of(context).requestFocus(inputNode),
//                               decoration: InputDecoration(
//                                 hintText: "type_something".tr,
//                                 prefixIcon: Icon(
//                                   Icons.chat_outlined,
//                                   color: Colors.blueAccent,
//                                 ),
//                                 hintStyle: TextStyle(
//                                   color: Colors.blueAccent,
//                                 ),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           Observer(
//                             builder: (_) {
//                               if (mobxApp.message.isEmpty) {
//                                 return Row(
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(
//                                         Icons.photo_camera,
//                                         color: Colors.blueAccent,
//                                       ),
//                                       onPressed: () {},
//                                     ),
//                                     IconButton(
//                                       icon: Icon(
//                                         Icons.attach_file,
//                                         color: Colors.blueAccent,
//                                       ),
//                                       onPressed: () {
//
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               } else {
//                                 return IconButton(
//                                   icon: Icon(
//                                     Icons.send,
//                                     color: Colors.blueAccent,
//                                   ),
//                                   onPressed: () {
//                                     mobxApp.setMessage('');
//                                     _messageController.clear();
//                                   },
//                                 );
//                               }
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 15),
//                   IconButton(
//                     icon: SvgPicture.asset(IMG.GIFT_CHAT_SVG,
//                       width: 30, height: 30,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
