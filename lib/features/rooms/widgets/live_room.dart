import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import '../../../packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import '../../account/widgets/display_card_profile.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/gift_widget.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'package:popcorn/generated/assets.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/user_model.dart';
import '../../../core/usecases/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import 'gift_and_frame_fit.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:async';




class LiveRoom extends StatefulWidget {
  final RoomAuthorModel room;
  const LiveRoom({super.key, required this.room});

  @override
  State<LiveRoom> createState() => _LiveRoomState();
}

class _LiveRoomState extends State<LiveRoom> {

  final ZegoLiveAudioRoomController _zegoController = ZegoLiveAudioRoomController();
  late StreamSubscription<ZegoInRoomCommandReceivedData> subscriptions;
  final isSeatClosedNotifier = ValueNotifier<bool>(false);

  final isRequestingNotifier = ValueNotifier<bool>(false);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subscriptions = ZegoUIKit().getInRoomCommandReceivedStream().listen(onInRoomCommandReceived);
    });
    super.initState();
  }

  @override
  void dispose() {
    subscriptions.cancel();
    super.dispose();
  }

  void onInRoomCommandReceived(ZegoInRoomCommandReceivedData commandData) {
    final user = userState.user!;
    debugPrint("onInRoomCommandReceived, fromUser:${commandData.fromUser}, command:${commandData.command}");
    // You can display different animations according to gift-type
    if (commandData.fromUser.id != '${user.uid.hashCode}') {
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
    bool isRtl = languageLogic.isRtl();
    return ZegoUIKitPrebuiltLiveAudioRoom(
      appID: appID, appSign: appSign,
      userID: user.uid,
      userName: user.displayName,
      roomID: '${widget.room.id.hashCode}',
      controller: _zegoController,
      config: ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
        ..takeSeatIndexWhenJoining = -1
        ..background = background(widget.room)
        ..hostSeatIndexes = getLockSeatIndex(LayoutMode.hostCenter)
        ..layoutConfig = getLayoutConfig(LayoutMode.defaultLayout)
        ..seatConfig = getSeatConfig(LayoutMode.defaultLayout)
        ..audioEffectConfig = ZegoAudioEffectConfig()
        ..seatConfig = ZegoLiveAudioRoomSeatConfig(
          avatarBuilder: (context, size, zegoUser, map) {
            if (zegoUser?.id == user.uid) {
              return chatCircleAvatar(user, 25);
            }
            return chatCircleAvatar(null, 25);
          },
        )..onLeaveConfirmation = (BuildContext context) async {
          return await utilsLogic.onLeaveConfirmation(context, widget.room);
        }..seatConfig.avatarBuilder = (context, size, zegUser, Map extraInfo) {
          return getProfileImageByUID(
            uid: zegUser?.id,
            height: 96,
            width: 96,
          );
        }..onSeatClicked = (int index, ZegoUIKitUser? user) {
          showOnSeatClicked(context, index, user);
        }..inRoomMessageConfig = ZegoInRoomMessageConfig(
          height: Get.height - 340,
          width: Get.width,
          // backgroundColor: Colors.transparent,
          showAvatar: true,
          messageTextStyle: const TextStyle(
            color: Colors.white,
          ),
          itemBuilder: (context, message, map) {
            return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: InkWell(
                onTap: () {
                  WoltModalSheet.show(
                    context: context,
                    pageListBuilder: (modalSheetContext) {
                      final textTheme = Theme.of(context).textTheme;
                      return [
                        userInfoSheet(
                          modalSheetContext, textTheme,
                          message.user.id,
                        ),
                      ];
                    },
                  );
                },
                child: ListTile(
                  title: Text(
                    message.user.name,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Text(
                          message.message,
                          style: context.textTheme.bodyMedium?.copyWith(
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  // isThreeLine: true,
                  leading: getProfileImageByUID(
                    uid: message.user.id,
                    height: 44,
                    width: 44,
                  )
                ),
              ),
            );
          }
        )..bottomMenuBarConfig.audienceButtons = const [
          ZegoMenuBarButtonName.showMemberListButton,
        ]..topMenuBarConfig.buttons = [
          ZegoMenuBarButtonName.minimizingButton,
        ]..layoutConfig.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
          ZegoLiveAudioRoomLayoutRowConfig(count: 2, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
        ]..bottomMenuBarConfig.audienceExtendButtons = [
          connectButton(),
          IconButton(
            icon: Image.asset(
              Assets.imagesGift,
              fit: BoxFit.cover,
              height: 50,
              width: 50,
            ),
            onPressed: () async {
              /*
              WoltModalSheet.show(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  final textTheme = Theme.of(context).textTheme;
                  return [
                    WoltModalSheetPage.withSingleChild(
                      child: GiftAndFrameFit(),
                    ),
                  ];
                },
              );
              */
              final action = await showMaterialModalBottomSheet(
                builder: (context) => const GiftAndFrameFit(),
                // backgroundColor: Get.theme.primaryColor,
                context: context,
                expand: false,
              );
            },
          )
        ]
    );
  }

  Widget connectButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isSeatClosedNotifier,
      builder: (context, isSeatClosed, _) {
        return isSeatClosed ? ValueListenableBuilder<bool>(
          valueListenable: isRequestingNotifier,
          builder: (context, isRequesting, _) {
            return isRequesting
                ? ElevatedButton(
              onPressed: () {
                _zegoController.cancelSeatTakingRequest().then((result) {
                  isRequestingNotifier.value = false;
                });
              },
              child: const Text('Cancel'),
            )
                : ElevatedButton(
              onPressed: () {
                _zegoController.applyToTakeSeat().then((result) {
                  isRequestingNotifier.value = result;
                });
              },
              child: const Text('Request'),
            );
          },
        )
            : Container();
      },
    );
  }
  Future<void> showOnSeatClicked(BuildContext context, int index, ZegoUIKitUser? user) async {
    await showModalBottomSheet(
      backgroundColor: const Color(0xff111014),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user?.id == userState.user?.uid)
                  TextButton.icon(
                    icon: const Icon(Icons.logout_outlined),
                    label: Text('leave_the_mic'.tr),
                    onPressed: () async {
                      await _zegoController.leaveSeat(showDialog: false);
                      if (context.mounted) Navigator.pop(context);
                    },
                  )
                else if (user == null)
                  TextButton.icon(
                    icon: const Icon(Icons.mic),
                    label: Text('take_the_mic'.tr),
                    onPressed: () async {
                      await _zegoController.takeSeat(index);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),

                TextButton(
                  child: Text('cancel'.tr),
                  onPressed: () => Navigator.pop(context),
                ),

              ],
            )
          ),
        );
      },
    );
  }

  List<int> getLockSeatIndex(LayoutMode layoutMode) {
    // Use this to set the special seat for the host only (speakers and the audience are not allowed to sit).
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
        backgroundBuilder: (
            BuildContext context,
            Size size,
            ZegoUIKitUser? user,
            Map extraInfo,
        ) {
          return Container(color: Colors.grey);
        },
      )..backgroundBuilder = backgroundBuilder
        ..foregroundBuilder = backgroundBuilder;
    }

    return ZegoLiveAudioRoomSeatConfig(
      avatarBuilder: avatarBuilder,
    );
  }

  bool isAttributeHost(Map<String, String>? userInRoomAttributes) {
    log('userInRoomAttributes: $userInRoomAttributes');
    return (userInRoomAttributes?[attributeKeyRole] ?? "") ==
        ZegoLiveAudioRoomRole.host.index.toString();
  }

  Widget backgroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    if (!isAttributeHost(user?.inRoomAttributes.value)) {
      return Container();
    }

    return Positioned(
      top: -8,
      left: 0,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset(
              Assets.imagesLogo,
            ).image
          ),
        ),
      ),
    );
  }

  Widget foregroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    var userName = user?.name.isEmpty ?? true
        ? Container()
        : Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Text(
        user?.name ?? "",
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          backgroundColor: Colors.black.withOpacity(0.1),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
          color: Colors.white,
        ),
      ),
    );

    if (!isAttributeHost(user?.inRoomAttributes.value)) {
      return userName;
    }

    var hostIconSize = Size(size.width / 3, size.height / 3);
    var hostIcon = Positioned(
      bottom: 3,
      right: 0,
      child: Container(
        width: hostIconSize.width,
        height: hostIconSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(
                Assets.imagesLogo,
              ).image
          ),
        ),
      ),
    );

    return Stack(children: [userName, hostIcon]);
  }

  Widget avatarBuilder(BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    final photoProfile = userState.user?.photoProfile;
    return ClipOval(
      child: (photoProfile != null) ?
      CachedNetworkImage(
        imageUrl: photoProfile,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Padding(
              padding: const EdgeInsets.all(2),
              child: CircularProgressIndicator(value: downloadProgress.progress),
            ),
        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
      ) : Image.asset(
        Assets.imagesDefaultUser,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget? background(RoomAuthorModel model) {
    if (model.backgroundImage != null) {
      return CachedNetworkImage(
        imageUrl: '${model.backgroundImage}',
        fit: BoxFit.fill,
        placeholder: (context, url) => Image.asset(
          Assets.imagesBg1,
          fit: BoxFit.fill,
        ),
        errorWidget: (context, url, error) => Image.asset(
          Assets.imagesBg1,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Image.asset(
        Assets.imagesBg1,
        fit: BoxFit.fill,
      );
    }
  }

  userInfoSheet(modalSheetContext, textTheme, String uid) {
    return WoltModalSheetPage.withSingleChild(
      backgroundColor: primaryColor,
      child: FutureBuilder<UserModel>(
        future: userLogic.getUserById(uid),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CupertinoActivityIndicator()),
              );
            default:
              final user = snapshot.data;
              if (user != null) {
                return SizedBox(
                  height: 300,
                  width: Get.width,
                  child: DisplayCardProfile(user: user),
                );
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      chatCircleAvatar(user, 40),
                      const SizedBox(height: 20),
                    ],
                  ),
                ); 
              } else {
                return const SizedBox();
              }
          }
        },
      )
    );
  }
}




















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
