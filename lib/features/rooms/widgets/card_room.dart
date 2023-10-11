import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/features/rooms/widgets/live_room.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/widgets.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';



class CardRoom extends StatelessWidget {
  final RoomModel room;
  const CardRoom({
    required this.room,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => LiveRoom(room: room)),
      // onTap: () async {
      //   await utilsLogic.checkMemberIds(room.id);
      //   Get.to(() => ChatScreenGroupPage(room: room));
      // },
      child: Card(
        color: secondaryColor.shade800,
        child: Row(
          children: [
            imageCardRoom(room),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name),
                    Text(room.description,
                      style: context.textTheme.bodySmall,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Lottie.asset(IMG.jsonWave, width: 25, height: 25),
                Icon(MdiIcons.account, color: primaryColor),
              ],
            ),
            const SizedBox(width: 6)
          ],
        ),
      ),
    );
  }
}
