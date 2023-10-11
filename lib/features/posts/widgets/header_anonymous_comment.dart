import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/user_model.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/widgets_helper/widgets.dart';




class HeaderAnonymousComment extends StatelessWidget {
  final UserModel author;
  final PostModel post;
  const HeaderAnonymousComment({
    Key? key,
    required this.author,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          chatCircleAvatar(null, 22),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (author.uid == userState.user?.uid)
                Text('stealth_user_you'.tr,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Text('stealth_user'.tr,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
