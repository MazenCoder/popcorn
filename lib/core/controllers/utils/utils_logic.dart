import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../features/admin/models/topic_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../features/rooms/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/models/gift_model.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../widgets_helper/loading_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:package_info/package_info.dart';
import '../../theme/generateMaterialColor.dart';
import '../../models/message_group_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../usecases/constants.dart';
import '../../models/frame_model.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import '../../usecases/boxes.dart';
import '../../usecases/enums.dart';
import '../../usecases/keys.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'utils_state.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:io';



class UtilsLogic extends GetxController {
  static UtilsLogic instance = Get.find();
  final boxSettings = Boxes.settings();
  final state = UtilsState();


  @override
  void onInit() {
    getThemeStatus();
    initVersion();
    getGifts();
    getFrames();
    super.onInit();
  }


  ///! --------- Version ---------
  Future<void> initVersion({bool listener = false}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    state.version = version;
    if (listener) {
      update();
    }
  }

  ///! --------- Themes ---------
  void getThemeStatus() {
    bool isDarkTheme = boxSettings.get(Keys.theme, defaultValue: true);
    state.isDarkTheme.value = isDarkTheme;
    logger.i('isDarkTheme: $isDarkTheme');
    if (isDarkTheme) {
      //! isDarkTheme = ture
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      //! isDarkTheme = false
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  void saveThemeStatus(bool value) {
    logger.i('saveThemeStatus: $value');
    //! isDark = ture
    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      //! isDark = false
      Get.changeThemeMode(ThemeMode.light);
    }
    state.isDarkTheme.value = value;
    boxSettings.put(Keys.theme, value);
  }

  void showSnack({required SnackBarType type, String? title, String? message, int seconds = 4}) {
    switch (type) {
      case SnackBarType.error:
        Get.snackbar(
          title ?? 'oops'.tr,
          message ?? 'error_wrong'.tr,
          icon: Icon(MdiIcons.alert, color: Colors.red[300]),
          colorText: Colors.red[300],
          backgroundColor: Colors.white,
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          snackPosition: SnackPosition.BOTTOM,
          borderColor: Colors.red[300],
          borderWidth: 0.5,
          margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
          duration: Duration(seconds: seconds),
        );
        return;
      case SnackBarType.unconnected:
        Get.snackbar(
          title ?? 'oops'.tr,
          'error_connection'.tr,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          colorText: Colors.red[300],
          backgroundColor: Colors.white,
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          snackPosition: SnackPosition.BOTTOM,
          borderColor: Colors.red[300],
          borderWidth: 0.5,
          margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
          duration: Duration(seconds: seconds),
        );
        return;
      case SnackBarType.info:
        Get.snackbar(
          title ?? 'oops'.tr,
          message ?? '',
          icon: Icon(MdiIcons.informationOutline, color: Colors.orange[600]),
          colorText: Colors.orange[600],
          backgroundColor: Colors.white,
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          snackPosition: SnackPosition.BOTTOM,
          borderColor: Colors.orange[600],
          borderWidth: 0.5,
          margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
          duration: Duration(seconds: seconds),
        );
        return;
      case SnackBarType.success:
        Get.snackbar(
          title ?? 'success'.tr,
          message ?? '',
          icon: Icon(MdiIcons.checkboxMarkedCircleOutline, color: Colors.green[300]),
          colorText: primaryColor,
          backgroundColor: Colors.white,
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          snackPosition: SnackPosition.BOTTOM,
          borderColor: Colors.green[300],
          borderWidth: 0.5,
          margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
          duration: Duration(seconds: seconds),
        );
        return;
    }
  }

  bool isLocalFilePath(String path) {
    Uri uri = Uri.parse(path);
    return !uri.scheme.contains('http');
  }

  bool isVideo(String path) {
    bool output = false;
    for (var videoFormat in videoFormats) {
      if (path.toLowerCase().contains(videoFormat)) output = true;
    }
    return output;
  }

  bool isImage(String path) {
    bool output = false;
    for (var imageFormat in imageFormats) {
      if (path.toLowerCase().contains(imageFormat)) output = true;
    }
    return output;
  }

  bool isPdf(String path) {
    bool output = false;
    for (var pdfFormat in pdfFormats) {
      if (path.toLowerCase().contains(pdfFormat)) output = true;
    }
    return output;
  }

  bool isUser(UserModel? user) {
    return user?.role == 'user';
  }

  Timer interval(Duration duration, func) {
    Timer function() {
      Timer timer = Timer(duration, function);
      func(timer);
      return timer;
    }

    return Timer(duration, function);
  }

  Widget getUsername({
    required UserModel user,
    TextStyle? style,
    StrutStyle? strutStyle,
    int? maxLines,
    TextAlign? textAlign,
    TextOverflow? overflow,
  }) {
    return Text(
      user.displayName,
      overflow: overflow,
      strutStyle: strutStyle,
      maxLines: maxLines,
      textAlign: textAlign,
      style: style,
    );
  }


  void rateApp(BuildContext context) async {
    await rateMyApp.showRateDialog(
      context,
      title: 'rate_app'.tr,
      message: 'msg_rate_app'.tr,
      rateButton: 'rate_but'.tr,
      noButton: 'no_thanks'.tr,
      laterButton: 'maybe_later'.tr,
    );
  }

  String stealthNbr(UserModel user) {
    try {
      int nbr = generateHash(user.uid);
      String result = '$nbr';
      return shortenName(result, nameLimit: 3);
    } catch (e) {
      return '11';
    }
  }

  int generateHash(String s1) => (<String>[s1]..sort()).join().hashCode;

  String shortenName(String nameRaw, {int nameLimit = 10, bool addDots = false}) {
    //* Limiting val should not be gt input length (.substring range issue)
    final max = nameLimit < nameRaw.length ? nameLimit : nameRaw.length;
    //* Get short name
    final name = nameRaw.substring(0, max);
    //* Return with '..' if input string was sliced
    if (addDots && nameRaw.length > max) return '$name..';
    return name;
  }

  String formatTag(String val) {
    try {
      List<String> list = [];
      var listSkills = (val.split(','));
      for (var val in listSkills) {
        list.add(
            '#${val.replaceAll(" ", "").replaceAll("-", "").replaceAll(".", "").replaceAll("&", "").replaceAll("'", "")}');
      }
      var stringList = list.join("");
      return stringList.replaceAll("#", " #");
    } catch (e) {
      logger.e(e);
      return val;
    }
  }

  List<String> formatStringToList(String val) {
    try {
      var listSkills = (val.split(' '));
      listSkills.removeWhere((item) => ["", null, false, 0].contains(item));
      return listSkills;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  bool isUpperCase(String letter) {
    // assert(s.length == 1);
    final regExp = RegExp('[A-Z]');
    return regExp.hasMatch(letter);
  }

  int getMaxLines(String text) {
    try {
      final span = TextSpan(text: text);
      final tp = TextPainter(
        text: span,
        // maxLines: 8,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: Get.width - 36);
      List lines = tp.computeLineMetrics();
      int numberOfLines = lines.length;

      final numBreak = '\n\n'.allMatches(text).length + 1;
      final line = numBreak + numberOfLines + 1;

      if (line <= 1) {
        return 8;
      } else {
        return line;
      }
    } catch (e) {
      return 8;
    }
  }

  Future<void> askForPermissions() async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    var photosStatus = await Permission.photos.status;
    var notificationStatus = await Permission.notification.status;
    if (cameraStatus.isDenied || storageStatus.isDenied || photosStatus.isDenied || notificationStatus.isDenied) {
      await [
        Permission.camera,
        Permission.storage,
        Permission.photos,
        Permission.notification,
      ].request();
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<File?> croppedFile(File file) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
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
              toolbarColor: primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'crop_rotate'.tr,
          )
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      logger.e(e);
      return null;
    }
  }


  Future<void> sendFeedback({
    required BuildContext context,
    required String subject,
    required String message,
    required String uid,
  }) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        const url = "baseUrl/sendFeedback";
        final response = await httpClient.post(Uri.parse(url), body: {
          'message': message,
          'subject': subject,
          'uid': uid,
        });
        logger.i(response.body);
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final status = jsonResponse['state'] ?? '';
          if (status != null && status == 'succeeded') {
            showSnack(type: SnackBarType.success, title: jsonResponse['message']);
          } else {
            showSnack(type: SnackBarType.error, title: jsonResponse['message']);
          }
        }
        LoadingDialog.hide(context: context);
      } else {
        showSnack(type: SnackBarType.unconnected);
      }
    } catch (e) {
      LoadingDialog.hide(context: context);
      logger.e('$e');
    }
  }


  String enumToString(var val) {
    return describeEnum(val);
  }

  Future<void> subscribeToTopic() async {
    try {
      DocumentSnapshot doc = await settingsRef.doc(Keys.topics).get();
      if (doc.exists) {
        final json = doc.data() as Map<String, dynamic>;
        List<dynamic> list = json['topics'] ?? [];
        if (list.isNotEmpty) {
          List<TopicModel> topics = list.map<TopicModel>((item) => TopicModel.fromJson(item)).toList();
          for (TopicModel model in topics) {
            if (!boxSettings.containsKey(model.id)) {
              await FirebaseMessaging.instance.subscribeToTopic(model.topic);
              await boxSettings.put(model.id, model.topic);
            } else {
              await FirebaseMessaging.instance.unsubscribeFromTopic(model.topic);
            }
          }
        }
      }
    } catch(e) {
      logger.e(e);
    }
  }

  int random(min, max) {
    return min + Random().nextInt(max - min);
  }

  //! ------------------------ Gifts ------------------------
  Future<void> uploadGifts(BuildContext context, List<GiftModel> files) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        List<GiftModel> giftsWithdownloadUrl = [];

        for (GiftModel model in files) {
          String name = basename(model.image);
          String? typeImage = mime(name);
          logger.i('name: $name, type: $typeImage');
          final ref = storage.ref('${Keys.settings}/${Keys.gifts}/${model.id}$name');
          final metadata = SettableMetadata(
            contentType: '$typeImage',
            customMetadata: {'picked-file-path': model.image},
          );

          await ref.putFile(File(model.image), metadata).then((TaskSnapshot snapshot) async {
            final url = await snapshot.ref.getDownloadURL();
            logger.i('DownloadURL: $url');
            giftsWithdownloadUrl.add(GiftModel(id: model.id, image: url));
          });
        }

        logger.i('Urls: $giftsWithdownloadUrl');
        giftsWithdownloadUrl.addAll(state.gifts);
        await giftsRef.set({
          Keys.gifts: (giftsWithdownloadUrl.isEmpty) ? [] :
          giftsWithdownloadUrl.map((item) => item.toJson()).toList(),
        }, SetOptions(merge: true));

        await getGifts();
        LoadingDialog.hide(context: context);
        showSnack(type: SnackBarType.success,
          message: 'successfully_uploaded'.tr
        );
      } else {
        showSnack(type: SnackBarType.unconnected);
      }
    } catch (e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      showSnack(type: SnackBarType.error, message: '$e');
    }
  }

  Future<void> getGifts() async {
    try {
      DocumentSnapshot doc = await giftsRef.get();
      if (doc.exists) {
        final json = doc.data() as Map<String, dynamic>;
        List<dynamic> list = json[Keys.gifts] ?? [];
        if (list.isNotEmpty) {
          state.gifts = list.map<GiftModel>((item) => GiftModel.fromJson(item)).toList();
          update();
        } else {
          state.gifts.clear();
          update();
        }
      }
    } catch(e) {
      logger.e(e);
    }
  }

  Future<bool> deleteGiftDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'delete_img'.tr,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              "delete_img_msg".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                child: Text(
                  'cancel'.tr,
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text(
                  'delete'.tr,
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        },
    ) ?? false;
  }

  Future<void> deleteGift({
    required BuildContext context,
    required GiftModel model
  }) async {
    try {
      LoadingDialog.show(context: context);
      await delteImageFromStorage(model.image);
      final index = state.gifts.indexWhere((element) => element.id == model.id);
      if (index != -1) {
        state.gifts.removeAt(index);
        await giftsRef.set({
          Keys.gifts: (state.gifts.isEmpty) ? [] :
          state.gifts.map((item) => item.toJson()).toList(),
        }, SetOptions(merge: true));
      }
      await getGifts();
      LoadingDialog.hide(context: context);
    } catch(e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      utilsLogic.showSnack(type: SnackBarType.error,
          message: '$e'
      );
    }
  }


  //! ------------------------ Frames ------------------------
  Future<void> uploadFrames(BuildContext context, List<FrameModel> files) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        List<FrameModel> framesWithdownloadUrl = [];

        for (FrameModel model in files) {
          String name = basename(model.image);
          String? typeImage = mime(name);
          logger.i('name: $name, type: $typeImage');
          final ref = storage.ref('${Keys.settings}/${Keys.frames}/${model.id}$name');
          final metadata = SettableMetadata(
            contentType: '$typeImage',
            customMetadata: {'picked-file-path': model.image},
          );

          await ref.putFile(File(model.image), metadata).then((TaskSnapshot snapshot) async {
            final url = await snapshot.ref.getDownloadURL();
            logger.i('DownloadURL: $url');
            framesWithdownloadUrl.add(FrameModel(id: model.id, image: url));
          });
        }

        logger.i('Urls: $framesWithdownloadUrl');
        framesWithdownloadUrl.addAll(state.frames);
        await framesRef.set({
          Keys.frames: (framesWithdownloadUrl.isEmpty) ? [] :
          framesWithdownloadUrl.map((item) => item.toJson()).toList(),
        }, SetOptions(merge: true));
        await getFrames();
        LoadingDialog.hide(context: context);
        showSnack(type: SnackBarType.success,
            message: 'successfully_uploaded'.tr
        );
      } else {
        showSnack(type: SnackBarType.unconnected);
      }
    } catch (e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      showSnack(type: SnackBarType.error, message: '$e');
    }
  }

  Future<void> getFrames() async {
    try {
      DocumentSnapshot doc = await framesRef.get();
      if (doc.exists) {
        final json = doc.data() as Map<String, dynamic>;
        List<dynamic> list = json[Keys.frames] ?? [];
        if (list.isNotEmpty) {
          state.frames = list.map<FrameModel>((item) => FrameModel.fromJson(item)).toList();
          update();
        } else {
          state.frames.clear();
          update();
        }
      }
    } catch(e) {
      logger.e(e);
    }
  }

  Future<bool> deleteFrameDialog(BuildContext context) async {
    return await showDialog(context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'delete_img'.tr,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            "delete_img_msg".tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text(
                'cancel'.tr,
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text(
                'delete'.tr,
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<void> deleteFrame({
    required BuildContext context,
    required FrameModel model
  }) async {
    try {
      LoadingDialog.show(context: context);
      await delteImageFromStorage(model.image);
      final index = state.frames.indexWhere((element) => element.id == model.id);
      if (index != -1) {
        state.frames.removeAt(index);
        await framesRef.set({
          Keys.frames: (state.frames.isEmpty) ? [] :
          state.frames.map((item) => item.toJson()).toList(),
        }, SetOptions(merge: true));
      }
      await getFrames();
      LoadingDialog.hide(context: context);
    } catch(e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e'
      );
    }
  }

  Future<void> delteImageFromStorage(String url) async {
    var fileUrl = Uri.decodeFull(basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');
    return await storage.ref(fileUrl).delete();
  }


  Future<String?> renewToken(String channelName) async {
    try {
      if (networkState.isConnected) {
        // final doc = await roomsRef.doc(channelName).get();
        // final json = doc.data() as Map<String, dynamic>;
        // final room = RoomModel.fromJson(json);
        // final now = DateTime.now();
        // final difference = now.difference(room.renewTimestamp).inMinutes;
        // if (difference <= 10) return room.token;
        const url = "$baseUrl/renewTokenRoom";
        final response = await http.post(Uri.parse(url),
          headers: {'authorization': '${userState.idToken}'},
          body: {'channelName': channelName}
        );
        logger.i('renewTokenRoom: ', response.body);
        final jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final success = jsonResponse['success'] ?? false;
          if (success) {
            return jsonResponse['token'];
          }
        } else {
          showSnack(type: SnackBarType.error,
            message: jsonResponse['message']
          );
        }
      } else {
        showSnack(type: SnackBarType.unconnected);
      }
    } catch(e) {
      logger.e('$e');
      showSnack(
        type: SnackBarType.error,
        message: '$e'
      );
    }
    return null;
  }


  Future<void> checkMemberIds(String idRoom) async {
    await roomsRef.doc(idRoom).update({
      'memberIds': FieldValue.arrayUnion([
        auth.currentUser!.uid,
      ])
    });
    // final ref = roomsRef.doc(idRoom);
    // DocumentSnapshot document = await ref.get();
    // final json = document.data() as Map<String, dynamic>;
    // final room = RoomModel.fromJson(json);
    // if (!room.memberIds!.contains(auth.currentUser!.uid)) {
    //   await ref.update({
    //     'memberIds': FieldValue.arrayUnion([
    //       auth.currentUser!.uid,
    //     ])
    //   });
    // }
  }


  bool checkFileIsAudio(String path) {
    try {
      List<String> typeFile = ['.mp3', '.wav', '.aac'];
      String extension = p.extension(path).split('?').first;
      return typeFile.contains(extension);
    } catch(e) {
      logger.e(e);
      return false;
    }
  }

  int createUniqueId([String? id]) {
    if (id != null) {
      return id.hashCode;
    } else {
      return UniqueKey().hashCode;
    }
  }

  Future<bool> onLeaveConfirmation(BuildContext context) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  Text('keep'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(true),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.power_settings_new,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  Text('exit'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  String accountCreateAt(UserModel account) {
    try {
      return timeago.format(account.createdAt, locale: 'en_short');
    } catch (e) {
      return '';
    }
  }

  Future<bool> updateAge(BuildContext context, NavigatorState navigator) async {
    DateTime? dateBirth;
    return await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('enter_your_date_birth'.tr,
          textAlign: TextAlign.center,
        ),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: userState.user?.dateBirth ?? DateTime(1969, 1, 1),
            onDateTimeChanged: (DateTime date) {
              // duration = AgeCalculator.age(date);
              dateBirth = date;
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => navigator.pop(false),
          ),
          TextButton(
            child: Text('save'.tr),
            onPressed: () async {
              if (dateBirth != null) {
                LoadingDialog.show(context: context);
                bool success = await userLogic.updateAge(dateBirth!);
                if (context.mounted) LoadingDialog.hide(context: context);
                navigator.pop(success);
              }
            },
          ),
        ],
      );
    }) ?? false;
  }

  void setStateLoading(bool val) {
    state.isLoading = val;
    update();
  }


}