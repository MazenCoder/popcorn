import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../theme/generateMaterialColor.dart';
import '../../models/message_notify_model.dart';
import 'package:flutter/foundation.dart';
import '../../usecases/constants.dart';
import '../../usecases/enums.dart';
import 'notification_state.dart';
import 'package:get/get.dart';
import 'dart:convert';



class NotificationLogic extends GetxController {
  static NotificationLogic instance = Get.find();
  final state = NotificationState();

  @override
  void onInit() {
    initNotificationFirebase();
    super.onInit();
  }

  @override
  void onReady() {
    getToken();
    messagingListeners();
    super.onReady();
  }

  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();
  // }

  Future<void> initNotificationFirebase() async {

    final settings = await firebaseMessaging.requestPermission(
      criticalAlert: false,
      announcement: false,
      provisional: false,
      carPlay: false,
      badge: true,
      alert: true,
      sound: true,
    );

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    logger.i('User granted permission: ${settings.authorizationStatus}');
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      logger.i('User granted provisional permission');
    } else {
      logger.i('User declined or has not accepted permission');
    }
    // await getToken();
  }


  Future<void> getToken() async {
    state.token = await firebaseMessaging.getToken();
    update();
    logger.v('token: ${state.token}');
  }

  Future<void> deleteToken() async {
    return await firebaseMessaging.deleteToken();
  }

  void messagingListeners() {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        logger.i('onMessage', message.data);
        if (message.data.isNotEmpty) {
          _createNotification(message);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        logger.i('onMessageOpenedApp', message.data);
        if(message.data.isNotEmpty) {
          var data = json.encode(message.data);
          MessageNotifyModel msg = messageNotifyModelFromJson(data);
          if (msg.action == describeEnum(ActionNotification.chatMessage)) {

          }
        } else {
          NotificationAppLaunchDetails? details = await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
          if (details != null && details.didNotificationLaunchApp) {

          }
        }
      });

      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
        logger.i('getInitialMessage', message?.data);
        if(message != null && message.data.isNotEmpty) {
          var data = json.encode(message.data);
          MessageNotifyModel msg = messageNotifyModelFromJson(data);
          if (msg.action == describeEnum(ActionNotification.chatMessage)) {

          }
        } else {
          NotificationAppLaunchDetails? details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
          if (details != null) {

          }
        }
      });
    } catch(e) {
      logger.e(e);
    }
  }

  void _createNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    var data = json.encode(message.data);
    MessageNotifyModel msg = messageNotifyModelFromJson(data);
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      notification?.title??'',
      notification?.body??'',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          priority: Priority.high,
          importance: Importance.max,
          icon: android?.smallIcon,
          color: primaryColor,
          playSound: true,
          // sound: const RawResourceAndroidNotificationSound('positive')
          // other properties...
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: data,
    );
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      MessageNotifyModel msg = messageNotifyModelFromJson(payload);
      if (msg.action == describeEnum(ActionNotification.chatMessage)) {

      }
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }

  }
}