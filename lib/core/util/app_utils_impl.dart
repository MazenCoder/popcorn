import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:popcorn/core/widgets_helper/loading_dialog.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:popcorn/core/error/failures.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../usecases/constants.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'app_utils.dart';
import 'dart:async';
import 'dart:io';




@LazySingleton(as: AppUtils)
class AppUtilsImpl implements AppUtils {


  Future<void> changeDialog(BuildContext context) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('choose_locale'.tr),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Divider(),
          Flexible(
            child: TextButton(
                child: const Text('English'),
                onPressed: () async {
                  // log(context.locale.toString(), name: toString());
                  // context.locale = Locale('fr', 'FR');
                  // await appUtils.setLocale(true);
                  Navigator.pop(context);
                }
            ),
          ),

          Flexible(
            child: TextButton(
                child: const Text(' العربية'),
                onPressed: () async {
                  // log(context.locale.toString(), name: toString());
                  // context.locale = Locale('ar', 'AR');
                  // await appUtils.setLocale(false);
                  Navigator.pop(context);
                }
            ),
          )
        ],
      ),
    ));
  }

  @override
  String accountCreateAt(UserModel model) {
    try {
      return timeago.format(model.createdAt);
    } catch(e) {
      logger.e('$e');
      return 'a_second_ago'.tr;
    }
  }

  /*
  @override
  Future<void> createRoom(BuildContext context, RoomModel model) async {
    try {
      if (networkState.isConnected) {

        await roomRef.doc(model.idChannel).set(model.toJson());
        AgoraRtmChannel channel = await client.createChannel(model.idChannel);
        channel.onMemberJoined = (AgoraRtmMember member) {
          print("Member joined: " + member.userId + ', channel: ' + member.channelId);
        };
        channel.onMemberLeft = (AgoraRtmMember member) {
          print("Member left: " + member.userId + ', channel: ' + member.channelId);
        };
        channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
          print("Channel msg: " + member.userId + ", msg: " + message.text);
        };
      } else {
        Get.snackbar(
          'oops'.tr,
          'error_connection'.tr,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: Duration(seconds: 4),
        );
      }
    } catch(e) {
      logger.e('$e');
    }
  }
   */

  @override
  Future<String?> uploadImageRoom(BuildContext context, File image) async {
    try {
      if (networkState.isConnected) {
        return await _uploadImage(image);
      } else {
        Get.snackbar(
          'oops'.tr,
          'error_connection'.tr,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      }
    } catch(e) {
      logger.e('$e');
    }
  }

  Future getRooms() async {
    // await usersRef.doc(auth.currentUser!.uid)
    //     .collection(KEYS.ROOM).doc(model.id).set(model.toJson());
  }

  // static Future<XFile?> compressImage(String photoId, File image) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   XFile? compressedImageFile = await FlutterImageCompress.compressAndGetFile(
  //     image.absolute.path,
  //     '$path/img_$photoId.jpg',
  //     quality: 70,
  //   );
  //   return compressedImageFile;
  // }


  static Future<String?> _uploadImage(File file) async {
    try {
      String name = basename(file.path);
      final typeImage = name.substring(name.indexOf('.')+1, name.length);
      List<firebase_storage.UploadTask> uploadTasks = [];
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("rooms/${const Uuid().v4()}");
      firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
        contentType: 'image/$typeImage', customMetadata: {'picked-file-path': file.path},
      );

      return await ref.putFile(file, metadata).then((firebase_storage.TaskSnapshot snapshot) async {
        return await snapshot.ref.getDownloadURL();
      });
    } catch(e) {
      logger.e('e: $e');
    }
  }

  @override
  Future<void> updatePass(BuildContext context, UserModel model) async {
    if (networkState.isConnected) {
      if (model.password?.isNotEmpty??false) {
        final TextEditingController newPass = TextEditingController();
        final formKey = GlobalKey<FormState>();
        await showDialog(context: context, builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.symmetric(vertical: 5),
            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            title: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.blue.shade600,
              child: Text('update_pass'.tr,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            content: Form(
              key: formKey,
              child: TextFormField(
                autofocus: true,
                controller: newPass,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'new_pass'.tr,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (val) {
                  final value = val??'';
                  if(value.isEmpty) {
                    return 'required_field'.tr;
                  } else {
                    return null;
                  }
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('cancel'.tr,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('update'.tr,
                ),
                onPressed: () async {
                  if (formKey.currentState?.validate()??false) {
                    try {
                      LoadingDialog.show(context: context);
                      AuthCredential credential = EmailAuthProvider.credential(email: model.email, password: model.password!);

                        await auth.currentUser?.reauthenticateWithCredential(credential);
                        await auth.currentUser?.updatePassword(newPass.text.trim()).then((value) async {
                          await usersRef.doc(model.uid).update({"pass": newPass.text.trim()});
                          if (context.mounted) LoadingDialog.hide(context: context);
                          if (context.mounted) Navigator.pop(context);
                          Get.snackbar(
                            'completed_successfully'.tr,
                            'update_success'.tr,
                            icon: Icon(Icons.check_circle, color: Colors.green[300]),
                            shouldIconPulse: true,
                            barBlur: 20,
                            isDismissible: true,
                            duration: const Duration(seconds: 4),
                          );
                        });

                    }  on FirebaseAuthException catch (e) {
                      if (context.mounted) LoadingDialog.hide(context: context);
                      if (e.code == 'user-not-found') {
                        logger.e('No user found for that email.');
                        Get.snackbar(
                          'oops'.tr,
                          'user_not_found'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else if (e.code == 'requires-recent-login') {
                        logger.e('requires-recent-login');
                        Get.snackbar(
                          'oops'.tr,
                          'recent_login'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else if (e.code == 'weak-password') {
                        logger.e('The password provided is too weak.');
                        Get.snackbar(
                          'oops'.tr,
                          'weak_password'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else {
                        logger.e('$e');
                        Get.snackbar(
                          'oops'.tr,
                          'something_wrong'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      }
                    } catch(e) {
                      logger.e('$e');
                      if (context.mounted) LoadingDialog.hide(context: context);
                      Get.snackbar(
                        'oops'.tr,
                        'something_wrong'.tr,
                        icon: Icon(Icons.warning, color: Colors.red[300]),
                        shouldIconPulse: true,
                        barBlur: 20,
                        isDismissible: true,
                        duration: const Duration(seconds: 4),
                      );
                    }
                  }
                },
              ),
            ],
          );
        });
      } else {
        final TextEditingController newPass = TextEditingController();
        final TextEditingController oldPass = TextEditingController();
        final formKey = GlobalKey<FormState>();
        await showDialog(context: context, builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.symmetric(vertical: 5),
            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            title: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.blue.shade600,
              child: Text('update_pass'.tr,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: Get.textTheme.bodyText2?.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // shrinkWrap: true,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: oldPass,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'old_pass'.tr,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (val) {
                        final value = val??'';
                        if(value.isEmpty) {
                          return 'required_field'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    TextFormField(
                      autofocus: true,
                      controller: newPass,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'new_pass'.tr,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (val) {
                        final value = val??'';
                        if(value.isEmpty) {
                          return 'required_field'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('cancel'.tr,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('update'.tr,
                ),
                onPressed: () async {
                  if (formKey.currentState?.validate()??false) {
                    try {
                      LoadingDialog.show(context: context);
                      AuthCredential credential = EmailAuthProvider.credential(email: model.email, password: oldPass.text.trim());
                      if (credential != null) {
                        await auth.currentUser?.reauthenticateWithCredential(credential);
                        await auth.currentUser?.updatePassword(newPass.text.trim()).then((value) async {
                          await usersRef.doc(model.uid).update({"pass": newPass.text.trim()});
                          if (context.mounted) LoadingDialog.hide(context: context);
                          if (context.mounted) Navigator.pop(context);
                          Get.snackbar(
                            'completed_successfully'.tr,
                            'update_success'.tr,
                            icon: Icon(Icons.check_circle, color: Colors.green[300]),
                            shouldIconPulse: true,
                            barBlur: 20,
                            isDismissible: true,
                            duration: const Duration(seconds: 4),
                          );
                        });
                      } else {
                        LoadingDialog.hide(context: context);
                        Navigator.pop(context);
                        Get.snackbar(
                          'oops'.tr,
                          'old_pass_not_correct'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      }
                    }  on FirebaseAuthException catch (e) {
                      LoadingDialog.hide(context: context);
                      if (e.code == 'user-not-found') {
                        logger.e('No user found for that email.');
                        Get.snackbar(
                          'oops'.tr,
                          'user_not_found'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else if (e.code == 'requires-recent-login') {
                        logger.e('requires-recent-login');
                        Get.snackbar(
                          'oops'.tr,
                          'recent_login'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else if (e.code == 'weak-password') {
                        logger.e('The password provided is too weak.');
                        Get.snackbar(
                          'oops'.tr,
                          'weak_password'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else {
                        logger.e('$e');
                        Get.snackbar(
                          'oops'.tr,
                          'something_wrong'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      }
                    } catch(e) {
                      logger.e('$e');
                      if (context.mounted) LoadingDialog.hide(context: context);
                      Get.snackbar(
                        'oops'.tr,
                        'something_wrong'.tr,
                        icon: Icon(Icons.warning, color: Colors.red[300]),
                        shouldIconPulse: true,
                        barBlur: 20,
                        isDismissible: true,
                        duration: const Duration(seconds: 4),
                      );
                    }
                  }
                },
              ),
            ],
          );
        });
      }
    } else {
      Get.snackbar(
        'oops'.tr,
        'error_connection'.tr,
        icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Future<void> likeUnlikeMessage(Message message, String chatId,
      bool isLiked, UserModel receiverUser, String currentUserId) {
    return chatsRef.doc(chatId)
        .collection('messages')
        .doc(message.id)
        .update({'isLiked': isLiked});
  }

  @override
  String parseTimestamp(dynamic timestamp) {
    try {
      logger.i(timestamp.runtimeType);
      return timeFormat.format(timestamp);
    } catch(e) {
      logger.e('$e');
      return '';
    }
  }

  @override
  Future<void> logOut(BuildContext context) async {
    try {
      LoadingDialog.show(context: context);
      if (auth.currentUser != null) {
        await removeToken();
        await auth.signOut();
      }
      // Get.overlayContext.read<ModelNotifier>().logout();
      if (context.mounted) LoadingDialog.hide(context: context);
      logger.i('logout');
    } catch(e) {
      logger.e('$e');
      if (context.mounted) LoadingDialog.hide(context: context);
      Get.snackbar(
        'oops'.tr,
        'error_wrong'.tr,
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.warning, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Future<void> removeToken() async {
    final currentUser = auth.currentUser;
    await usersRef.doc(currentUser!.uid).update({'token': null});
  }

  Future<File?> croppedFile(File file) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'crop_rotate'.tr,
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(title: 'crop_rotate'.tr)
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    } catch(e) {
      logger.e(e);
      return null;
    }
    return null;
  }
}
