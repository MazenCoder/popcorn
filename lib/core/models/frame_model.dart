import 'dart:convert';


FrameModel? frameModelFromJson(var str) => FrameModel.fromJson(str);
String frameModelToJson(FrameModel data) => json.encode(data.toJson());


class FrameModel {

  String id;
  String image;
  FrameModel({required this.id, required this.image});

  factory FrameModel.fromJson(Map<String, dynamic> json) => FrameModel(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
  };
}
