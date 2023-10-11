import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/theme/generateMaterialColor.dart';
import '../../../../core/usecases/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class FollowingPage extends StatefulWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage>
    with AutomaticKeepAliveClientMixin<FollowingPage> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (followingController.loading.value) {
        return Center(
          child: CupertinoActivityIndicator(
            color: primaryColor,
            radius: 20,
          ),
        );
      } else {
        return SmartRefresher(
          controller: _refreshController,
          header: const WaterDropHeader(),
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () async {
            await followingController.getFollowing(
              uid: userState.user!.uid, listener: true,
            );
            return _refreshController.refreshCompleted();
          },
          onLoading: () async {
            await followingController.getMoreFollowing(
              context: context, listener: true,
              uid: userState.user!.uid,
            );
            return _refreshController.loadComplete();
          },
          footer: CustomFooter(
            builder: (context, mode) {
              Widget body ;
              if (!followersController.isMooreAvailable.value) {
                body = Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 0),
                  child: Text("no_more_results".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                );
              } else if (mode == LoadStatus.idle) {
                body =  Text("pull_up_load".tr,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                );
              } else if(mode == LoadStatus.loading) {
                body =  const CupertinoActivityIndicator();
              } else if(mode == LoadStatus.failed) {
                body = Text("load_failed".tr,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                );
              } else if(mode == LoadStatus.canLoading) {
                body = Text("pull_refresh".tr,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                );
              } else {
                body = Text("no_more_results".tr,
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
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            itemCount: followingController.cardFollowing.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (context, index) {
              return followingController.cardFollowing[index];
            },
          ),
        );
      }
    });
  }
}
