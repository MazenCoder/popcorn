import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/util/img.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';




class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    postController.getSavedPost(listener: true);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) {
        return Scaffold(
          // backgroundColor: backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text('saved'.tr,
              style: GoogleFonts.notoSans(),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Get.back(),
            ),
          ),
          body: Obx(() {
            if (postController.loading.value) {
              return Center(
                child: CupertinoActivityIndicator(
                  color: primaryColor,
                  radius: 20,
                ),
              );
            } if (postController.savedPost.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(IMG.jsonEmpty,
                      width: Get.width/1.2
                    ),
                    Text('no_saved_posts'.tr),
                  ],
                ),
              );
            }  else {
              return SmartRefresher(
                controller: _refreshController,
                header: const WaterDropHeader(),
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: () async {
                  await postController.getSavedPost(listener: true);
                  return _refreshController.refreshCompleted();
                },
                onLoading: () async {
                  await postController.getMoreSavedPost(context: context, listener: true);
                  return _refreshController.loadComplete();
                },
                footer: CustomFooter(
                  builder: (context, mode) {
                    Widget body ;
                    if (!postController.isMooreSavedAvailable.value) {
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
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: postController.savedPost.length,
                  itemBuilder: (context, index) {
                    return postController.savedPost[index];
                  },
                ),
              );
            }
          }),
        );
      },
    );
  }
}
