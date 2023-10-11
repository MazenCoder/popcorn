import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/usecases/firebase_notifications.dart';
import 'package:popcorn/core/widgets_helper/loading_dialog.dart';
import '../../core/widgets_helper/responsive_safe_area.dart';
import '../../core/theme/generateMaterialColor.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../core/usecases/constants.dart';
import '../../core/mobx/mobx_app.dart';
import 'package:flutter/material.dart';
import '../rooms/pages/room_page.dart';
import '../pages/message_page.dart';
import '../pages/moments_page.dart';
import 'package:get/get.dart';
import 'dart:async';




class NavigationApp extends StatefulWidget {
  const NavigationApp({Key? key}) : super(key: key);

  @override
  _NavigationAppState createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> with AfterLayoutMixin<NavigationApp> {

  final PageController _pageController = PageController();
  final MobxApp _mobx = MobxApp();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(context);
      }
    });
    super.initState();
  }



  Future<bool> _onWillPop(BuildContext context) async {
    if (_mobx.currentIndex != 0) {
      _mobx.onPageChanged(0);
      return Future.value(false);
    } else {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            color: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text("app_name".tr,
              textAlign: TextAlign.center,
            ),
          ),
          content: Text('exit_app'.tr),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('no'.tr),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('yes'.tr),
            ),
          ],
        ),
      ) ?? false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (context) => WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          body: SizedBox.expand(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[
                RoomPage(),
                MomentsPage(),
                MessagePage(),
              ],
            ),
          ),
          bottomNavigationBar: Observer(
            builder: (_) => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: cardBackgroundColor,
              selectedItemColor: primaryColor,
              unselectedItemColor: secondaryColor,
              currentIndex: _mobx.currentIndex,
              onTap: (index) {
                _mobx.onPageChanged(index);
                _pageController.jumpToPage(index);
              },
              items: [
                BottomNavigationBarItem(
                  activeIcon:  const Icon(
                    MdiIcons.home,
                  ),
                  icon: const Icon(
                    MdiIcons.home,
                  ),
                  label: 'room'.tr,
                ),

                BottomNavigationBarItem(
                  activeIcon:  const Icon(
                    MdiIcons.adjust,
                  ),
                  icon: const Icon(
                    MdiIcons.adjust,
                  ),
                  label: 'moments'.tr,
                ),

                BottomNavigationBarItem(
                  activeIcon: const Icon(
                    MdiIcons.chatProcessing,
                    // color: Colors.white,
                  ),
                  icon: const Icon(
                    MdiIcons.chatProcessing,
                  ),
                  label: 'message'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    // FirebaseNotifications.messagingListeners();
    // await utilsLogic.askForPermissions();
    utilsLogic.subscribeToTopic();
  }
}