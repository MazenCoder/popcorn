import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/usecases/constants.dart';
import 'package:popcorn/core/widgets_helper/widgets.dart';
import 'package:popcorn/features/rooms/models/room_model.dart';
import 'package:flutter/material.dart';

import 'edit_room.dart';


class ProfileRoom extends StatelessWidget {
  final RoomModel room;
  const ProfileRoom({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = userState.user!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (room.author == user.uid)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Get.to(() => EditRoom(room: room)),
                )
              else
                const SizedBox(width: 40),

              Column(
                children: [
                  imageLiveRoom(room, 90),
                  const SizedBox(height: 5),
                  Text(room.name,
                    style: context.textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('ID: ${room.id}',
                    style: context.textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: Get.width-100,
                    child: Text(room.description,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.white70,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),

              IconButton(
                icon: const Icon(MdiIcons.alertOutline),
                onPressed: () {

                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
