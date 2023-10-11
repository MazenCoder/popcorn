import 'package:popcorn/packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:popcorn/features/posts/widgets/visibility_options_fit.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:popcorn/features/posts/widgets/types_post_fit.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../rooms/widgets/full_screen_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/util/flash_helper.dart';
import '../../../core/models/post_model.dart';
import '../../../core/mobx/mobx_app.dart';
import 'package:flutter/material.dart';
import '../../../core/util/img.dart';
import 'package:get/get.dart';
import 'dart:io';




class EditPost extends StatefulWidget {
  final PostModel post;
  const EditPost({Key? key, required this.post}) : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final MobxApp _mobxApp = MobxApp();


  @override
  void initState() {
    _mobxApp.onChangeText(true);
    _controller.text = widget.post.content;
    _mobxApp.setIdTypePost(widget.post.idTypesPost);
    _mobxApp.setIdVisibility(widget.post.idVisibility);
    int maxLines = getMaxLines(widget.post.content);
    _mobxApp.setMaxLines(maxLines + 5);
    postController.getPostById(widget.post.id);
    super.initState();
  }


  int getMaxLines(String text) {
    try {
      final span = TextSpan(text: text);
      final tp = TextPainter(
        text: span, maxLines: 8,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: Get.width - 36);
      TextSelection selection = TextSelection(
        baseOffset: 0, extentOffset: text.length,
      );
      List<TextBox> boxes = tp.getBoxesForSelection(selection);
      int numberOfLines = boxes.length;
      final numBreak = '\n\n'.allMatches(text).length + 1;
      final line = numBreak + numberOfLines + 1;
      if (line <= 1) {
        return 8;
      } else {
        return line;
      }
    } catch(e) {
      return 8;
    }
  }



  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final user = userState.user;
    return ResponsiveSafeArea(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2,
            centerTitle: true,
            title: Text('edit_post'.tr),
            leading: IconButton(
              icon: Icon(Icons.clear,
                color: primaryColor,
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              Observer(
                builder: (_) {
                  return TextButton(
                    child: Text('update'.tr),
                    onPressed: _mobxApp.textIsNotEmpty ? () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      RegExp exp = RegExp(r"\B#\w");
                      if (exp.allMatches(_controller.text.trim()).length < 5) {
                        FlashHelper.infoBar(context: context, message: 'maximum_minimum'.tr);
                        return;
                      }

                      final model = PostModel(
                          id: widget.post.id,
                          uid: widget.post.uid,
                          content: _controller.text.trim(),
                          idVisibility: _mobxApp.idVisibility,
                          idTypesPost: _mobxApp.idTypesPost,
                          isBanned: widget.post.isBanned,
                          urlImage: widget.post.urlImage,
                          isArchive: widget.post.isArchive,
                          likeCounter: widget.post.likeCounter,
                          commentCounter: widget.post.commentCounter,
                          timestamp: FieldValue.serverTimestamp()
                      );

                      await postController.editPost(context, model, _mobxApp.file).then((value) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (value) {
                          _mobxApp.onChangeText(false);
                          _mobxApp.setFile(null);
                          _controller.clear();
                          Get.back();
                        }
                      });
                    } : null,
                  );
                },
              )
            ],
            backgroundColor: Colors.white,
          ),
          // backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      chatCircleAvatar(user),
                      const SizedBox(width: 4,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          getUsername(user: user!,
                            style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(width: 0.6)
                                  ),
                                  child: InkWell(
                                    child: Observer(
                                      builder: (_) {
                                        return Row(
                                          children: [
                                            Text(typesPost[_mobxApp.idTypesPost]!,
                                              style: GoogleFonts.notoSans(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            const Icon(Icons.keyboard_arrow_down, size: 20)
                                          ],
                                        );
                                      },
                                    ),
                                    onTap: () async {
                                      int? idTypesPost = await showMaterialModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => TypesPostFit(index: _mobxApp.idTypesPost),
                                      );
                                      _mobxApp.setIdTypePost(idTypesPost ?? _mobxApp.idTypesPost);
                                    },
                                  )
                              ),
                              const SizedBox(width: 4),
                              Container(
                                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(width: 0.6)
                                  ),
                                  child: InkWell(
                                    child: Observer(
                                      builder: (_) {
                                        return Row(
                                          children: [
                                            Text(visibilityOptions[_mobxApp.idVisibility]!,
                                              style: GoogleFonts.notoSans(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            const Icon(Icons.keyboard_arrow_down, size: 20)
                                          ],
                                        );
                                      },
                                    ),
                                    onTap: () async {
                                      int? idVisibility = await showMaterialModalBottomSheet(
                                          expand: false,
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => const VisibilityOptionsFit()
                                      );
                                      _mobxApp.setIdVisibility(idVisibility ?? _mobxApp.idVisibility);
                                    },
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Observer(
                  builder: (_) {
                    return Container(
                      padding: const EdgeInsets.only(
                        left: 16, right: 16,
                      ),
                      margin: EdgeInsets.only(
                          bottom: (isKeyboardOpen &&
                            _mobxApp.file == null &&
                            widget.post.urlImage == null) ?
                          MediaQuery.of(context).viewInsets.bottom : 16
                      ),
                      child: DetectableTextField(
                        controller: _controller,
                        detectionRegExp: detectionRegExp()!,
                        // scrollPhysics: const ClampingScrollPhysics(),
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: _mobxApp.maxLines,
                        expands: false,
                        onChanged: (String? val) {
                          final text = (val != null && val.isNotEmpty);
                          _mobxApp.onChangeText(text);
                          RegExp exp = RegExp(r"\B#\w");
                          if (exp.allMatches(val??'').length > 15) {
                            FlashHelper.infoBar(context: context, message: 'maximum_hashtag'.tr);
                          }
                          int maxLines = getMaxLines(val??'');
                          _mobxApp.setMaxLines(maxLines + 5);
                        },
                        decoration: InputDecoration(
                          hintText: 'what_you_want_talk'.tr,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          focusColor: primaryColor,
                          fillColor: primaryColor,
                          border: InputBorder.none,
                        ),
                      ),
                    );
                  },
                ),

                Observer(
                  builder: (_) {
                    if (_mobxApp.file == null) {
                      return StreamBuilder<DocumentSnapshot>(
                        stream: postsRef.doc(widget.post.id).snapshots(),
                        builder: (context, snapshot) {
                          switch(snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const SizedBox.shrink();
                            default:
                              if (snapshot.hasData) {
                                final json = snapshot.data?.data() as Map<String, dynamic>;
                                final post = PostModel.fromJson(json);
                                if (post.urlImage != null) {
                                  return Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        margin: EdgeInsets.only(
                                            bottom: (isKeyboardOpen && _mobxApp.file == null) ?
                                            MediaQuery.of(context).viewInsets.bottom : 16
                                        ),
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
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 20, top: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: Container(
                                              color: Colors.white.withOpacity(0.8),
                                              child: IconButton(
                                                icon: const Icon(Icons.close,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  await postController.deleteImagePost(context, widget.post);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                              return const SizedBox.shrink();
                          }
                        },
                      );
                    } else if (_mobxApp.file != null) {
                      return Container(
                        margin: EdgeInsets.only(
                            bottom: isKeyboardOpen ? MediaQuery.of(context).viewInsets.bottom : 16
                        ),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(File(_mobxApp.file!.path),
                                  width: Get.width,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    color: Colors.white.withOpacity(0.8),
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _mobxApp.setFile(null),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                const SizedBox(height: 65),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          resizeToAvoidBottomInset: false,
          floatingActionButton: Container(
              margin: isKeyboardOpen ?
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                  : const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Colors.white,
                    width: 0.5
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0),
              width: Get.width,
              height: 40,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () async {
                      final _file = await _picker.pickImage(source: ImageSource.camera);
                      if (_file != null) {
                        File? croppedFile = await appUtils.croppedFile(File(_file.path));
                        if (croppedFile != null) {
                          _mobxApp.setFile(croppedFile);
                        }
                      }
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.photo),
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () async {
                      final _file = await _picker.pickImage(source: ImageSource.gallery);
                      if (_file != null) {
                        File? croppedFile = await appUtils.croppedFile(File(_file.path));
                        if (croppedFile != null) {
                          _mobxApp.setFile(croppedFile);
                        }
                      }
                    },
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Observer(
                    builder: (_) {
                      return InkWell(
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async {
                          int? idVisibility = await showMaterialModalBottomSheet(
                              expand: false,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const VisibilityOptionsFit()
                          );
                          _mobxApp.setIdVisibility(idVisibility ?? 1);
                        },
                        child: Row(
                          children: [
                            const Icon(MdiIcons.chatProcessingOutline, size: 20),
                            const SizedBox(width: 2),
                            Text(visibilityOptions[_mobxApp.idVisibility]!,
                              style: GoogleFonts.notoSans(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
          ),
        );
      },
    );
  }
}
