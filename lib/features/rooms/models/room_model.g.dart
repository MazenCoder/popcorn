// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomCreateModelImpl _$$RoomCreateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RoomCreateModelImpl(
      id: json['_id'] as String,
      author: json['author'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      bio: json['bio'] as String?,
      status: json['status'] as int,
      token: json['token'] as String?,
      roomImage: json['roomImage'] as String?,
      backgroundImage: json['backgroundImage'] as String?,
      toastMessage: json['toastMessage'] as String?,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      banned:
          (json['banned'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RoomCreateModelImplToJson(
        _$RoomCreateModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'author': instance.author,
      'name': instance.name,
      'description': instance.description,
      'bio': instance.bio,
      'status': instance.status,
      'token': instance.token,
      'roomImage': instance.roomImage,
      'backgroundImage': instance.backgroundImage,
      'toastMessage': instance.toastMessage,
      'members': instance.members,
      'banned': instance.banned,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'runtimeType': instance.$type,
    };

_$RoomAuthorModelImpl _$$RoomAuthorModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RoomAuthorModelImpl(
      id: json['_id'] as String,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
      name: json['name'] as String,
      description: json['description'] as String,
      bio: json['bio'] as String?,
      status: json['status'] as int,
      token: json['token'] as String?,
      roomImage: json['roomImage'] as String?,
      backgroundImage: json['backgroundImage'] as String?,
      toastMessage: json['toastMessage'] as String?,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      banned:
          (json['banned'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RoomAuthorModelImplToJson(
        _$RoomAuthorModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'author': instance.author.toJson(),
      'name': instance.name,
      'description': instance.description,
      'bio': instance.bio,
      'status': instance.status,
      'token': instance.token,
      'roomImage': instance.roomImage,
      'backgroundImage': instance.backgroundImage,
      'toastMessage': instance.toastMessage,
      'members': instance.members,
      'banned': instance.banned,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'runtimeType': instance.$type,
    };
