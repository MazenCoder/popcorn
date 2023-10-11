import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../widgets/card_shimmer.dart';
import '../widgets/search_post.dart';
import 'package:get/get.dart';




class FeedsPage extends HookWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RefreshController _refreshController = RefreshController(initialRefresh: false);
    final FocusNode _inputNode = FocusNode();
    return Scaffold(
      // backgroundColor: backgroundColor,
      body: Column(
        children: [
          Material(
            color: Colors.white,
            shadowColor: primaryColor,
            elevation: 2,
            child: InkWell(
              onTap: () {
                // if (utilsController.isUser(userState.user!.email)) {
                //   Get.to(() => UserProfilePage(user: userState.user!));
                // }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 16, right: 4),
                    child: chatCircleAvatar(userState.user),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor.shade50,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(20)
                        ),
                      ),
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      padding: const EdgeInsets.only(top: 0, left: 8),
                      child: TextField(
                        autofocus: false,
                        focusNode: _inputNode,
                        onTap: () async {
                          final model = await showSearch(
                            context: context, delegate: SearchPost(),
                          );
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          hintText: 'search'.tr,
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            color: primaryColor,
                            onPressed: () async {
                              final model = await showSearch(
                                context: context, delegate: SearchPost(),
                              );
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ),
                        style: TextStyle(color: primaryColor, fontSize: 15.0),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Icons.notifications,
                      // MdiIcons.filter,
                      color: primaryColor,
                    ),
                    onPressed: () {

                    }
                    // onPressed: () => Get.to(() => const TabUsers()),
                  ),

                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Obx(() {
              if (postController.loading.value) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return postController.spacePost;
                    } else {
                      return const CardShimmer();
                    }
                  },
                );
              } else {
                return SmartRefresher(
                  controller: _refreshController,
                  header: const WaterDropHeader(),
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () async {
                    await postController.setupPost(listener: true);
                    return _refreshController.refreshCompleted();
                  },
                  onLoading: () async {
                    await postController.getMorePost(context: context, listener: true);
                    return _refreshController.loadComplete();
                  },
                  footer: CustomFooter(
                    builder: (context, mode) {
                      Widget body ;
                      if (!postController.isMooreAvailable.value) {
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
                  child: ListView.builder(
                    itemCount: postController.posts.length,
                    itemBuilder: (context, index) {
                      return postController.posts[index];
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
