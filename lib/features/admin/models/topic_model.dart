
class TopicModel {

  String id;
  String topic;

  TopicModel({
    required this.id,
    required this.topic
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) => TopicModel(
    id: json['id'],
    topic: json['topic'],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
    };
  }

}