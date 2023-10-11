import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import '../widgets/manage_border_frames.dart';
import '../widgets/send_notify_to_all.dart';
import '../widgets/manage_topics.dart';
import 'package:flutter/material.dart';
import '../../logic/admin_logic.dart';
import '../widgets/manage_gifts.dart';
import 'package:get/get.dart';




class AdminPage extends StatelessWidget {
  AdminPage({Key? key}) : super(key: key);

  final adminLogic = Get.put(AdminLogic());

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('admin'.tr),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  onTap: () => Get.to(() => const ManageTopics()),
                  title: Text('manage_topics'.tr),
                  leading: const Icon(
                    MdiIcons.messageBadgeOutline,
                    color: Colors.blue,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                ),

                ListTile(
                  onTap: () => Get.to(() => SendNotifyToAll()),
                  title: Text('send_notify_to_all'.tr),
                  leading: const Icon(
                    Icons.notifications_active,
                    color: Colors.blue,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  onTap: () => Get.to(() => const ManageGifts()),
                  title: Text('manage_gifts'.tr),
                  leading: const Icon(
                    MdiIcons.gift,
                    color: Colors.blue,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                ),

                ListTile(
                  onTap: () => Get.to(() => const ManageBorderFrames()),
                  title: Text('manage_border_frames'.tr),
                  leading: const Icon(
                    MdiIcons.imageMove,
                    color: Colors.blue,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
