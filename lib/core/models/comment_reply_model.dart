

class CommentReplyModel {
  final String idComment;
  final String firstName;
  final String uid;

  CommentReplyModel({
    required this.idComment,
    required this.firstName,
    required this.uid
  });

  factory CommentReplyModel.fromJson(Map<String, dynamic> data) {
    return CommentReplyModel(
      idComment: data['idComment'],
      firstName: data['firstName'],
      uid: data['uid'],
    );
  }


}