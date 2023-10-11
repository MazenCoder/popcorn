import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/usecases/constants.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ProfilePage extends StatefulWidget {
  final UserModel userModel;
  const ProfilePage({Key? key, required this.userModel}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  initState() {
    _tabController = TabController(length: 2, vsync: this);
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
    return ResponsiveSafeArea(
      builder: (_) => Scaffold(
        // backgroundColor: greyColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: size.width,
                      height: size.height/3,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(
                            IMG.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),

                        TextButton.icon(
                          label: Text('edit'.tr,
                            style: Get.textTheme.bodyText2?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          icon: const Icon(MdiIcons.accountEdit,
                            color: Colors.white,
                          ), onPressed: () {  },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: 145),
                      // height: 290,
                      // color: Colors.amber,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.userModel.photoProfile != null) ...[
                            ClipOval(
                              child: InkWell(
                                onTap: () => Get.to(() => ProfilePage(userModel: widget.userModel)),
                                child: CachedNetworkImage(
                                  imageUrl: "${widget.userModel.photoProfile}",
                                  height: size.width/4.5, width: size.width/4.5,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    IMG.defaultUser,
                                    height: size.width/4.5, width: size.width/4.5,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            ClipOval(
                              child: Image.asset(IMG.defaultUser,
                                height: size.width/4.5, width: size.width/4.5,
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                          const SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(widget.userModel.displayName,
                                style: Get.textTheme.bodyText2?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('ID:6692458824',
                                style: Get.textTheme.bodyText2?.copyWith(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 45,
                                    margin: const EdgeInsets.all(0),
                                    child: Center(
                                      child: Material(
                                        // color: bluAccentColor,
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
                                        // color: MsMaterialColor(kTaigaColor),
                                        // color: bluAccentColor,
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
                  ),
                ],
              ),
              Material(
                // color: greyColor,
                child: TabBar(
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFPro-Regular',
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
                    Tab(text: 'track'.tr),
                    Tab(text: 'profile'.tr),
                  ],
                ),
              ),
              /*
              Divider(
                color: Colors.black,
                thickness: 2,
              ),
              Observer(
                builder: (_) => Center(
                  child: [
                    Container(
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ListTile(
                            title: Text('track'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(Icons.navigate_next, color: Colors.white),
                          ),

                          ListTile(
                            title: Text('badge'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(Icons.navigate_next, color: Colors.white),
                          ),

                          ListTile(
                            title: Text('moments'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(Icons.navigate_next, color: Colors.white),
                          ),

                          ListTile(
                            title: Text('gift'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(Icons.navigate_next, color: Colors.white),
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
                    Container(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Row(
                            children: [
                              Text('language'.tr,
                                style: TextStyle(
                                  color: Colors.grey.shade300
                                ),
                              ),


                              SizedBox(width: 40),
                              Text('English'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              Text('Zodiac Sign'.tr,
                                style: TextStyle(
                                    color: Colors.grey.shade300
                                ),
                              ),


                              SizedBox(width: 40),
                              Text('Aries'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              Text('Tags'.tr,
                                style: TextStyle(
                                    color: Colors.grey.shade300
                                ),
                              ),


                              SizedBox(width: 80),
                              Text('Big Boss'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Text('account_created'.trArgs([timeago.format(widget.userModel.timestamp.toDate())]),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              // fontSize: 12,
                              color: Colors.white,
                              fontFamily: 'SFPro-Bold',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ][mobxApp.indexTab],
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
