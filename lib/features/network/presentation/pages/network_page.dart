import '../../../../core/theme/generateMaterialColor.dart';
import '../../../../core/usecases/constants.dart';
import '../../../../core/widgets_helper/widgets.dart';
import '../../../rooms/pages/following_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'followers_page.dart';



class NetworkPage extends StatefulWidget {
  const NetworkPage({Key? key}) : super(key: key);

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage>
    with AutomaticKeepAliveClientMixin<NetworkPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: getUsername(user: userState.user!),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'followers'.tr,
                icon: Obx(() {
                  return Text('${followersController.followersNbr}');
                }),
              ),

              Tab(
                text: 'following'.tr,
                icon: Obx(() {
                  return Text('${followingController.followingNbr}');
                }),
              ),

            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FollowersPage(),
            FollowingPage(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
