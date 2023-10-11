import 'package:popcorn/packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/features/account/widgets/choose_language.dart';
import 'package:popcorn/features/account/pages/wallet_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:popcorn/core/controllers/user/user_logic.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../admin/presentation/pages/admin_page.dart';
import '../../../core/widgets_helper/splash_app.dart';
import 'package:popcorn/core/models/user_model.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../account/widgets/edit_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/usecases/constants.dart';
import '../../navigation/navigation_app.dart';
import 'package:popcorn/core/util/img.dart';
import '../../../core/usecases/enums.dart';
import '../widgets/user_modal_fit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_page.dart';
import 'dart:io';



class InfoAccountPage extends StatefulWidget {
  const InfoAccountPage({Key? key}) : super(key: key);

  @override
  _InfoAccountPageState createState() => _InfoAccountPageState();
}

class _InfoAccountPageState extends State<InfoAccountPage>
    with SingleTickerProviderStateMixin {


  late TabController _tabController;
  final picker = ImagePicker();

  @override
  initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      mobxApp.onTabChang(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              MdiIcons.accountDetails,
              color: Colors.white,
            ),
            onPressed: () => Get.to(() => EditProfile()),
          ),
        ],
      ),
      body: GetBuilder<UserLogic>(
        builder: (logic) {
          final user = logic.state.user!;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        userCircleAvatar(user, 40),
                        Positioned(
                          bottom: 4,
                          right: 0,
                          child: SizedBox(
                            height: 21,
                            width: 21,
                            child: Material(
                                type: MaterialType.transparency,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 2),
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(1000.0),
                                    onTap: () async {
                                      final action = await showMaterialModalBottomSheet(
                                        builder: (context) => const UserModalFit(),
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        expand: false,
                                      );
                                      await Future.delayed(const Duration(milliseconds: 600));
                                      if (action != null && action == ActionSelect.camera) {
                                        final pickedFile = await picker.pickImage(source: ImageSource.camera);
                                        if (pickedFile != null) {
                                          File? croppedFile = await utilsLogic.croppedFile(File(pickedFile.path));
                                          if (croppedFile != null) {
                                            if (!mounted) return;
                                            await userLogic.uploadPhotoProfile(croppedFile);
                                          }
                                        }
                                      } else if (action != null && action == ActionSelect.gallery) {
                                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                        if (pickedFile != null) {
                                          File? croppedFile = await utilsLogic.croppedFile(File(pickedFile.path));
                                          if (croppedFile != null) {
                                            if (!mounted) return;
                                            await userLogic.uploadPhotoProfile(croppedFile);
                                          }
                                        }
                                      }
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Get.to(() => ProfilePage(userModel: user)),
                          child: Text(user.displayName,
                            style: Get.textTheme.bodyText2?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text('ID: ${user.uniqueKey}',
                          style: Get.textTheme.bodyText2?.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1,
                          ),
                        ),

                        Row(
                          children: [
                            Container(
                              height: 45,
                              margin: const EdgeInsets.all(0),
                              child: Center(
                                child: Material(
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () async {

                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      child: Text('LV.0',
                                        style: TextStyle(
                                          fontFamily: 'SFPro-Regular',
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 5),

                            Container(
                              height: 45,
                              margin: const EdgeInsets.all(0),
                              child: Center(
                                child: Material(
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () async {

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                      child: Row(
                                        children: [
                                          const Icon(MdiIcons.genderMale, color: Colors.white, size: 20),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 2),
                                            child: Text('0',
                                              style: TextStyle(
                                                fontFamily: 'SFPro-Regular',
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Material(
                child: TabBar(
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      // color: greyColor,
                      width: 1.0,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  controller: _tabController,
                  tabs: [

                    Tab(text: 'visitors'.tr,
                      icon: const Text('0'),
                    ),

                    Tab(text: 'following'.tr,
                      icon: const Text('0'),
                    ),

                    Tab(text: 'follower'.tr,
                      icon: const Text('0'),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
              Expanded(
                child: Observer(
                  builder: (_) => Center(
                    child: [
                      Container(
                        child: ListView(
                          children: [
                            ListTile(
                              title: Text('tasks'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(MdiIcons.clipboardListOutline,
                                color: Colors.orange,
                              ),
                              trailing: const Icon(Icons.navigate_next, color: Colors.white),
                            ),
                            ListTile(
                              title: Text('wallet'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(MdiIcons.wallet,
                                color: Colors.yellow,
                              ),
                              trailing: const Icon(Icons.navigate_next, color: Colors.white),
                              onTap: () => Get.to(() => const WalletPage()),
                            ),
                            ListTile(
                              title: Text('store'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(MdiIcons.store,
                                color: Colors.blue,
                              ),
                              trailing: const Icon(Icons.navigate_next, color: Colors.white),
                            ),
                            ListTile(
                              title: Text('level'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(MdiIcons.equalizer,
                                color: Colors.pinkAccent,
                              ),
                              trailing: const Icon(Icons.navigate_next, color: Colors.white),
                            ),
                            ListTile(
                              onTap: () => Get.to(() =>const ChooseLanguage()),
                              title: Text('language'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(MdiIcons.earth,
                                color: Colors.greenAccent,
                              ),
                              trailing: const Icon(Icons.navigate_next, color: Colors.white),
                            ),
                            ListTile(
                              title: Text('faq_feedback'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: Icon(MdiIcons.commentQuestion,
                                color: Colors.deepPurpleAccent.shade100,
                              ),
                              trailing: const Icon(Icons.navigate_next, color: Colors.white),
                            ),

                            ListTile(
                              onTap: () => Get.to(() => const SettingsPage()),
                              title: Text('settings'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(Icons.settings,
                                color: Colors.orange,
                              ),
                              trailing: const Icon(Icons.navigate_next, color: Colors.white),
                            ),

                            ListTile(
                              onTap: () => Get.to(() => AdminPage()),
                              title: Text('admin'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              leading: const Icon(
                                Icons.admin_panel_settings,
                                color: Colors.blue,
                              ),
                              trailing: const Icon(
                                Icons.navigate_next,
                                color: Colors.white,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(IMG.empty,
                              height: size.width/2.5,
                            ),
                            const SizedBox(height: 12),
                            Text('start_following'.tr,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(IMG.empty,
                                height: size.width/2.5,
                              ),
                              const SizedBox(height: 12),
                              Text('nobody_following'.tr,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ][mobxApp.indexTab],
                  ),
                ),
              ),
            ],
          );
        },
      )
    );
  }
}


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text('settings'.tr,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 8,
                color: Colors.black54,
              ),
              ListTile(
                title: Text('account'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),

              ListTile(
                title: Text('push_notify'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),

              ListTile(
                title: Text('privacy'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),

              ListTile(
                title: Text('blocked_list'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),

              ListTile(
                title: Text('dark_mode'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),

              Container(
                height: 8,
                color: Colors.black54,
              ),

              ListTile(
                title: Text('clear_cache'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),

              ListTile(
                title: Text('clear_records'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),

              Container(
                height: 8,
                color: Colors.black54,
              ),

              ListTile(
                title: Text('network_test'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),

              ListTile(
                title: Text('about'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                trailing: const Icon(Icons.navigate_next, color: Colors.white),
              ),
            ],
          ),

          Container(
            height: 8,
            color: Colors.black54,
          ),

          TextButton(
            onPressed: () => authLogic.signOutDialog(context).then((value) {
              if (value) {
                authLogic.signOut().then((value) {
                  Get.offAll(() => SplashApp(
                    home: const NavigationApp(),
                  ));
                });
              }
            }),
            child: Text('sign_out'.tr,
              style: Get.textTheme.bodyText2?.copyWith(
                fontSize: 16,
                // color: bluAccentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
