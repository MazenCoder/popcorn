// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import '../theme/generateMaterialColor.dart';
// import '../model/message_notify_model.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'constants.dart';
// import 'dart:convert';
// import 'enums.dart';
// import 'dart:async';
//
//
//
//
// class FirebaseNotifications {
//
//
//   static Future<void> setUpFirebase() async {
//
//     final settings = await firebaseMessaging.requestPermission(
//       criticalAlert: false,
//       announcement: false,
//       provisional: false,
//       carPlay: false,
//       badge: true,
//       alert: true,
//       sound: true,
//     );
//
//     await firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     logger.i('User granted permission: ${settings.authorizationStatus}');
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       logger.i('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       logger.i('User granted provisional permission');
//     } else {
//       logger.i('User declined or has not accepted permission');
//     }
//   }
//
//
//   static Future<String?> getToken() async {
//     return await firebaseMessaging.getToken();
//   }
//
//   static Future<void> deleteToken() async {
//     return await firebaseMessaging.deleteToken();
//   }
//
//   static void messagingListeners() {
//     try {
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//         if (message.data.isNotEmpty) {
//           logger.i(message.data);
//           _createNotification(message);
//         }
//       });
//
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//         if(message.data.isNotEmpty) {
//           var data = json.encode(message.data);
//           MessageNotifyModel msg = messageNotifyModelFromJson(data);
//           if (msg.action == describeEnum(ActionNotification.chatMessage)) {
//             // final user = cnx.read<AppNotifier>().user;
//             // Get.to(() => const TabUsers());
//
//           }
//         } else {
//           NotificationAppLaunchDetails? details = await flutterLocalNotificationsPlugin
//               .getNotificationAppLaunchDetails();
//           if (details != null && details.didNotificationLaunchApp) {
//             // var data = json.encode(details.payload);
//             // MessageNotifyModel msg = messageNotifyModelFromJson(data);
//             // if (msg.action == describeEnum(actionNotification.chatMessage)) {
//               // final user = cnx.read<AppNotifier>().user;
//               // Get.to(() => const TabUsers());
//             // }
//           }
//         }
//       });
//
//       FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
//         if(message != null && message.data.isNotEmpty) {
//           var data = json.encode(message.data);
//           MessageNotifyModel msg = messageNotifyModelFromJson(data);
//           if (msg.action == describeEnum(ActionNotification.chatMessage)) {
//             // final user = cnx.read<AppNotifier>().user;
//           }
//         } else {
//           NotificationAppLaunchDetails? details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//           if (details != null) {
//             // var data = json.encode(details.payload);
//             // MessageNotifyModel msg = messageNotifyModelFromJson(data);
//             // if (msg.action == describeEnum(actionNotification.chatMessage)) {
//             //   // Get.to(() => const TabUsers());
//             // }
//           }
//         }
//       });
//     } catch(e) {
//       logger.e(e);
//     }
//   }
//
//   static void _createNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     var data = json.encode(message.data);
//     MessageNotifyModel msg = messageNotifyModelFromJson(data);
//     if (ignoreNotification != msg.id) {
//       await flutterLocalNotificationsPlugin.show(
//         message.hashCode,
//         notification?.title??'',
//         notification?.body??'',
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             priority: Priority.high,
//             importance: Importance.max,
//             icon: android?.smallIcon,
//             color: primaryColor,
//             playSound: true,
//             // sound: const RawResourceAndroidNotificationSound('positive')
//             // other properties...
//           ),
//           iOS: const DarwinNotificationDetails(),
//         ),
//         payload: data,
//       );
//     }
//   }
//
//   static Future selectNotification(String? payload) async {
//     if (payload != null) {
//       MessageNotifyModel msg = messageNotifyModelFromJson(payload);
//       if (msg.action == describeEnum(ActionNotification.chatMessage)) {
//         // Get.to(() => const TabUsers());
//       }
//     }
//   }
//
//   static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//
//   }
// }
