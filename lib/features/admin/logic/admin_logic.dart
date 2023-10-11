import '../../../core/widgets_helper/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/usecases/constants.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../core/usecases/enums.dart';
import '../../../core/usecases/keys.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import 'package:get/get.dart';
import 'admin_state.dart';
import 'dart:convert';




class AdminLogic extends GetxController {
  static AdminLogic instance = Get.find();
  final state = AdminState();

  @override
  void onInit() {
    getTopics();
    super.onInit();
  }


  Future<void> getTopics() async {
    try {
      DocumentSnapshot doc = await topicsRef.get();
      if (doc.exists) {
        final json = doc.data() as Map<String, dynamic>;
        List<dynamic> list = json[Keys.topics] ?? [];
        if (list.isNotEmpty) {
          state.topics = list.map<TopicModel>((item) => TopicModel.fromJson(item)).toList();
          update();
        } else {
          state.topics.clear();
          update();
        }
      }
    } catch(e) {
      logger.e(e);
    }
  }

  Future<String?> addTopicDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();
      return AlertDialog(
        title: Text('add_topic'.tr,
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'name_topic'.tr,
            ),
            validator: (val) {
              final field = val ?? '';
              if(field.isEmpty) {
                return 'required_field'.tr;
              } else {
                return null;
              }
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('save'.tr),
            onPressed: () {
              if (formKey.currentState?.validate()??false) {
                final topic = controller.text.trim();
                Navigator.pop(context, topic);
              }
            },
          ),
        ],
      );
    });
  }

  Future<void> addTopic({
    required BuildContext context,
    required TopicModel model
  }) async {
    try {
      LoadingDialog.show(context: context);
      List<TopicModel> topics = state.topics;
      topics.add(model);
      await topicsRef.set({
        Keys.topics: topics.map((item) => item.toJson()).toList(),
      });
      await getTopics();
      LoadingDialog.hide(context: context);
    } catch(e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      utilsLogic.showSnack(type: SnackBarType.error,
        message: '$e'
      );
    }
  }

  Future<bool> deleteTopicDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('delete_topic'.tr,
          textAlign: TextAlign.center,
        ),
        content: Text('delete_topic_msg'.tr,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('yes'.tr),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    }) ?? false;
  }

  Future<void> deleteTopic({
    required BuildContext context,
    required TopicModel model
  }) async {
    try {
      LoadingDialog.show(context: context);
      final index = state.topics.indexWhere((element) => element.id == model.id);
      if (index != -1) {
        state.topics.removeAt(index);
        await topicsRef.set({
          Keys.topics: (state.topics.isEmpty) ? [] :
          state.topics.map((item) => item.toJson()).toList(),
        }, SetOptions(merge: true));
      }
      await getTopics();
      LoadingDialog.hide(context: context);
    } catch(e) {
      logger.e(e);
      LoadingDialog.hide(context: context);
      utilsLogic.showSnack(type: SnackBarType.error,
          message: '$e'
      );
    }
  }

  Future<void> sendNotifyToAll({
    required BuildContext context,
    required TopicModel model,
    required String title,
    required String message,
  }) async {
    try {
      if (networkState.isConnected) {
        LoadingDialog.show(context: context);
        const url = "$baseUrl/sendNotificationsToAll";
        final response = await http.post(Uri.parse(url),
          headers: {
            "authorization": "${userState.idToken}"
          },
          body: {
            "topic": model.topic,
            "title": title,
            "body": message,
          },
        );
        logger.i(response.body);
        LoadingDialog.hide(context: context);
        final jsonResponse = jsonDecode(response.body);
        final status = jsonResponse['state'] ?? 'error';
        if (response.statusCode == 200) {
          if (status != null && status == 'succeeded') {
            utilsLogic.showSnack(
              type: SnackBarType.success,
              title: 'success'.tr,
              message: jsonResponse['message'] ?? "completed_success".tr,
            );
          } else {
            utilsLogic.showSnack(
              type: SnackBarType.error,
              message: jsonResponse['message'] ?? "error_wrong".tr,
            );
          }
        } else {
          utilsLogic.showSnack(
            type: SnackBarType.error,
            message: jsonResponse['message'] ?? "error_wrong".tr,
          );
        }
      } else {
        utilsLogic.showSnack(type: SnackBarType.unconnected);
      }
    } catch (e) {
      logger.e('$e');
      LoadingDialog.hide(context: context);
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
    }
  }
}