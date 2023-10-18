import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:flutter/foundation.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';
@freezed
class RoomModel with _$RoomModel {

  const factory RoomModel.create({
    @JsonKey(name: '_id') required String id,
    required String author,
    required String name,
    required String description,
    String? bio,
    required int status,
    String? token,
    String? roomImage,
    String? backgroundImage,
    String? toastMessage,
    required List<String> members,
    required List<String> banned,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = RoomCreateModel;


  @JsonSerializable(explicitToJson: true)
  const factory RoomModel.author({
    @JsonKey(name: '_id') required String id,
    required UserModel author,
    required String name,
    required String description,
    String? bio,
    required int status,
    String? token,
    String? roomImage,
    String? backgroundImage,
    String? toastMessage,
    required List<String> members,
    required List<String> banned,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = RoomAuthorModel;


  factory RoomModel.fromJson(Map<String, Object?> json)
  => _$RoomModelFromJson(json);
}