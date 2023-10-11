import '../../../core/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../core/util/img.dart';
import 'package:get/get.dart';




class UserBadges extends StatelessWidget {

  final UserModel user;
  final double size;
  final bool secondSizedBox;
  final Color? color;
  const UserBadges({
    Key? key, required this.user, this.color,
    this.size = 14, this.secondSizedBox = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (user.isVerified == true) const SizedBox(width: 5),
        if (user.isVerified)
          Tooltip(
            message: 'user_verify'.tr,
            child: Image.asset(
              IMG.verifiedUserBadge,
              height: size + 2,
              width: size + 2,
              color: color,
            ),
          ),
        if (user.role == 'admin') const SizedBox(width: 5),
        if (user.role == 'admin')
          Tooltip(
            message: 'user_admin'.tr,
            child: Image.asset(
              IMG.adminBadge,
              height: size + 4,
              width: size + 4,
              color: color,
            ),
          ),
        if (user.role == 'admin' && secondSizedBox == true)
          const SizedBox(width: 5),
      ],
    );
  }
}
