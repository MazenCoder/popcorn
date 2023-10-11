import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:popcorn/core/widgets_helper/splash_app.dart';
import '../../features/navigation/navigation_app.dart';
import 'package:popcorn/core/usecases/constants.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';



class ErrorApp extends StatelessWidget {
  final String? message;
  const ErrorApp({
    this.message, Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (context) => Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(IMG.jsonError,
                    height: Get.height/2.4
                  ),
                  const SizedBox(height: 5),
                  Text(message ?? 'error_wrong'.tr,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: Get.width - 100,
                    child: ElevatedButton.icon(
                      icon: const Icon(MdiIcons.refresh),
                      label: Text('try_again'.tr),
                      onPressed: () => Get.offAll(() => SplashApp(
                        home: const NavigationApp(),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: Get.width - 100,
                    child: ElevatedButton.icon(
                      icon: const Icon(MdiIcons.alert),
                      label: Text('reset'.tr),
                      onPressed: () async {
                        await authLogic.signOut();
                        Get.offAll(() => SplashApp(
                          home: const NavigationApp(),
                        ));
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
