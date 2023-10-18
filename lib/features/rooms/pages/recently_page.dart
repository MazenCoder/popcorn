import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:popcorn/generated/assets.dart';
import '../../../core/usecases/constants.dart';
import '../widgets/card_room_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';




class RecentlyPage extends StatelessWidget {
  final RefreshController controller;
  const RecentlyPage({Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (roomState.loading.value) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 50),
          itemCount: 5,
          itemBuilder: (context, index) {
            return const CardRoomShimmer();
          },
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SmartRefresher(
            controller: controller,
            // header: const WaterDropHeader(),
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              await roomLogic.getNewRooms();
              return controller.refreshCompleted();
            },
            onLoading: () async {
              // await feedsLogic.getMorePost();
              return controller.loadComplete();
            },
            footer: CustomFooter(
              builder: (context, mode) {
                Widget body;
                if (roomState.loading.value) {
                  body = const CupertinoActivityIndicator();
                } else if (!roomState.isMooreAvailable.value) {
                  body = Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 0),
                    child: Text("no_more_posts".tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else if (mode == LoadStatus.idle) {
                  body = Text("pull_up_load".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                } else if (mode == LoadStatus.loading) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("load_failed".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("pull_refresh".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                } else {
                  body = Text("no_more_posts".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                  );
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            child: (roomState.rooms.isNotEmpty) ?
            ListView.builder(
              // controller: scrollController,
              itemCount: roomState.rooms.length,
              itemBuilder: (context, index) {
                return roomState.rooms[index];
              },
            ) : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    Assets.jsonsJsonEmpty,
                    height: 100,
                  ),
                  Text('no_results_found'.tr)
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
