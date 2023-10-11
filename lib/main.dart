import 'package:popcorn/core/controllers/network/network_logic.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/controllers/notification/notification_logic.dart';
import 'features/account/pages/fb_google_sign_in_page.dart';
import 'core/controllers/following_controller.dart';
import 'core/controllers/followers_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/controllers/utils/utils_logic.dart';
import 'features/navigation/navigation_app.dart';
import 'core/controllers/rooms_controller.dart';
import 'core/controllers/post_controllerl.dart';
import 'core/controllers/user/user_logic.dart';
import 'core/controllers/chat/chat_logic.dart';
import 'core/controllers/auth/auth_logic.dart';
import 'core/theme/generateMaterialColor.dart';
import 'features/rooms/logic/room_logic.dart';
import 'core/widgets_helper/splash_app.dart';
import 'core/langs/lang_controller.dart';
import 'package:flutter/cupertino.dart';
import 'core/injection/injection.dart';
import 'core/usecases/hive_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'core/usecases/functions.dart';
import 'core/usecases/constants.dart';
import 'core/langs/translation.dart';
import 'core/theme/app_theme.dart';
import 'core/usecases/boxes.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';





void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureInjection(Env.dev);
  await HiveUtils.init();
  Get.put(NetworkLogic(), permanent: true);
  Get.put(NotificationLogic(), permanent: true);
  Get.put(RoomLogic(), permanent: true);
  Get.put(UserLogic(), permanent: true);
  Get.put(ChatLogic(), permanent: true);
  Get.put(AuthLogic(), permanent: true);
  Get.put(PostController());
  Get.put(FollowersController());
  Get.put(FollowingController());
  // Get.put(UtilsController());
  Get.put(RoomsController());
  Get.put(LangController());
  Get.put(UtilsLogic());
  handleNotifications();
  await initializePlatformSpecifics();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await FirebaseNotifications.setUpFirebase();
  // runZonedGuarded(() {
  //   runApp(const MyApp());
  // }, (error, stack) {
  //   if (kDebugMode) {
  //     log('Error Zoned Guarded: $error');
  //   }
  //   // exit(1);
  // });
  computeOnline();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final box = Boxes.settings();
    final locale = langController.getLocale();
    return Container(
      color: primaryColor,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: GetMaterialApp(
          translations: Translation(),
          initialRoute: auth.currentUser == null ? '/FbGoogleSignInPage' : '/SplashApp',
          getPages: [
            GetPage(name: '/FbGoogleSignInPage', page: () => const FbGoogleSignInPage()),
            GetPage(name: '/SplashApp', page: () => SplashApp(
              home: const NavigationApp(),
            )),
          ],
          title: 'Popcorn',
          locale: locale,
          fallbackLocale: locale,
          debugShowCheckedModeBanner: false,
          themeMode: utilsState.themeStateMode,
          theme: AppTheme.customLightTheme,
          darkTheme: AppTheme.customDarkTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          // home: SplashApp(
          //   home: const NavigationApp(),
          // ),
        ),
      ),
    );
  }
}


// -> soundWaveColor:
// -> microphoneOffFlag()
// -> ZegoMenuBarButtonName.giftAndFrame,
// -> topBar(), closeButton()