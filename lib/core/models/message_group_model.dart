import 'package:cloud_firestore/cloud_firestore.dart';

class MessageGroup {
  final String id;
  final String senderId;
  final List<String> receiverId;
  final String? text;
  final String? imageUrl;
  // final String giphyUrl;
  final dynamic timestamp;
  final bool isLiked;

  MessageGroup({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.text,
    this.imageUrl,
    this.timestamp,
    // this.giphyUrl,
    required this.isLiked,
  });

  factory MessageGroup.fromDoc(DocumentSnapshot doc) {
    return MessageGroup(
      id: doc.id,
      senderId: doc['senderId'],
      receiverId: doc["receiverId"] != null ? List.from(doc["receiverId"]) : [],
      text: doc['text'],
      imageUrl: doc['imageUrl'],
      timestamp: parsTimestamp(doc['timestamp']),
      isLiked: doc['isLiked'],
      // giphyUrl: doc['giphyUrl'] ?? "",
    );
  }

  static DateTime parsTimestamp(dynamic val) {
    Timestamp? timestamp;
    if (val is Timestamp) {
      // the firestore SDK formats the timestamp as a timestamp
      timestamp = val;
    } else if (val is Map) {
      // cloud functions formate the timestamp as a map
      timestamp = Timestamp(val['_seconds'] as int, val['_nanoseconds'] as int);
    }
    if (timestamp != null) {
      return timestamp.toDate();
    } else {
      // Timestamp probably not yet written server side
      return Timestamp.now().toDate();
    }
  }
}
