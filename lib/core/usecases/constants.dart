import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../controllers/notification/notification_logic.dart';
import '../controllers/notification/notification_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/rooms/logic/room_logic.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/rooms/logic/room_state.dart';
import '../controllers/network/network_logic.dart';
import '../controllers/network/network_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/following_controller.dart';
import '../controllers/followers_controller.dart';
import '../controllers/utils/utils_logic.dart';
import '../controllers/utils/utils_state.dart';
import '../controllers/post_controllerl.dart';
import '../models/recieved_notification.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../controllers/chat/chat_logic.dart';
import '../controllers/chat/chat_state.dart';
import '../controllers/auth/auth_logic.dart';
import '../controllers/auth/auth_state.dart';
import '../controllers/user/user_logic.dart';
import '../controllers/user/user_state.dart';
import '../theme/generateMaterialColor.dart';
import 'package:http/http.dart' as http;
import '../langs/lang_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import '../util/app_utils.dart';
import 'package:intl/intl.dart';
import '../mobx/mobx_app.dart';
import 'package:get/get.dart';
import 'hive_utils.dart';
import 'enums.dart';
import 'keys.dart';
import 'dart:io';




// const Algolia algolia = Algolia.init(apiKey: '', applicationId: '');



final FirebaseMessaging firebaseMessaging = GetIt.I.get<FirebaseMessaging>();
final FirebaseFirestore firebaseFirestore = GetIt.I.get<FirebaseFirestore>();
final GoogleSignIn googleSignIn = GetIt.I.get<GoogleSignIn>();
final FirebaseStorage storage = GetIt.I.get<FirebaseStorage>();
final FirebaseAuth auth = GetIt.I.get<FirebaseAuth>();
// final AgoraRtmClient client = GetIt.I.get<AgoraRtmClient>();
final http.Client httpClient = GetIt.I.get<http.Client>();
final Directory directory = GetIt.I.get<Directory>();
final FacebookAuth facebookAuth = GetIt.I.get<FacebookAuth>();
final HiveUtils hiveUtils = GetIt.I.get<HiveUtils>();
final AppUtils appUtils = GetIt.I.get<AppUtils>();
final MobxApp mobxApp = MobxApp();
final Logger logger = Logger();
const int numLimit = 15;



final usersRef = firebaseFirestore.collection(Keys.users);
final roomsRef = firebaseFirestore.collection(Keys.rooms);
final companyDetails = firebaseFirestore.collection(Keys.companyDetails);
final chatsRef = firebaseFirestore.collection(Keys.chats);
final postsRef = firebaseFirestore.collection(Keys.posts);
final reportsRef = firebaseFirestore.collection(Keys.reports);
final bookingRef = firebaseFirestore.collection(Keys.bookings);
final iamonlineRef = firebaseFirestore.collection(Keys.iamonline);
final activitiesRef = firebaseFirestore.collection(Keys.activities);
// final galleryRef = firebaseFirestore.collection(Keys.gallery).doc(Keys.app);
final giftsRef = firebaseFirestore.collection(Keys.settings).doc(Keys.gifts);
final framesRef = firebaseFirestore.collection(Keys.settings).doc(Keys.frames);
final topicsRef = firebaseFirestore.collection(Keys.settings).doc(Keys.topics);
final commentsRef = firebaseFirestore.collection(Keys.comments);
final likesRef = firebaseFirestore.collection(Keys.likes);

final experiencesRef = firebaseFirestore.collection(Keys.experiences);
final educationsRef = firebaseFirestore.collection(Keys.educations);

final hashtagsRef = firebaseFirestore.collection(Keys.hashtags);
final followersRef = firebaseFirestore.collection(Keys.followers);
final followingRef = firebaseFirestore.collection(Keys.following);
final settingsRef = firebaseFirestore.collection(Keys.settingsRef);



///!  --------- Init Controllers ---------

// UserController userController = userLogic.instance;

// UtilsController utilsController = UtilsController.instance;
PostController postController = PostController.instance;
FollowersController followersController = FollowersController.instance;
FollowingController followingController = FollowingController.instance;


//! RoomLogic
final RoomLogic roomLogic = RoomLogic.instance;
final RoomState roomState = roomLogic.state;


//! NetworkLogic
final NetworkLogic networkLogic = NetworkLogic.instance;
final NetworkState networkState = networkLogic.state;

//! Utils
final UtilsLogic utilsLogic = UtilsLogic.instance;
final UtilsState utilsState = utilsLogic.state;

//! Auth
final AuthLogic authLogic = AuthLogic.instance;
final AuthState authState = authLogic.state;

//! User
final UserLogic userLogic = UserLogic.instance;
final UserState userState = userLogic.state;

//! Lang
final LangController langController = LangController.instance;

//! NotificationLogic
final NotificationLogic notificationLogic = NotificationLogic.instance;
final NotificationState notificationState = notificationLogic.state;

//! ChatLogic
final ChatLogic chatLogic = ChatLogic.instance;
final ChatState chatState = chatLogic.state;


const String baseUrl = 'https://us-central1-popcorn-e7b6a.cloudfunctions.net';
const String googleApiKey = 'AIzaSyBSLCHYeZFSC7FUk1_x48sjLaTrUWUjBpw';
final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
final DateFormat timeFormat = DateFormat('E, h:mm a');
final DateFormat experienceFormat = DateFormat('MMM yyyy');

const tagsCopywrit = 'assets/jsons/tagsCopywrit.json';
const jsonValues = 'assets/jsons/values.json';
String ignoreNotification = '';



const appId = "fce59074f58a4404a95b80695ce6a654";
const token = "d99affb30cfe4410a2edf78aae757712";
const appKey = "41365060#440523";
const chatToken = "007eJxTYMjVZ11++9glxmNCnYxiOTfV987evibqD8/XLXFfJ4ZrSMsrMKQlp5paGpibpJlaJJqYGJgkWpomWRiYWZomp5olmpmaqAuXJDcEMjKs3tLIzMjAysDIwMQA4jMwAABLKxxX";
const userId = "007eJxTYMjVZ11++9glxmNCnYxiOTfV987evibqD8/XLXFfJ4ZrSMsrMKQlp5paGpibpJlaJJqYGJgkWpomWRiYWZomp5olmpmaqAuXJDcEMjKs3tLIzMjAysDIwMQA4jMwAABLKxxX";


//! Stripe Keys Live
// const publishableKeyLive = "";
// const secretKeyLive = "";


/* Text Mazen GBP
product 1. "Taster" - 1 Month - 2 week free trial - £60
    price_1Kqp8DBLaDR5PPhpt9UnM1aQ

Product 2: "Experimental" - 3 months - £120 - 2 week free trial
    price_1KqpA4BLaDR5PPhpigzTeSbg

Product 3: "Pro" - 12 Months (1 yr) - £250 - 2 week trial
    price_1KqpBFBLaDR5PPhpulP9ob50
*/

//! Mazen Stripe Test
const publishableKeyTest = "pk_test_lkckPCId8eLaPAo3vGTnO7ap";
const secretKeyTest = "sk_test_R3iKqaD0DL4hePu4zPCwEfln";



final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

final DateFormat formatStart = DateFormat('MMM yyyy');
final DateFormat formatCompany = DateFormat("yyyy-MM-dd");



const List<String> videoFormats = [
  '.mp4',
  '.mov',
  '.avi',
  '.wmv',
  '.3gp',
  '.3gpp',
  '.mkv',
  '.flv'
];
const List<String> imageFormats = [
  '.jpeg',
  '.png',
  '.jpg',
  '.gif',
  '.webp',
  '.tif',
  '.heic'
];


const List<String> pdfFormats = [
  '.pdf',
];

const List<String> emailFormats = [
  '@gmail.com',
  '@yahoo.com',
  '@hotmail.com',
  '@ol.com'
];


Map<int, String> employmentType = {
  0: "full_ime".tr,
  1: "part_time".tr,
  2: "self_employed".tr,
  3: "freelance".tr,
  4: "contract".tr,
  5: "internship".tr,
  6: "apprenticeship".tr,
  7: "seasonal".tr,
  8: "undefined".tr,
};

Map<int, String> stageType = {
  0: "school_leaver".tr,
  1: "apprentice".tr,
  2: "1st_uni".tr,
  3: "2nd_uni".tr,
  4: "3nd_uni".tr,
  5: "postgraduate".tr,
  6: "1st_jobber".tr,
  7: "2st_jobber".tr,
  8: "3st_jobber".tr,
  9: "experience_prof".tr,
  10: "undefined".tr,
};




Map<int, String> visibilityOptions = {
  0: "anyone".tr,
  1: "connections_only".tr,
  2: "anonymous".tr,
};

Map<int, String> typesPost = {
  0: "advice".tr,
  1: "question".tr,
  2: "opinion".tr,
  3: "achievement".tr,
  4: "news".tr,
  5: "meme".tr,
};

Map<int, String> visibilitySubTitle = {
  0: "anyone_sub".tr,
  1: "connections_only_sub".tr,
  2: "anonymous_sub".tr,
};

Map<int, String> reportAndBlock = {
  0: "posts_comments".tr,
  1: "messages".tr,
  3: "profile_info".tr,
  4: "background_profile_photo".tr,
};

Map<int, Icon> visibilityIcon = {
  0: const Icon(MdiIcons.earth),
  1: const Icon(MdiIcons.accountGroup),
  2: const Icon(MdiIcons.incognito),
};

Map<int, Icon> visibilityIconPost = {
  0: const Icon(MdiIcons.earth, size: 11, color: Colors.black54),
  1: const Icon(MdiIcons.accountGroup, size: 11, color: Colors.black54),
  2: const Icon(MdiIcons.incognito, size: 11, color: Colors.black54),
};


Map<int, String> websiteText = {
  0: "web".tr,
  1: "linkedin".tr,
  2: "facebook".tr,
  3: "instagram".tr,
};

Map<int, int> monthsText = {
  0: 1,
  1: 6,
  2: 12,
};

Map<int, String> plansText = {
  0: "plan1".tr,
  1: "plan2".tr,
  2: "plan3".tr,
};

Map<int, String> plans = {
  0: "price_1KqpBFBLaDR5PPhpulP9ob50",
  1: "price_1KqpA4BLaDR5PPhpigzTeSbg",
  2: "price_1Kqp8DBLaDR5PPhpt9UnM1aQ",
};


Map<int, String> statusUser = {
  0: "actively".tr,
  1: "banned".tr,
  2: "archive".tr,
  3: "delete".tr,
};

// Map<int, String> statusModel = {
//   0: "actively".tr,
//   1: "banned".tr,
//   2: "archive".tr,
//   3: "delete".tr,
// };

Map<int, String> statusRoom = {
  0: "actively".tr,
  1: "banned".tr,
  2: "archive".tr,
  3: "delete".tr,
};

Map<int, String> micOption = {
  0: "take_mic".tr,
  1: "lock_mic".tr,
  2: "cancel".tr,
};

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: Keys.rateApp,
  minDays: 3, minLaunches: 7,
  remindDays: 2, remindLaunches: 5,
  googlePlayIdentifier: 'com.popcorn.app.popcorn',
  appStoreIdentifier: 'com.popcorn.app.popcorn',
);

// final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.max, ledColor: primaryColor
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<RecievedNotification> didReceiveNotificationSubject = BehaviorSubject<RecievedNotification>();


final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
    notificationCategories: [
      DarwinNotificationCategory(
        'demoCategory',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'id_3', 'Action 3',
            buttonTitle: 'Action 3',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ],
);

Future<void> initializePlatformSpecifics() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/ic_stat_name');
  final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: notificationLogic.onDidReceiveNotificationResponse,
  );
}


handleNotifications() async {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getInitialMessage()
      .then((value) => value != null ? firebaseMessagingBackgroundHandler : false);
  return;
}


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) await Firebase.initializeApp();
  // log('Handling a background message ${message.messageId}');
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  AppleNotification? apple = message.notification?.apple;
  if (notification != null) {

  }
}

extension LayoutModeExtension on LayoutMode {
  String get text {
    var mapValues = {
      LayoutMode.defaultLayout: "default",
      LayoutMode.full: "full",
      LayoutMode.hostTopCenter: "host top center",
      LayoutMode.hostCenter: "host center",
    };

    return mapValues[this]!;
  }
}