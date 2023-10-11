import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/models/user_model.dart';


class RoomModel {

  final String id;
  final String uid;
  final String name;
  final String description;
  final int status;
  final int idRoom;
  final int micNumber;
  final String? token;
  final String? photoRoom;
  final dynamic readStatus;
  final String? recentSender;
  final String? recentMessage;
  final String welcomeMessage;
  final List<String>? memberIds;
  final dynamic timestamp;
  final List<UserModel>? memberInfo;

  RoomModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.status,
    this.token,
    required this.idRoom,
    this.micNumber = 10,
    required this.description,
    this.photoRoom,
    this.recentMessage,
    required this.welcomeMessage,
    this.recentSender,
    this.timestamp,
    this.memberIds,
    this.readStatus,
    this.memberInfo,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      status: json['status'],
      description: json['description'],
      idRoom: json['idRoom'],
      micNumber: json['micNumber'],
      photoRoom: json['photoRoom'],
      recentMessage: json['recentMessage'],
      welcomeMessage: json['welcomeMessage'],
      recentSender: json['recentSender'],
      timestamp: (json['timestamp'] != null) ? json['timestamp'].toDate() : null,
      memberIds: json["memberIds"] != null ? List<String>.from(json["memberIds"].map((x) => x)) : [],
      readStatus: json['readStatus'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'name': name,
    'description': description,
    'idRoom': idRoom,
    'micNumber': micNumber,
    'photoRoom': photoRoom,
    'recentMessage': recentMessage,
    'welcomeMessage': welcomeMessage,
    'recentSender': recentSender,
    'createTimestamp': timestamp,
    'memberIds': List<dynamic>.from(memberIds!.map((x) => x)),
    'readStatus': readStatus,
    'token': token,
    'status': status,
  };

  Map<String, dynamic> toJsonPhoto(String photoRoom) => {
    'id': id,
    'uid': uid,
    'name': name,
    'description': description,
    'idRoom': idRoom,
    'micNumber': micNumber,
    'photoRoom': photoRoom,
    'recentMessage': recentMessage,
    'welcomeMessage': welcomeMessage,
    'recentSender': recentSender,
    'timestamp': timestamp,//FieldValue.serverTimestamp(),
    'memberIds': List<dynamic>.from(memberIds!.map((x) => x)),
    'readStatus': readStatus,
    'token': token,
    'status': status,
  };
}