// To parse this JSON data, do
//
//     final currentVersion = currentVersionFromJson(jsonString);

import 'dart:convert';

CurrentVersion currentVersionFromJson(String str) => CurrentVersion.fromJson(json.decode(str));

String currentVersionToJson(CurrentVersion data) => json.encode(data.toJson());

class CurrentVersion {
  CurrentVersion({
    required this.action,
    required this.result,
  });

  String action;
  String result;

  factory CurrentVersion.fromJson(Map<String, dynamic> json) => CurrentVersion(
    action: json["action"],
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "result": result,
  };
}
