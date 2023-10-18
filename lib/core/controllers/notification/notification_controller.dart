import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../models/reminder_notification.dart';
import '../../models/message_notify_model.dart';
import '../../theme/generateMaterialColor.dart';
import 'package:flutter/foundation.dart';
import '../../usecases/constants.dart';
import 'package:rxdart/rxdart.dart';
import '../../usecases/enums.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';



final BehaviorSubject<ReminderNotification> didReceiveNotificationSubject = BehaviorSubject<ReminderNotification>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.max,
  playSound: true,
);



class NotificationController {

  static String? firebaseAppToken;
  static bool isInitialize = false;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  static Future<void> initializeLocalNotifications({required bool debug}) async {
    if (isInitialize == false) {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/ic_stat_name');
      var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) {
          ReminderNotification receivedNotification = ReminderNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveNotificationSubject.add(receivedNotification);
        },
      );
      final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      isInitialize = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: selectNotification,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      ) ?? false;
    }
    await getFirebaseMessagingToken();
    debugPrint('isInitialize: $isInitialize');
    debugPrint('firebaseAppToken: $firebaseAppToken');
  }


  static Future<void> registerNotification() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('settings: ${settings.authorizationStatus}');

    if (GetPlatform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<void> startListeningNotificationEvents() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    FirebaseMessaging.onMessage.listen(_handleMessage);

    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Getting details on if the app was launched
    final notifyAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    String? payload = notifyAppLaunchDetails?.notificationResponse?.payload;
    debugPrint('NotificationResponse payload: $payload');
    if ((notifyAppLaunchDetails?.didNotificationLaunchApp??false) && payload != null) {
      final message = MessageNotifyModel.fromJson(json.decode(payload));
      if (message.action == describeEnum(ActionNotification.friendRequest)) {

      } else if (message.action == describeEnum(ActionNotification.notification)) {

      } else if (message.action == describeEnum(ActionNotification.startChat)) {

      } else if (message.action == describeEnum(ActionNotification.feedback)) {

      } else if (message.action == describeEnum(ActionNotification.chatMessage)) {

      }
    }
  }


  static Future<String?> getFirebaseMessagingToken() async {
    firebaseAppToken = await firebaseMessaging.getToken();
    return firebaseAppToken;
  }

  static void selectNotification(NotificationResponse details) async {
    final String? payload = details.payload;
    debugPrint('NotificationResponse payload: $payload');
    if (payload != null) {
      final message = MessageNotifyModel.fromJson(json.decode(payload));
      if (message.action == describeEnum(ActionNotification.friendRequest)) {

      } else if (message.action == describeEnum(ActionNotification.notification)) {

      } else if (message.action == describeEnum(ActionNotification.startChat)) {

      } else if (message.action == describeEnum(ActionNotification.feedback)) {

      } else if (message.action == describeEnum(ActionNotification.chatMessage)) {

      }
    }
  }

  static void _handleMessage(RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (message.data.isEmpty) return;
    var data = json.encode(message.data);
    final model = messageNotifyModelFromJson(data);
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      model.title,
      model.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          icon: android?.smallIcon,
          importance: Importance.max,
          priority: Priority.high,
          color: primaryColor,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
        ),
      ),
      payload: jsonEncode(model.toJsonModel()),
    );
  }

}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (message.data.isEmpty) return;
  var data = json.encode(message.data);
  final model = messageNotifyModelFromJson(data);
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    model.title,
    model.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        icon: android?.smallIcon,
        importance: Importance.max,
        priority: Priority.high,
        color: primaryColor,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
      ),
    ),
    payload: jsonEncode(model.toJsonModel()),
  );
}


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  debugPrint('NotificationResponse payload: $payload');
  if (payload != null) {
    final message = MessageNotifyModel.fromJson(json.decode(payload));
    if (message.action == describeEnum(ActionNotification.friendRequest)) {

    } else if (message.action == describeEnum(ActionNotification.notification)) {

    } else if (message.action == describeEnum(ActionNotification.startChat)) {

    } else if (message.action == describeEnum(ActionNotification.feedback)) {

    } else if (message.action == describeEnum(ActionNotification.chatMessage)) {

    }
  }
}