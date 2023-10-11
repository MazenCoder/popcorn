import '../usecases/constants.dart';
import 'dart:convert';


UserModel userModelFromJson(var data) => UserModel.fromJson(data);
UserModel userModelFromJsonDecode(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJsonFormat());

class UserModel {

  UserModel({
    required this.email,
    required this.displayName,
    required this.uid,
    required this.uniqueKey,
    this.password,
    this.gender,
    this.token,
    this.timestamp,
    this.photoProfile,
    required this.role,
    this.dateBirth,
    this.phone,
    this.countryCode,
    this.countryName,
    this.dialingCode,
    required this.status,
    required this.isVerified,
    required this.level,
    this.bio,
  });

  final String email;
  final String displayName;
  final String uid;
  final int uniqueKey;
  final String? password;
  final String? gender;
  final String? token;
  final dynamic timestamp;
  final String? photoProfile;
  final String role;
  final DateTime? dateBirth;
  final String? phone;
  final String? countryCode;
  final String? countryName;
  final String? dialingCode;
  final int status;
  final bool isVerified;
  final int level;
  final String? bio;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    displayName: json["displayName"],
    uid: json["uid"],
    uniqueKey: json["uniqueKey"],
    password: json["password"],
    gender: json["gender"],
    token: json["token"],
    timestamp: (json["timestamp"] != null) ? json["timestamp"].toDate() : null,
    photoProfile: json["photoProfile"],
    role: json["role"],
    dateBirth: (json["dateBirth"] != null) ? json["dateBirth"].toDate() : null,
    status: json["status"],
    phone: json["phone"],
    countryCode: json["countryCode"],
    countryName: json["countryName"],
    dialingCode: json["dialingCode"],
    isVerified: json["isVerified"],
    level: json["level"],
    bio: json["bio"],
  );


  Map<String, dynamic> toJson() => {
    "email": email,
    "displayName": displayName,
    "uid": uid,
    "uniqueKey": uniqueKey,
    "password": password,
    "gender": gender,
    "token": token,
    "timestamp": timestamp,
    "photoProfile": photoProfile,
    "role": role,
    "dateBirth": dateBirth,
    "status": status,
    "phone": phone,
    "countryCode": countryCode,
    "countryName": countryName,
    "dialingCode": dialingCode,
    "isVerified": isVerified,
    "level": level,
    "bio": bio,
  };

  Map<String, dynamic> toUpdateJson() => {
    "displayName": displayName,
    "phone": phone,
    "countryCode": countryCode,
    "countryName": countryName,
    "dialingCode": dialingCode,
  };

  Map<String, dynamic> toUpdateNewEmail(String newEmail) => {
    "email": newEmail,
    "displayName": displayName,
    "phone": phone,
    "countryCode": countryCode,
    "countryName": countryName,
    "dialingCode": dialingCode,
  };

  Map<String, dynamic> toJsonFormat() => {
    "email": email,
    "displayName": displayName,
    "uid": uid,
    "uniqueKey": uniqueKey,
    "password": password,
    "gender": gender,
    "token": token,
    "timestamp": dateFormat.format(timestamp),
    "photoProfile": photoProfile,
    "role": role,
    "dateBirth": dateBirth,
    "status": status,
    "phone": phone,
    "countryCode": countryCode,
    "countryName": countryName,
    "dialingCode": dialingCode,
    "isVerified": isVerified,
    "level": level,
    "bio": bio,
  };

  Map<String, dynamic> toJsonUid({required String uid, required int uniqueKey}) => {
    "email": email,
    "displayName": displayName,
    "uid": uid,
    "uniqueKey": uniqueKey,
    "password": password,
    "gender": gender,
    "token": token,
    "timestamp": timestamp, //FieldValue.serverTimestamp()
    "photoProfile": photoProfile,
    "role": role,
    "dateBirth": dateBirth,
    "status": status,
    "phone": phone,
    "countryCode": countryCode,
    "countryName": countryName,
    "dialingCode": dialingCode,
    "isVerified": isVerified,
    "level": level,
    "bio": bio,
  };
}