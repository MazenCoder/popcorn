// To parse this JSON data, do
//
//     final algoliaModel = algoliaModelFromJson(jsonString);

import 'dart:convert';

AlgoliaModel algoliaModelFromJson(String str) => AlgoliaModel.fromJson(json.decode(str));

class AlgoliaModel {
  AlgoliaModel({
    required this.hits,
    required this.nbHits,
    required this.page,
    required this.nbPages,
    required this.hitsPerPage,
    this.exhaustiveNbHits,
    this.exhaustiveTypo,
    required this.query,
    this.processingTimeMs,
  });

  List<Hit> hits;
  int nbHits;
  int page;
  int nbPages;
  int hitsPerPage;
  bool? exhaustiveNbHits;
  bool? exhaustiveTypo;
  String query;
  int? processingTimeMs;

  factory AlgoliaModel.fromJson(Map<String, dynamic> json) => AlgoliaModel(
    hits: json["hits"] != null ? List<Hit>.from(json["hits"].map((x) => Hit.fromJson(x))) : [],
    nbHits: json["nbHits"],
    page: json["page"],
    nbPages: json["nbPages"],
    hitsPerPage: json["hitsPerPage"],
    exhaustiveNbHits: json["exhaustiveNbHits"],
    exhaustiveTypo: json["exhaustiveTypo"],
    query: json["query"],
    processingTimeMs: json["processingTimeMS"],
  );

}

class Hit {
  Hit({
    // required this.commentCounter,
    // required this.content,
    // required this.id,
    // required this.idTypesPost,
    // required this.idVisibility,
    // required this.isArchive,
    // required this.isBanned,
    // required this.likeCounter,
    // required this.timestamp,
    // required this.uid,
    // required this.path,
    // required this.lastmodified,
    required this.objectId,
  });

  // int commentCounter;
  // String content;
  // String id;
  // int idTypesPost;
  // int idVisibility;
  // bool isArchive;
  // bool isBanned;
  // int likeCounter;
  // int timestamp;
  // String uid;
  // String path;
  // int lastmodified;
  String objectId;

  factory Hit.fromJson(Map<String, dynamic> json) => Hit(
    // commentCounter: json["commentCounter"],
    // content: json["content"],
    // id: json["id"],
    // idTypesPost: json["idTypesPost"],
    // idVisibility: json["idVisibility"],
    // isArchive: json["isArchive"],
    // isBanned: json["isBanned"],
    // likeCounter: json["likeCounter"],
    // timestamp: json["timestamp"],
    // uid: json["uid"],
    // path: json["path"],
    // lastmodified: json["lastmodified"],
    objectId: json["objectID"],
  );

}