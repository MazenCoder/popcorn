import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  final String id;
  final String senderId;
  final String receiverId;
  final String?  text;
  final String? imageUrl;
  final dynamic timestamp;
  final bool isLiked;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.text,
    this.imageUrl,
    this.timestamp,
    required this.isLiked,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    return Message(
      id: doc.id,
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      text: doc['text'],
      imageUrl: doc['imageUrl'],
      timestamp: doc['timestamp'],
      isLiked: doc['isLiked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'isLiked': isLiked,
    };
  }
}
