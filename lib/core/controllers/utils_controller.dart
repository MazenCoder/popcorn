// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:package_info/package_info.dart';
// import 'package:flutter/material.dart';
// import '../usecases/constants.dart';
// import '../model/user_model.dart';
// import '../model/room_model.dart';
// import '../usecases/enums.dart';
// import 'package:get/get.dart';
// import '../util/img.dart';
// import 'dart:math';
//
//
//
//
// class UtilsController extends GetxController {
//   static UtilsController instance = Get.find();
//
//   //! Version
//   String _version = '1.0.0';
//   String get version => _version;
//
//
//
//   @override
//   void onInit() {
//     initVersion();
//     super.onInit();
//   }
//
//   Future<void> initVersion({bool listener = false}) async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     String version = packageInfo.version;
//     _version = version;
//     if (listener) {
//       update();
//     }
//   }
//
//
//   showSnack({required SnackBarType type, String? title, String? message}) {
//     switch (type) {
//       case SnackBarType.error:
//         Get.snackbar(
//           title??'oops'.tr,
//           message ?? 'error_wrong'.tr,
//           icon: Icon(MdiIcons.alert, color: Colors.red[300]),
//           backgroundColor: Colors.white,
//           shouldIconPulse: true,
//           barBlur: 20,
//           isDismissible: true,
//           snackPosition: SnackPosition.BOTTOM,
//           borderColor: Colors.red[300],
//           borderWidth: 0.5,
//           margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
//           duration: const Duration(seconds: 4),
//           colorText: Colors.black,
//         );
//         return;
//       case SnackBarType.unconnected:
//         Get.snackbar(
//           title??'oops'.tr,
//           message ?? 'error_connection'.tr,
//           icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
//           backgroundColor: Colors.white,
//           shouldIconPulse: true,
//           barBlur: 20,
//           isDismissible: true,
//           snackPosition: SnackPosition.BOTTOM,
//           borderColor: Colors.red[300],
//           borderWidth: 0.5,
//           margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
//           duration: const Duration(seconds: 4),
//           colorText: Colors.black,
//         );
//         return;
//       case SnackBarType.info:
//         Get.snackbar(
//           title??'oops'.tr,
//           message??'',
//           icon: Icon(MdiIcons.informationOutline, color: Colors.orange[600]),
//           backgroundColor: Colors.white,
//           shouldIconPulse: true,
//           barBlur: 20,
//           isDismissible: true,
//           snackPosition: SnackPosition.BOTTOM,
//           borderColor: Colors.orange[600],
//           borderWidth: 0.5,
//           margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
//           duration: const Duration(seconds: 4),
//           colorText: Colors.black,
//         );
//         return;
//       case SnackBarType.success:
//         Get.snackbar(
//           title??'',
//           message??'',
//           icon: Icon(MdiIcons.checkboxMarkedCircleOutline, color: Colors.green[300]),
//           backgroundColor: Colors.white,
//           shouldIconPulse: true,
//           barBlur: 20,
//           isDismissible: true,
//           snackPosition: SnackPosition.BOTTOM,
//           borderColor: Colors.green[300],
//           borderWidth: 0.5,
//           margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
//           duration: const Duration(seconds: 4),
//           colorText: Colors.black,
//         );
//         return;
//     }
//   }
//
//
//   bool isLocalFilePath(String path) {
//     Uri uri = Uri.parse(path);
//     return !uri.scheme.contains('http');
//   }
//
//   bool isVideo(String path) {
//     bool output = false;
//     for (var videoFormat in videoFormats) {
//       if (path.toLowerCase().contains(videoFormat)) output = true;
//     }
//     return output;
//   }
//
//   bool isImage(String path) {
//     bool output = false;
//     for (var imageFormat in imageFormats) {
//       if (path.toLowerCase().contains(imageFormat)) output = true;
//     }
//     return output;
//   }
//
//   bool isPdf(String path) {
//     bool output = false;
//     for (var pdfFormat in pdfFormats) {
//       if (path.toLowerCase().contains(pdfFormat)) output = true;
//     }
//     return output;
//   }
//
//
//   bool isUser(String email) {
//     bool output = false;
//     for (var emailFormat in emailFormats) {
//       if (email.toLowerCase().contains(emailFormat)) output = true;
//     }
//     return output;
//   }
//
//   int random(min, max) {
//     return min + Random().nextInt(max - min);
//   }
//
// }