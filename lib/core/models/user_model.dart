import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';
@freezed
class UserModel with _$UserModel {

  const factory UserModel({
    @JsonKey(name: '_id') required String uid,
    required String email,
    required String displayName,
    String? password,
    int? genderId,
    String? token,
    required DateTime createdAt,
    required DateTime lastSeen,
    String? photoProfile,
    required String role,
    DateTime? dateBirth,
    String? phone,
    String? countryCode,
    String? countryName,
    String? dialingCode,
    required bool isVerified,
    required bool isBanned,
    required bool hideIntro,
    required List<String> blocks,
    String? bio
  }) = _UserModel;


  factory UserModel.fromJson(Map<String, Object?> json)
  => _$UserModelFromJson(json);
}