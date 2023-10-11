import 'dart:convert';


GiftModel? giftModelFromJson(var str) => GiftModel.fromJson(str);
String giftModelToJson(GiftModel data) => json.encode(data.toJson());


class GiftModel {

  String id;
  String image;
  GiftModel({required this.id, required this.image});

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
  };
}
