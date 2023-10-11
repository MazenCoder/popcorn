import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/features/account/pages/info_account_page.dart';
import '../../core/controllers/user/user_logic.dart';
import '../../core/theme/generateMaterialColor.dart';
import 'package:popcorn/core/mobx/mobx_app.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../core/usecases/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets_helper/widgets.dart';



class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  final MobxApp mobxApp = MobxApp();
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;


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
                        Tab(text: 'message'.tr),
                        Tab(text: 'friends'.tr),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {

                    },
                    child: const Icon(MdiIcons.accountPlus,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 3),
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
