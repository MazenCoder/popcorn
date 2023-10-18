import 'package:popcorn/features/account/pages/info_account_page.dart';
import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:popcorn/features/rooms/logic/room_logic.dart';
import 'package:popcorn/features/rooms/pages/related_page.dart';
import '../../../core/controllers/user/user_logic.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'package:popcorn/core/mobx/mobx_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_room_page.dart';



class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> with
    AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  final MobxApp mobxApp = MobxApp();


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    bool isRegistered = Get.isRegistered<RoomLogic>();
    final isRtl = languageLogic.isRtl();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: GetBuilder(
          init: isRegistered ? null : Get.put(RoomLogic()),
          builder: (logic) {
            return Column(
              children: [
                Material(
                  color: primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        GetBuilder<UserLogic>(
                          builder: (logic) {
                            final user = logic.state.user!;
                            return InkWell(
                              onTap: () => Get.to(() => const InfoAccountPage()),
                              child: chatCircleAvatar(user),
                            );
                          },
                        ),

                        Expanded(
                          child: TabBar(
                            labelStyle: context.textTheme.bodyMedium?.copyWith(
                                color: headlineColor
                            ),
                            labelColor: headlineColor,
                            indicator: const UnderlineTabIndicator(
                              borderSide: BorderSide(color: Colors.transparent, width: 0),
                              insets: EdgeInsets.symmetric(horizontal: 0),
                            ),
                            indicatorWeight: 0,
                            tabs: [
                              Tab(text: 'related'.tr),
                              Tab(text: 'all'.tr),
                              Tab(text: 'explore'.tr),
                            ],
                          ),
                        ),

                        InkWell(
                          onTap: () {

                          },
                          child: const Icon(Icons.search,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 3),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      const RelatedPage(),
                      const AllRoomPage(),
                      Container(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}