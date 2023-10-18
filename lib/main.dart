import 'package:popcorn/core/controllers/network/network_logic.dart';
import 'core/controllers/notification/notification_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'features/account2/screens/login_screen.dart';
import 'core/controllers/api_client/api_client.dart';
import 'core/controllers/following_controller.dart';
import 'core/controllers/followers_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/controllers/utils/utils_logic.dart';
import 'core/controllers/rooms_controller.dart';
import 'core/controllers/post_controllerl.dart';
import 'core/controllers/user/user_logic.dart';
import 'core/controllers/chat/chat_logic.dart';
import 'core/controllers/auth/auth_logic.dart';
import 'core/theme/generateMaterialColor.dart';
import 'features/rooms/logic/room_logic.dart';
import 'package:flutter/foundation.dart';
import 'core/langs/lang_controller.dart';
import 'package:flutter/cupertino.dart';
import 'core/injection/injection.dart';
import 'package:flutter/services.dart';
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
  await NotificationController.initializeLocalNotifications(debug: kDebugMode);
  Get.put(NetworkLogic(), permanent: true);
  Get.put(UserLogic(), permanent: true);
  Get.put(ApiClient(), permanent: true);
  // Get.put(RoomLogic(), permanent: true);
  Get.put(ChatLogic(), permanent: true);
  Get.put(AuthLogic(), permanent: true);
  Get.put(PostController());
  Get.put(FollowersController());
  Get.put(FollowingController());
  // Get.put(UtilsController());
  Get.put(RoomsController());
  Get.put(LangController());
  Get.put(UtilsLogic());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // computeOnline();
  // runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final box = Boxes.settings();
    final locale = languageLogic.getLocale();
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
          // initialRoute: auth.currentUser == null ? '/FbGoogleSignInPage' : '/SplashApp',
          // getPages: [
          //   GetPage(name: '/FbGoogleSignInPage', page: () => const FbGoogleSignInPage()),
          //   GetPage(name: '/SplashApp', page: () => SplashApp(
          //     home: const NavigationApp(),
          //   )),
          // ],
          title: 'Popcorn',
          locale: locale,
          fallbackLocale: locale,
          debugShowCheckedModeBanner: false,
          initialRoute: (auth.currentUser == null) ?
          '/LoginScreen' : '/SplashScreen',
          getPages: [
            GetPage(name: '/LoginScreen', page: () => const LoginScreen()),
            GetPage(name: '/SplashScreen', page: () => const SplashScreen()),
          ],
          themeMode: utilsState.themeStateMode,
          darkTheme: AppTheme.customDarkTheme,
          theme: AppTheme.customLightTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
