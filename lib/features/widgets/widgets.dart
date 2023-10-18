import 'package:cached_network_image/cached_network_image.dart';
import 'package:popcorn/generated/assets.dart';
import '../../core/models/user_model.dart';
import 'package:flutter/material.dart';



Widget getUsername({UserModel? user, TextStyle? style}) {
  return Text('${user?.displayName}',
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    style: style,
  );
}


Widget userCircleAvatar(UserModel? userModel, [double radius = 18]) {
  if (userModel !=  null && userModel.photoProfile != null) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider('${userModel.photoProfile}'),
    );
  } else {
    return CircleAvatar(
      radius: radius, backgroundColor: Colors.white,
      backgroundImage: const AssetImage(Assets.imagesLogo2),
    );
  }
}


Color colorLinear(double passStrength) {
  if (passStrength > 10) {
    return Colors.green;
  } else if (passStrength > 8 && passStrength < 11) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}


double valueLinear(double val) {
  if (val < 6) {
    return (1 / 4);
  } else if (val < 9) {
    return (2 / 4);
  } else if (val >= 10) {
    return (3 / 4);
  } else {
    return 1;
  }
}
