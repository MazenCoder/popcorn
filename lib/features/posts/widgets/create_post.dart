import 'package:popcorn/packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:popcorn/features/posts/widgets/types_post_fit.dart';
import '../../../core/models/post_model.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/boxes.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/usecases/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import 'package:after_layout/after_layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../core/usecases/keys.dart';
import '../../../core/mobx/mobx_app.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'visibility_options_fit.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:io';




class CreatePost extends StatefulWidget {
  final ActionCreatePost? action;
  const CreatePost({Key? key, this.action}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> with AfterLayoutMixin<CreatePost> {


  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FocusNode _inputNode = FocusNode();
  final MobxApp _mobxApp = MobxApp();

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  BuildContext? _caseContext;

  int maxLines = 8;

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
      color: Colors.white,
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          title: Text('create_post'.tr),
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
                  child: Text('post'.tr),
                  onPressed: _mobxApp.textIsNotEmpty ? () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    RegExp exp = RegExp(r"\B#\w");
                    if (exp.allMatches(_controller.text.trim()).length < 5) {
                      utilsLogic.showSnack(
                        type: SnackBarType.info,
                        title: 'hashtag'.tr,
                        message: 'maximum_minimum'.tr,
                      );
                      return;
                    }

                    final model = PostModel(
                      id: const Uuid().v4(),
                      uid: user!.uid,
                      content: _controller.text.trim(),
                      idVisibility: _mobxApp.idVisibility,
                      idTypesPost: _mobxApp.idTypesPost,
                      isBanned: false,
                      isArchive: false,
                      likeCounter: 0,
                      commentCounter: 0,
                      timestamp: FieldValue.serverTimestamp()
                    );
                    await postController.createPost(context, model, _mobxApp.file).then((value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (value) {
                        _mobxApp.onChangeText(false);
                        _mobxApp.setFile(null);
                        _controller.clear();
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
          child: ShowCaseWidget(
            builder: Builder(
              builder : (context) {
                _caseContext = context;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          chatCircleAvatar(user),
                          const SizedBox(width: 4),
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
                                  Showcase(
                                    key: _one,
                                    description: 'choose_ost_type'.tr,
                                    child: Container(
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
                                  ),
                                  const SizedBox(width: 4),
                                  Showcase(
                                    key: _two,
                                    description: 'who_see_your_post'.tr,
                                    child: Container(
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
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 16, right: 16),
                              margin: EdgeInsets.only(
                                  bottom: (isKeyboardOpen && _mobxApp.file == null) ?
                                  MediaQuery.of(context).viewInsets.bottom : 16
                              ),
                              child: DetectableTextField(
                                focusNode: _inputNode,
                                controller: _controller,
                                detectionRegExp: detectionRegExp()!,
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
                                    utilsLogic.showSnack(
                                      type: SnackBarType.info,
                                      title: 'hashtag'.tr,
                                      message: 'maximum_hashtag'.tr,
                                    );
                                  }

                                  int maxLines = getMaxLines(val??'');
                                  _mobxApp.setMaxLines(maxLines+5);
                                  log('maxLines: ${_mobxApp.maxLines}');
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
                            ),

                            if (_mobxApp.file != null)
                              Container(
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
                                    )
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 65),
                  ],
                );
              }
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        floatingActionButton: Container(
            margin: isKeyboardOpen ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
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
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    final box = Boxes.settings();
    bool showCase = box.get(Keys.showCase, defaultValue: true);

    if (_caseContext != null && showCase) {
      ShowCaseWidget.of(_caseContext!).startShowCase([_one, _two]);
      await box.put(Keys.showCase, false);
    }

    if (widget.action != null) {
      switch(widget.action) {
        case ActionCreatePost.camera: {
          final file = await _picker.pickImage(source: ImageSource.camera);
          if (file != null) {
            File? croppedFile = await appUtils.croppedFile(File(file.path));
            if (croppedFile != null) {
              _mobxApp.setFile(croppedFile);
            }
          }
          break;
        }
        case ActionCreatePost.gallery: {
          final _file = await _picker.pickImage(source: ImageSource.gallery);
          if (_file != null) {
            File? croppedFile = await appUtils.croppedFile(File(_file.path));
            if (croppedFile != null) {
              _mobxApp.setFile(croppedFile);
            }
          }
          break;
        }
        case ActionCreatePost.text: {
          FocusScope.of(context).requestFocus(_inputNode);
          break;
        }
        default:
          FocusScope.of(context).requestFocus(_inputNode);
          break;
      }
    }
  }
}
