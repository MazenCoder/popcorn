import 'package:popcorn/core/usecases/constants.dart';
import '../../../../core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/generateMaterialColor.dart';
import '../../../../core/widgets_helper/widgets.dart';




class CardFollowing extends StatelessWidget {
  final UserModel user;
  final bool isFollowed;
  const CardFollowing({
    Key? key,
    required this.user,
    required this.isFollowed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // if (utilsController.isUser(user.email)) {
              //   Get.to(() => UserProfilePage(user: user));
              // } else {
              //   Get.to(() => CompanyProfilePage(user: user));
              // }
            },
            child: chatCircleAvatar(user, 20),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: InkWell(
              onTap: () {
                // if (utilsController.isUser(user.email)) {
                //   Get.to(() => UserProfilePage(user: user));
                // } else {
                //   Get.to(() => CompanyProfilePage(user: user));
                // }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  getUsername(user: user),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),

          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              onTap: () => followingController.unFollowDialog(context, user),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              // highlightColor: blueAccentColor.withOpacity(0.1),
              // splashColor: blueAccentColor.withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: primaryColor,
                    width: 1,
                  ),
                ),
                child: Text(
                    'following'.tr
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
