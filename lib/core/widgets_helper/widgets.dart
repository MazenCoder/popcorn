import 'package:cached_network_image/cached_network_image.dart';
import 'package:popcorn/core/theme/generateMaterialColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/usecases/constants.dart';
import '../../features/rooms/models/speak_model.dart';
import '../../features/rooms/models/room_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';
import '../util/img.dart';



Widget getUsername({required UserModel user, TextStyle? style}) {
  return Text(user.displayName,
    style: style,
  );
}

// ImageProvider userCircleAvatar(SpeakerModel? userModel) {
//   if (userModel !=  null && userModel.photoProfile != null) {
//     return NetworkImage(userModel.photoProfile!);
//   } else {
//     return const AssetImage(IMG.logo);
//   }
// }

Widget userCircleAvatar(UserModel? userModel, [double radius = 18]) {
  if (userModel !=  null && userModel.photoProfile != null) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(userModel.photoProfile!),
    );
  } else {
    return CircleAvatar(
        radius: radius, backgroundColor: Colors.white,
        backgroundImage: const AssetImage(IMG.logo3)
    );
  }
}

Widget chatCircleAvatar(UserModel? userModel, [double radius = 18]) {
  if (userModel !=  null && userModel.photoProfile != null) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(
        userModel.photoProfile!,
      ),
    );
  } else {
    return CircleAvatar(
      radius: radius, backgroundColor: primaryColor,
      child: ClipOval(
        child: Image.asset(
          IMG.logo3,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


Widget circleAvatarRoom(RoomModel? userModel, [double radius = 20]) {
  if (userModel !=  null && userModel.photoRoom != null) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(userModel.photoRoom!),
    );
  } else {
    return CircleAvatar(
        radius: radius, backgroundColor: Colors.grey,
        backgroundImage: const AssetImage(IMG.defaultImg)
    );
  }
}

Widget imageCardRoom(RoomModel? userModel, [double radius = 20]) {
  final isLtr = langController.isLtr();
  if (userModel !=  null && userModel.photoRoom != null) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: isLtr ? Radius.zero : const Radius.circular(5),
        bottomLeft: isLtr ? Radius.zero : const Radius.circular(5),
        topRight: isLtr ? const Radius.circular(5) : Radius.zero,
        bottomRight: isLtr ? const Radius.circular(5) : Radius.zero,
      ),
      child: Image.network(
        userModel.photoRoom!,
        fit: BoxFit.fill,
        height: 90,
        width: 90,
      ),
    );
  } else {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: isLtr ? Radius.zero : const Radius.circular(5),
        bottomLeft: isLtr ? Radius.zero : const Radius.circular(5),
        topRight: isLtr ? const Radius.circular(5) : Radius.zero,
        bottomRight: isLtr ? const Radius.circular(5) : Radius.zero,
      ),
      child: Image.asset(
        IMG.defaultImg,
        fit: BoxFit.fill,
        height: 90,
        width: 90,
      ),
    );
  }
}

Widget imageLiveRoom(RoomModel? userModel, [double radius = 20]) {
  if (userModel !=  null && userModel.photoRoom != null) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: Image.network(
        userModel.photoRoom!,
        fit: BoxFit.fill,
        height: radius,
        width: radius,
      ),
    );
  } else {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: Image.asset(
        IMG.defaultImg,
        fit: BoxFit.fill,
        height: radius,
        width: radius,
      ),
    );
  }
}

Widget checkOnline({
  DocumentSnapshot? data,
  TextStyle? style,
}) {
  if (data != null && data.exists) {
    Map<String, dynamic> map = data.data() as Map<String, dynamic>;
    final lastSeen = timeago.format(map['timestamp'].toDate(), locale: 'en_short');
    if (lastSeen.contains('now') || lastSeen.contains('1m')) {
      return Text(
        'online'.tr,
        style: style
      );
    } else {
      return Text(
        'last_seen'.trArgs([lastSeen]),
        style: style
      );
    }
  } else {
    return const SizedBox.shrink();
  }
}
