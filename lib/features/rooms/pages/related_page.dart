import 'package:popcorn/features/rooms/pages/following_page.dart';
import 'package:popcorn/features/rooms/pages/recently_page.dart';
import 'package:popcorn/features/rooms/widgets/create_room.dart';
import 'package:popcorn/features/rooms/logic/room_logic.dart';
import '../../../core/usecases/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'joined_page.dart';




class RelatedPage extends StatelessWidget {
  const RelatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          GetBuilder<RoomLogic>(
            builder: (logic) {
              if (logic.state.myRoom != null) {
                return logic.state.myRoom!;
              } else {
                return SizedBox(
                  height: 80,
                  width: size.width,
                  child: Card(
                    child: ListTile(
                      onTap: () => Get.to(() => const CreateRoom()),
                      leading: const ClipOval(
                        child: Icon(Icons.add),
                      ),
                      trailing: const Icon(Icons.flag),
                      title: Text('create_my_room'.tr,
                      ),
                      subtitle: Text('start_journey'.tr),
                    ),
                  ),
                );
              }
            },
          ),

          Expanded(
            child: Scaffold(
              backgroundColor: Get.theme.backgroundColor,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: TabBar(
                          tabs: [
                            Text("recently".tr),
                            Text("joined".tr),
                            Text("following".tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                body: const TabBarView(
                  children: <Widget>[
                    RecentlyPage(),
                    JoinedPage(),
                    FollowingPage(),
                  ],
                ),
            ),
          )
        ],
      )
    );
  }
}
