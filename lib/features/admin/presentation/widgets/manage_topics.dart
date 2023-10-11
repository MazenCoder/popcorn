import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/features/admin/logic/admin_logic.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import '../../models/topic_model.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';



class ManageTopics extends StatelessWidget {
  const ManageTopics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminLogic = AdminLogic.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('manage_topics'.tr),
      ),
      body: GetBuilder<AdminLogic>(
        builder: (logic) {
          if (logic.state.topics.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      IMG.jsonEmpty,
                      width: Get.width / 1.5,
                    ),
                    Text(
                      'no_results_found'.tr,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: logic.state.topics.length,
              itemBuilder: (context, index) {
                final model = logic.state.topics[index];
                return ListTile(
                  title: Text(model.topic),
                  leading: Icon(MdiIcons.messageBadgeOutline),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      bool delete = await adminLogic.deleteTopicDialog(context);
                      if (delete) {
                        adminLogic.deleteTopic(
                          context: context,
                          model: model,
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          String? topic = await adminLogic.addTopicDialog(context);
          if (topic != null) {
            await adminLogic.addTopic(
              context: context,
              model: TopicModel(
                id: const Uuid().v4(),
                topic: topic,
              ),
            );
          }
        },
      ),
    );
  }
}
