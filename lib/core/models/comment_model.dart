import 'package:cloud_firestore/cloud_firestore.dart';


class CommentModel {
  final String id;
  final String? replyTo;
  final String content;
  final String authorId;
  final bool isBlocked;
  final dynamic timestamp;
  final int likeCounter;


  CommentModel({
    required this.id,
    this.replyTo,
    required this.content,
    required this.authorId,
    this.isBlocked = false,
    this.timestamp,
    this.likeCounter = 0,
  });

  factory CommentModel.fromDoc(var doc) {
    return CommentModel(
      id: doc['id'],
      replyTo: doc['replyTo'],
      content: doc['content'],
      authorId: doc['authorId'],
      isBlocked: doc['isBlocked'],
      timestamp: doc['timestamp'],
      likeCounter: doc['likeCounter'] ?? 0,
    );
  }

  toJson() {
    return {
      'id': id,
      'replyTo': replyTo,
      'content': content,
      'authorId': authorId,
      'isBlocked': isBlocked,
      'timestamp': timestamp,
      'likeCounter': likeCounter,
    };
  }
}
