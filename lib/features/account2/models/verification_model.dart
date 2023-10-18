

class VerificationModel {

  VerificationModel({
    required this.id,
    required this.photo,
    required this.status,
    required this.timestamp,
  });

  final String id;
  final String photo;
  final int status;
  final dynamic timestamp;

  factory VerificationModel.fromJson(Map<String, dynamic> json) => VerificationModel(
    id: json["id"],
    photo: json["photo"],
    status: json["status"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
    "status": status,
    "timestamp": timestamp,
  };

}