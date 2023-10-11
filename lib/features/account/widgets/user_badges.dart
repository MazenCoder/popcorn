import 'package:popcorn/core/models/user_model.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserBadges extends StatelessWidget {

  final UserModel user;
  final double size;
  final bool secondSizedBox;
  UserBadges({required this.user, this.size = 14, this.secondSizedBox = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (user.isVerified == true) SizedBox(width: 5),
        if (user.isVerified)
          Tooltip(
            message: 'user_verify'.tr,
            child: Image.asset(
              IMG.verifiedUserBadge,
              height: size + 2,
              width: size + 2,
            ),
          ),
        if (user.role == 'admin') SizedBox(width: 5),
        if (user.role == 'admin')
          Tooltip(
            message: 'user_admin'.tr,
            child: Image.asset(
              IMG.adminBadge,
              height: size + 4,
              width: size + 4,
            ),
          ),
        if (user.role == 'admin' && this.secondSizedBox == true)
          SizedBox(width: 5),
      ],
    );
  }
}
