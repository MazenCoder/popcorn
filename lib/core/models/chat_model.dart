import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/models/user_model.dart';



class Chat {

  final String id;
  final String? recentMessage;
  final String recentSender;
  final dynamic recentTimestamp;
  final List<dynamic> memberIds;
  final List<UserModel> memberInfo;
  final dynamic readStatus;
  final dynamic acceptStatus;

  Chat({
    required this.id,
    this.recentMessage,
    required this.recentSender,
    this.recentTimestamp,
    required this.memberIds,
    required this.memberInfo,
    this.readStatus,
    this.acceptStatus,
  });

  factory Chat.fromJson(String id, Map<String, dynamic> json) {
    return Chat(
        id: id,
        recentMessage: json['recentMessage'],
        recentSender: json['recentSender'],
        recentTimestamp: json['recentTimestamp'],
        memberIds: json['memberIds'],
        readStatus: json['readStatus'],
        acceptStatus: json['acceptStatus'],
        memberInfo: json['memberInfo'] != null ? List<UserModel>.from(json["memberInfo"].map((x) => x)) : []
    );
  }

  factory Chat.fromDoc(DocumentSnapshot doc) {
    return Chat(
      id: doc.id,
      recentMessage: doc['recentMessage'],
      recentSender: doc['recentSender'],
      recentTimestamp: doc['recentTimestamp'],
      memberIds: doc['memberIds'],
      readStatus: doc['readStatus'],
      acceptStatus: doc['acceptStatus'],
      memberInfo: doc['memberInfo'] ?? [],
    );
  }
}
