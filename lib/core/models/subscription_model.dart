

class SubscriptionModel {
  final String subscriptionId;
  final String paymentMethod;
  final String customerId;
  final int planId;
  final dynamic timestamp;

  SubscriptionModel({
    required this.subscriptionId,
    required this.paymentMethod,
    required this.customerId,
    required this.planId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    "subscriptionId": subscriptionId,
    "paymentMethod": paymentMethod,
    "customerId": customerId,
    "planId": planId,
    "timestamp": timestamp,
  };

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
    subscriptionId: json["subscriptionId"],
    paymentMethod: json["paymentMethod"],
    customerId: json["customerId"],
    planId: json["planId"],
    timestamp: json["timestamp"],
  );
}