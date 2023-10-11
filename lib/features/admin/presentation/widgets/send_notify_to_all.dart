import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:popcorn/core/usecases/constants.dart';
import 'package:popcorn/core/usecases/enums.dart';
import '../../../../core/util/img.dart';
import 'package:flutter/material.dart';
import '../../logic/admin_logic.dart';
import 'package:get/get.dart';

import '../../models/topic_model.dart';



class SendNotifyToAll extends StatelessWidget {
  SendNotifyToAll({Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final adminLogic = AdminLogic.instance;
  final _form = GlobalKey<FormState>();
  TopicModel? model;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('send_notify_to_all'.tr),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _form,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Icon(Icons.notifications_active_outlined,
                size: 50,
              ),
              const SizedBox(height: 10),
              FormBuilderDropdown<TopicModel>(
                name: 'please_choose_topic'.tr,
                initialValue: model,
                decoration: InputDecoration(
                  hintText: 'please_choose_topic'.tr,
                ),
                items: adminLogic.state.topics
                    .map((model) => DropdownMenuItem<TopicModel>(
                  alignment: AlignmentDirectional.center,
                  value: model,
                  child: Text(model.topic),
                )).toList(),
                onChanged: (val) => model = val,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'title'.tr,
                ),
                validator: (val) {
                  final field = val ?? '';
                  if (field.isEmpty) {
                    return 'required_field'.tr;
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                // keyboardType: TextInputType.text,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'message'.tr,
                ),
                validator: (val) {
                  final field = val ?? '';
                  if (field.isEmpty) {
                    return 'required_field'.tr;
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_form.currentState?.validate() ?? false) {
                      if (model != null) {
                        await adminLogic.sendNotifyToAll(
                          context: context,
                          model: model!,
                          title: _titleController.text.trim(),
                          message: _messageController.text.trim(),
                        ).then((_) {
                          _titleController.clear();
                          _messageController.clear();
                        });
                      } else {
                        utilsLogic.showSnack(
                          type: SnackBarType.info,
                          message: 'please_choose_topic'.tr
                        );
                      }
                    }
                  },
                  child: Text('send'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
