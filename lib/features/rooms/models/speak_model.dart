import '../../../core/models/user_model.dart';

SpeakerModel speakerModelFromJson(var data) => SpeakerModel.fromJson(data);

class SpeakerModel {

  String uid;
  double volume;
  int uniqueKey;
  bool isSpeaking;
  String? photoProfile;

  SpeakerModel({
    required this.uid,
    required this.volume,
    required this.uniqueKey,
    this.photoProfile,
    required this.isSpeaking,
  });

  factory SpeakerModel.fromJson(Map<String, dynamic> json) => SpeakerModel(
    uid: json["uid"],
    volume: json["volume"],
    uniqueKey: json["uniqueKey"],
    photoProfile: json["photoProfile"],
    isSpeaking: json["isSpeaking"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "volume": volume,
    "uniqueKey": uniqueKey,
    "isSpeaking": isSpeaking,
    "photoProfile": photoProfile,
  };
}