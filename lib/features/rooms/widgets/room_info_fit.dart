import 'package:popcorn/features/rooms/widgets/profile_room.dart';
import 'package:popcorn/core/theme/generateMaterialColor.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class RoomInfoFit extends StatelessWidget {
  final RoomModel room;
  const RoomInfoFit({
    Key? key, required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
        ),
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('welcome_new_members'.tr,
                    style: context.textTheme.bodyText2?.copyWith(
                      fontSize: 16
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            TabBar(
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
                Tab(text: 'profile'.tr),
                Tab(text: 'members'.tr),
                Tab(text: 'events'.tr),
                Tab(text: 'moments'.tr),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProfileRoom(room: room),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
