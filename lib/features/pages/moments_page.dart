import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:popcorn/core/controllers/user/user_logic.dart';
import 'package:popcorn/core/mobx/mobx_app.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:popcorn/features/account/pages/info_account_page.dart';
import '../../core/theme/generateMaterialColor.dart';
import '../../core/usecases/constants.dart';
import '../../core/widgets_helper/widgets.dart';



class MomentsPage extends StatefulWidget {
  const MomentsPage({Key? key}) : super(key: key);

  @override
  _MomentsPageState createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  final MobxApp mobxApp = MobxApp();
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;


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
    return Scaffold(
      body: Column(
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
                    }
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
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'following'.tr),
                          Tab(text: 'featured'.tr),
                          Tab(text: 'topics'.tr)
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60,
          ),
          Expanded(
            child: Observer(
              builder: (_) => Center(
                child: [
                  Container(
                    // color: Colors.green,
                  ),
                  Container(
                    // color: Colors.yellow,
                  ),
                  Container(
                    // color: Colors.red,
                  ),
                ][mobxApp.indexTab],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
