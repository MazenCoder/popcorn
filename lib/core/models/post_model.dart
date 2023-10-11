

class PostModel {

  final String id;
  final String uid;
  final String content;
  final String? urlImage;
  final int idVisibility;
  final int idTypesPost;
  final bool isBanned;
  final bool isArchive;
  final int likeCounter;
  final int commentCounter;
  final dynamic timestamp;

  PostModel({
    required this.id,
    required this.uid,
    required this.content,
    this.urlImage,
    required this.idVisibility,
    required this.idTypesPost,
    required this.isBanned,
    required this.isArchive,
    this.likeCounter = 0,
    this.commentCounter = 0,
    required this.timestamp,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    uid: json["uid"],
    content: json["content"],
    urlImage: json["urlImage"],
    idVisibility: json["idVisibility"],
    idTypesPost: json["idTypesPost"],
    isBanned: json["isBanned"],
    isArchive: json["isArchive"],
    likeCounter: json["likeCounter"] ?? 0,
    commentCounter: json["commentCounter"] ?? 0,
    timestamp: json["timestamp"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "content": content,
    "urlImage": urlImage,
    "idVisibility": idVisibility,
    "idTypesPost": idTypesPost,
    "isBanned": isBanned,
    "isArchive": isArchive,
    "likeCounter": likeCounter,
    "commentCounter": commentCounter,
    "timestamp": timestamp,
  };

  Map<String, dynamic> toJsonUrlImg(String? url) => {
    "id": id,
    "uid": uid,
    "content": content,
    "urlImage": url,
    "idVisibility": idVisibility,
    "idTypesPost": idTypesPost,
    "isBanned": isBanned,
    "isArchive": isArchive,
    "likeCounter": likeCounter,
    "commentCounter": commentCounter,
    "timestamp": timestamp,
  };

  Map<String, dynamic> updateJsonUrlImg(String? url) => {
    "content": content,
    "urlImage": url,
    "idVisibility": idVisibility,
    "idTypesPost": idTypesPost,
  };

}