// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['_id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      password: json['password'] as String?,
      genderId: json['genderId'] as int?,
      token: json['token'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      photoProfile: json['photoProfile'] as String?,
      role: json['role'] as String,
      dateBirth: json['dateBirth'] == null
          ? null
          : DateTime.parse(json['dateBirth'] as String),
      phone: json['phone'] as String?,
      countryCode: json['countryCode'] as String?,
      countryName: json['countryName'] as String?,
      dialingCode: json['dialingCode'] as String?,
      isVerified: json['isVerified'] as bool,
      isBanned: json['isBanned'] as bool,
      hideIntro: json['hideIntro'] as bool,
      blocks:
          (json['blocks'] as List<dynamic>).map((e) => e as String).toList(),
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'password': instance.password,
      'genderId': instance.genderId,
      'token': instance.token,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastSeen': instance.lastSeen.toIso8601String(),
      'photoProfile': instance.photoProfile,
      'role': instance.role,
      'dateBirth': instance.dateBirth?.toIso8601String(),
      'phone': instance.phone,
      'countryCode': instance.countryCode,
      'countryName': instance.countryName,
      'dialingCode': instance.dialingCode,
      'isVerified': instance.isVerified,
      'isBanned': instance.isBanned,
      'hideIntro': instance.hideIntro,
      'blocks': instance.blocks,
      'bio': instance.bio,
    };
