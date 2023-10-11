import 'dart:convert';


NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJsonModel());

class NotificationModel {
  NotificationModel({
    required this.title,
    required this.body,
    required this.clickAction,
    required this.created,
  });

  String title;
  String body;
  String clickAction;
  DateTime created;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    title: json["title"],
    body: json["body"],
    clickAction: json["click_action"],
    created: DateTime.parse(json["created"]),
  );

  Map<String, dynamic> toJsonModel() => {
    "click_action": clickAction,
    "created": created.toIso8601String(),
  };
}
