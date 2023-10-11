// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class CategoryModel {
//
//   final String id;
//   final String url;
//   final String category;
//   final dynamic timestamp;
//
//   CategoryModel({this.id, this.url, this.category, this.timestamp});
//
//   factory CategoryModel.fromJson(Map<String, dynamic> json) {
//     return CategoryModel(
//       id: json['id'],
//       url: json['url'],
//       category: json['category'],
//       timestamp: json['timestamp'].toDate(),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'url': url,
//     'category': category,
//     'timestamp': FieldValue.serverTimestamp(),
//   };
// }