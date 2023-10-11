import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../../features/account/pages/fb_google_sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/generateMaterialColor.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import '../usecases/constants.dart';
import 'package:get/get.dart';
import 'error_app.dart';



late Widget _home;


class SplashApp extends StatefulWidget {

  SplashApp({
    required Widget home,
    Key? key,
  }) : super(key: key) {
    _home = home;
  }

  @override
  _SplashAppState createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {

  late AssetImage bgImage;
  late Image logoImage;

  @override
  void initState() {
    logoImage = Image.asset(
      IMG.logo2,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
    bgImage = const AssetImage(IMG.splash);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initServices());
    super.initState();
  }


  Future<void> _initServices() async {
    try {
      await networkLogic.hasConnection();
      if (networkState.isConnected) {
        User user = auth.currentUser!;
        await userLogic.initUser(user);
        await roomLogic.getMyRoom();
        if (userState.user == null) {
          await authLogic.signOut();
          Get.offAll(() => const FbGoogleSignInPage());
        } else {
          Get.offAll(() => _home);
        }
      } else {
        Get.offAll(() => ErrorApp(
          message: 'error_connection'.tr,
        ));
      }
    } catch (e) {
      logger.e('$e');
      Get.offAll(() => ErrorApp(message: '$e'));
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(logoImage.image, context);
    precacheImage(bgImage, context);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: bgImage,
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RippleAnimation(
                    repeat: true,
                    color: Colors.white.withOpacity(0.2),
                    minRadius: 38,
                    ripplesCount: 25,
                    child: ClipOval(
                      child: Container(
                        color: primaryColor,
                        width: Get.width / 1.8,
                        height: Get.width / 1.8,
                        padding: const EdgeInsets.all(30),
                        child: logoImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
