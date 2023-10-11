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
import 'package:get/get.dart';
import 'comment_post.dart';



class CardSavePost extends StatelessWidget {
  final UserModel userAuthor;
  final PostModel post;
  final bool isLiked;
  final bool isComment;
  final bool isFollow;
  const CardSavePost({Key? key,
    required this.userAuthor,
    required this.post,
    required this.isLiked,
    required this.isComment,
    required this.isFollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => CommentPost(
        author: userAuthor,
        post: post,
      )),
      child: Card(
        color: Colors.white,
        child: AbsorbPointer(
          absorbing: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              // HeaderPost(
              //   profileAuthor: profileAuthor,
              //   author: userAuthor,
              //   post: post,
              //   isFollow: isFollow,
              // ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
                child: DetectableText(
                  maxLines: 3,
                  text: post.content,
                  textAlign: TextAlign.start,
                  detectionRegExp: detectionRegExp()!,
                  // moreStyle: TextStyle(
                  //     color: greyColor
                  // ),
                  // lessStyle: TextStyle(
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () => Get.to(() => FullScreenImage(post.urlImage??'')),
                        child: Hero(
                          tag: post.urlImage??'',
                          child: CachedNetworkImage(
                            // height: Get.height/2.2,
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
                ),

              // FooterPost(
              //   profile: profileAuthor,
              //   author: userAuthor,
              //   post: post,
              //   isLiked: isLiked,
              //   isComment: isComment,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
