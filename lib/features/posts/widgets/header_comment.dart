import '../../../core/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/usecases/constants.dart';
import '../../../core/widgets_helper/widgets.dart';



class HeaderComment extends StatelessWidget {

  final UserModel author;
  final PostModel post;
  const HeaderComment({
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
          InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              // if (utilsController.isUser(author.email)) {
              //   Get.to(() => UserProfilePage(user: author));
              // } else {
              //   Get.to(() => CompanyProfilePage(user: author));
              // }
            },
            child: chatCircleAvatar(author, 22),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  // if (utilsController.isUser(author.email)) {
                  //   Get.to(() => UserProfilePage(user: author));
                  // } else {
                  //   Get.to(() => CompanyProfilePage(user: author));
                  // }
                },
                child: getUsername(user: author,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(postController.timePost(post),
                    style: GoogleFonts.notoSans(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 2,
                    width: 4,
                  ),
                  Text(typesPost[post.idTypesPost]!,
                    style: GoogleFonts.notoSans(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 2,
                    width: 4,
                  ),

                  Text(visibilityOptions[post.idVisibility]!,
                    style: GoogleFonts.notoSans(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 2,
                    width: 4,
                  ),

                  visibilityIconPost[post.idVisibility]!,
                ],
              )
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
