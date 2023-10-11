import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/functions.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../rooms/widgets/full_screen_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/user_model.dart';
import '../../widgets/web_view_app.dart';
import 'package:flutter/material.dart';
import '../../../core/util/img.dart';
import 'header_anonymous_post.dart';
import 'package:get/get.dart';
import 'footer_post.dart';
import 'header_post.dart';



class CardPost extends StatelessWidget {
  final UserModel userAuthor;
  final PostModel post;
  final bool isLiked;
  final bool isComment;
  final bool isFollow;
  const CardPost({Key? key,
    required this.userAuthor,
    required this.post,
    required this.isLiked,
    required this.isComment,
    required this.isFollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anonymous = post.idVisibility == 2;
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          if (anonymous)
            HeaderAnonymousPost(
              author: userAuthor,
              post: post,
              isFollow: isFollow,
            )
          else
            HeaderPost(
              author: userAuthor,
              post: post,
              isFollow: isFollow,
            ),

          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: DetectableText(
              // maxLines: 3,
              text: post.content,
              textAlign: TextAlign.start,
              detectionRegExp: detectionRegExp()!,
              // moreStyle: GoogleFonts.notoSans(
              //     color: greyColor
              // ),
              // lessStyle: GoogleFonts.notoSans(
              //     color: greyColor
              // ),
              onTap: (text) {
                logger.i(text);
                if (isDetected(text, urlRegex)) {
                  Get.to(() => WebVewApp(url: text));
                } else if (isDetected(text, hashTagRegExp)) {
                  // Get.to(() => HashtagPage(hashtag: text));
                } else if (isDetected(text, atSignRegExp)) {

                }
              },
            ),
          ),

          if (post.urlImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  onTap: () => Get.to(() => FullScreenImage(post.urlImage??'')),
                  child: Hero(
                    tag: post.urlImage??'',
                    child: CachedNetworkImage(
                      height: Get.height/2.2,
                      width: Get.width,
                      fit: BoxFit.fill,
                      imageUrl: post.urlImage??'',
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Center(child: Image.asset(IMG.defaultImg)),
                    ),
                  ),
                ),
              ),
            ),

          FooterPost(
            author: userAuthor,
            post: post,
            isLiked: isLiked,
            isComment: isComment,
          ),
        ],
      ),
    );
  }
}
