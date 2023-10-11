import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {

  final String id;
  final String fromUserId;
  final String? postId;
  final String? postImageUrl;
  final String? comment;
  final bool isFollowEvent;
  final bool isLikeEvent;
  final bool isMessageEvent;
  final bool isCommentEvent;
  final bool isLikeMessageEvent;
  final String? receiverToken;
  final Timestamp timestamp;

  ActivityModel({
    required this.id,
    required this.fromUserId,
    this.postId,
    this.postImageUrl,
    this.comment,
    required this.timestamp,
    required this.isFollowEvent,
    required this.isLikeEvent,
    required this.isMessageEvent,
    required this.isCommentEvent,
    required this.isLikeMessageEvent,
    this.receiverToken,
  });

  factory ActivityModel.fromDoc(DocumentSnapshot doc) {
    return ActivityModel(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      postId: doc['postId'],
      postImageUrl: doc['postImageUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      isFollowEvent: doc['isFollowEvent'] ?? false,
      isCommentEvent: doc['isCommentEvent'] ?? false,
      isLikeEvent: doc['isLikeEvent'] ?? false,
      isMessageEvent: doc['isMessageEvent'] ?? false,
      isLikeMessageEvent: doc['isMessageEvent'] ?? false,
      receiverToken: doc['receiverToken'] ?? '',
    );
  }
}
