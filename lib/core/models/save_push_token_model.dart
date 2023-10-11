// To parse this JSON data, do
//
//     final savePushTokenModel = savePushTokenModelFromJson(jsonString);

import 'dart:convert';

SavePushTokenModel savePushTokenModelFromJson(String str) => SavePushTokenModel.fromJson(json.decode(str));

String savePushTokenModelToJson(SavePushTokenModel data) => json.encode(data.toJson());

class SavePushTokenModel {
  SavePushTokenModel({
    required this.action,
    required this.result,
    required this.userid,
  });

  String action;
  String result;
  int userid;

  factory SavePushTokenModel.fromJson(Map<String, dynamic> json) => SavePushTokenModel(
    action: json["action"],
    result: json["result"],
    userid: json["userid"],
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "result": result,
    "userid": userid,
  };
}
