import 'dart:convert';

IamonlineModel iamonlineModelFromJson(String str) => IamonlineModel.fromJson(json.decode(str));

String iamonlineModelToJson(IamonlineModel data) => json.encode(data.toJson());

class IamonlineModel {
  IamonlineModel({
    required this.action,
    required this.result,
    required this.userid,
  });

  String action;
  String result;
  int userid;

  factory IamonlineModel.fromJson(Map<String, dynamic> json) => IamonlineModel(
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
