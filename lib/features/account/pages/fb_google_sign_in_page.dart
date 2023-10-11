import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:popcorn/features/account/pages/sign_in_page.dart';
import 'package:popcorn/features/account/pages/sign_up_page.dart';
import 'package:popcorn/core/widgets_helper/splash_app.dart';
import '../../../core/usecases/constants.dart';
import '../../navigation/navigation_app.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;



class FbGoogleSignInPage extends StatefulWidget {
  const FbGoogleSignInPage({Key? key}) : super(key: key);
  @override
  _FbGoogleSignInPageState createState() => _FbGoogleSignInPageState();
}

class _FbGoogleSignInPageState extends State<FbGoogleSignInPage>
    with SingleTickerProviderStateMixin {

  late AnimationController animController;
  late Animation<double> animation;

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  void _initAnimation() {
    try {
      animController = AnimationController(
        duration: const Duration(seconds: 5),
        vsync: this,
      );
      final curvedAnimation = CurvedAnimation(
        reverseCurve: Curves.easeOut,
        parent: animController,
        curve: Curves.easeIn,
      );

      animation = Tween<double>(
          begin: 0, end: 2 * math.pi).animate(curvedAnimation)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            animController.forward();
          }}
        );
      animController.forward();
    } catch(e) {
      animController.dispose();
    }
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeTransition(
                            opacity: animation,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Image.asset(
                                IMG.logo2,
                                height: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('enjoy_life'.tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6?.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        Text('not_alone'.tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),

                    SizedBox(height: Get.height/5),
                    Column(
                      children: [
                        SizedBox(
                          width: Get.width - 100,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.theme.primaryColor,
                            ),
                            icon: Icon(MdiIcons.google),
                            label: Text('sign_in_google'.tr),
                            onPressed: () async {
                              final user = await authLogic.signInWithGoogle(context);
                              if (user != null) {
                                Get.to(() => SplashApp(
                                  home: const NavigationApp(),
                                ));
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          width: Get.width - 100,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.theme.primaryColor,
                            ),
                            icon: Icon(MdiIcons.facebook),
                            label: Text('sign_in_facebook'.tr),
                            onPressed: () async {
                              final user = await authLogic.signInWithFacebook();
                              if (user != null) {
                                Get.to(() => SplashApp(
                                  home: const NavigationApp(),
                                ));
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          width: Get.width - 100,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.theme.primaryColor,
                            ),
                            icon: Icon(MdiIcons.email),
                            label: Text('sign_with_email'.tr),
                            onPressed: ()=> Get.to(() => const SignInPage()),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('dont_have_account'.tr,
                                style: Get.textTheme.titleSmall
                            ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () => Get.to(() => const SignUpPage()),
                              child: Text('register'.tr,
                                style: Get.textTheme.titleSmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
