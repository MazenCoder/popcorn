// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'create':
      return RoomCreateModel.fromJson(json);
    case 'author':
      return RoomAuthorModel.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'RoomModel',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$RoomModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  Object get author => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get roomImage => throw _privateConstructorUsedError;
  String? get backgroundImage => throw _privateConstructorUsedError;
  String? get toastMessage => throw _privateConstructorUsedError;
  List<String> get members => throw _privateConstructorUsedError;
  List<String> get banned => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)
        create,
    required TResult Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)
        author,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        create,
    TResult? Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        author,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        create,
    TResult Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        author,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomCreateModel value) create,
    required TResult Function(RoomAuthorModel value) author,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomCreateModel value)? create,
    TResult? Function(RoomAuthorModel value)? author,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomCreateModel value)? create,
    TResult Function(RoomAuthorModel value)? author,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoomModelCopyWith<RoomModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomModelCopyWith<$Res> {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) then) =
      _$RoomModelCopyWithImpl<$Res, RoomModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String name,
      String description,
      String? bio,
      int status,
      String? token,
      String? roomImage,
      String? backgroundImage,
      String? toastMessage,
      List<String> members,
      List<String> banned,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$RoomModelCopyWithImpl<$Res, $Val extends RoomModel>
    implements $RoomModelCopyWith<$Res> {
  _$RoomModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? bio = freezed,
    Object? status = null,
    Object? token = freezed,
    Object? roomImage = freezed,
    Object? backgroundImage = freezed,
    Object? toastMessage = freezed,
    Object? members = null,
    Object? banned = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      roomImage: freezed == roomImage
          ? _value.roomImage
          : roomImage // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _value.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      toastMessage: freezed == toastMessage
          ? _value.toastMessage
          : toastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      banned: null == banned
          ? _value.banned
          : banned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoomCreateModelImplCopyWith<$Res>
    implements $RoomModelCopyWith<$Res> {
  factory _$$RoomCreateModelImplCopyWith(_$RoomCreateModelImpl value,
          $Res Function(_$RoomCreateModelImpl) then) =
      __$$RoomCreateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String author,
      String name,
      String description,
      String? bio,
      int status,
      String? token,
      String? roomImage,
      String? backgroundImage,
      String? toastMessage,
      List<String> members,
      List<String> banned,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$RoomCreateModelImplCopyWithImpl<$Res>
    extends _$RoomModelCopyWithImpl<$Res, _$RoomCreateModelImpl>
    implements _$$RoomCreateModelImplCopyWith<$Res> {
  __$$RoomCreateModelImplCopyWithImpl(
      _$RoomCreateModelImpl _value, $Res Function(_$RoomCreateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? name = null,
    Object? description = null,
    Object? bio = freezed,
    Object? status = null,
    Object? token = freezed,
    Object? roomImage = freezed,
    Object? backgroundImage = freezed,
    Object? toastMessage = freezed,
    Object? members = null,
    Object? banned = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$RoomCreateModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      roomImage: freezed == roomImage
          ? _value.roomImage
          : roomImage // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _value.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      toastMessage: freezed == toastMessage
          ? _value.toastMessage
          : toastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      banned: null == banned
          ? _value._banned
          : banned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomCreateModelImpl
    with DiagnosticableTreeMixin
    implements RoomCreateModel {
  const _$RoomCreateModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.author,
      required this.name,
      required this.description,
      this.bio,
      required this.status,
      this.token,
      this.roomImage,
      this.backgroundImage,
      this.toastMessage,
      required final List<String> members,
      required final List<String> banned,
      required this.createdAt,
      required this.updatedAt,
      final String? $type})
      : _members = members,
        _banned = banned,
        $type = $type ?? 'create';

  factory _$RoomCreateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomCreateModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String author;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? bio;
  @override
  final int status;
  @override
  final String? token;
  @override
  final String? roomImage;
  @override
  final String? backgroundImage;
  @override
  final String? toastMessage;
  final List<String> _members;
  @override
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<String> _banned;
  @override
  List<String> get banned {
    if (_banned is EqualUnmodifiableListView) return _banned;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banned);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RoomModel.create(id: $id, author: $author, name: $name, description: $description, bio: $bio, status: $status, token: $token, roomImage: $roomImage, backgroundImage: $backgroundImage, toastMessage: $toastMessage, members: $members, banned: $banned, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RoomModel.create'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('author', author))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('bio', bio))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('roomImage', roomImage))
      ..add(DiagnosticsProperty('backgroundImage', backgroundImage))
      ..add(DiagnosticsProperty('toastMessage', toastMessage))
      ..add(DiagnosticsProperty('members', members))
      ..add(DiagnosticsProperty('banned', banned))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomCreateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.roomImage, roomImage) ||
                other.roomImage == roomImage) &&
            (identical(other.backgroundImage, backgroundImage) ||
                other.backgroundImage == backgroundImage) &&
            (identical(other.toastMessage, toastMessage) ||
                other.toastMessage == toastMessage) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._banned, _banned) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      author,
      name,
      description,
      bio,
      status,
      token,
      roomImage,
      backgroundImage,
      toastMessage,
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_banned),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomCreateModelImplCopyWith<_$RoomCreateModelImpl> get copyWith =>
      __$$RoomCreateModelImplCopyWithImpl<_$RoomCreateModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)
        create,
    required TResult Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)
        author,
  }) {
    return create(
        id,
        this.author,
        name,
        description,
        bio,
        status,
        token,
        roomImage,
        backgroundImage,
        toastMessage,
        members,
        banned,
        createdAt,
        updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        create,
    TResult? Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        author,
  }) {
    return create?.call(
        id,
        this.author,
        name,
        description,
        bio,
        status,
        token,
        roomImage,
        backgroundImage,
        toastMessage,
        members,
        banned,
        createdAt,
        updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        create,
    TResult Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        author,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(
          id,
          this.author,
          name,
          description,
          bio,
          status,
          token,
          roomImage,
          backgroundImage,
          toastMessage,
          members,
          banned,
          createdAt,
          updatedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomCreateModel value) create,
    required TResult Function(RoomAuthorModel value) author,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomCreateModel value)? create,
    TResult? Function(RoomAuthorModel value)? author,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomCreateModel value)? create,
    TResult Function(RoomAuthorModel value)? author,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomCreateModelImplToJson(
      this,
    );
  }
}

abstract class RoomCreateModel implements RoomModel {
  const factory RoomCreateModel(
      {@JsonKey(name: '_id') required final String id,
      required final String author,
      required final String name,
      required final String description,
      final String? bio,
      required final int status,
      final String? token,
      final String? roomImage,
      final String? backgroundImage,
      final String? toastMessage,
      required final List<String> members,
      required final List<String> banned,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$RoomCreateModelImpl;

  factory RoomCreateModel.fromJson(Map<String, dynamic> json) =
      _$RoomCreateModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get author;
  @override
  String get name;
  @override
  String get description;
  @override
  String? get bio;
  @override
  int get status;
  @override
  String? get token;
  @override
  String? get roomImage;
  @override
  String? get backgroundImage;
  @override
  String? get toastMessage;
  @override
  List<String> get members;
  @override
  List<String> get banned;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$RoomCreateModelImplCopyWith<_$RoomCreateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RoomAuthorModelImplCopyWith<$Res>
    implements $RoomModelCopyWith<$Res> {
  factory _$$RoomAuthorModelImplCopyWith(_$RoomAuthorModelImpl value,
          $Res Function(_$RoomAuthorModelImpl) then) =
      __$$RoomAuthorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      UserModel author,
      String name,
      String description,
      String? bio,
      int status,
      String? token,
      String? roomImage,
      String? backgroundImage,
      String? toastMessage,
      List<String> members,
      List<String> banned,
      DateTime createdAt,
      DateTime updatedAt});

  $UserModelCopyWith<$Res> get author;
}

/// @nodoc
class __$$RoomAuthorModelImplCopyWithImpl<$Res>
    extends _$RoomModelCopyWithImpl<$Res, _$RoomAuthorModelImpl>
    implements _$$RoomAuthorModelImplCopyWith<$Res> {
  __$$RoomAuthorModelImplCopyWithImpl(
      _$RoomAuthorModelImpl _value, $Res Function(_$RoomAuthorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? name = null,
    Object? description = null,
    Object? bio = freezed,
    Object? status = null,
    Object? token = freezed,
    Object? roomImage = freezed,
    Object? backgroundImage = freezed,
    Object? toastMessage = freezed,
    Object? members = null,
    Object? banned = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$RoomAuthorModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as UserModel,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      roomImage: freezed == roomImage
          ? _value.roomImage
          : roomImage // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _value.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      toastMessage: freezed == toastMessage
          ? _value.toastMessage
          : toastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      banned: null == banned
          ? _value._banned
          : banned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get author {
    return $UserModelCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value));
    });
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$RoomAuthorModelImpl
    with DiagnosticableTreeMixin
    implements RoomAuthorModel {
  const _$RoomAuthorModelImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.author,
      required this.name,
      required this.description,
      this.bio,
      required this.status,
      this.token,
      this.roomImage,
      this.backgroundImage,
      this.toastMessage,
      required final List<String> members,
      required final List<String> banned,
      required this.createdAt,
      required this.updatedAt,
      final String? $type})
      : _members = members,
        _banned = banned,
        $type = $type ?? 'author';

  factory _$RoomAuthorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomAuthorModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final UserModel author;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? bio;
  @override
  final int status;
  @override
  final String? token;
  @override
  final String? roomImage;
  @override
  final String? backgroundImage;
  @override
  final String? toastMessage;
  final List<String> _members;
  @override
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<String> _banned;
  @override
  List<String> get banned {
    if (_banned is EqualUnmodifiableListView) return _banned;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banned);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RoomModel.author(id: $id, author: $author, name: $name, description: $description, bio: $bio, status: $status, token: $token, roomImage: $roomImage, backgroundImage: $backgroundImage, toastMessage: $toastMessage, members: $members, banned: $banned, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RoomModel.author'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('author', author))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('bio', bio))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('roomImage', roomImage))
      ..add(DiagnosticsProperty('backgroundImage', backgroundImage))
      ..add(DiagnosticsProperty('toastMessage', toastMessage))
      ..add(DiagnosticsProperty('members', members))
      ..add(DiagnosticsProperty('banned', banned))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomAuthorModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.roomImage, roomImage) ||
                other.roomImage == roomImage) &&
            (identical(other.backgroundImage, backgroundImage) ||
                other.backgroundImage == backgroundImage) &&
            (identical(other.toastMessage, toastMessage) ||
                other.toastMessage == toastMessage) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._banned, _banned) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      author,
      name,
      description,
      bio,
      status,
      token,
      roomImage,
      backgroundImage,
      toastMessage,
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_banned),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomAuthorModelImplCopyWith<_$RoomAuthorModelImpl> get copyWith =>
      __$$RoomAuthorModelImplCopyWithImpl<_$RoomAuthorModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)
        create,
    required TResult Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)
        author,
  }) {
    return author(
        id,
        this.author,
        name,
        description,
        bio,
        status,
        token,
        roomImage,
        backgroundImage,
        toastMessage,
        members,
        banned,
        createdAt,
        updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        create,
    TResult? Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        author,
  }) {
    return author?.call(
        id,
        this.author,
        name,
        description,
        bio,
        status,
        token,
        roomImage,
        backgroundImage,
        toastMessage,
        members,
        banned,
        createdAt,
        updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @JsonKey(name: '_id') String id,
            String author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        create,
    TResult Function(
            @JsonKey(name: '_id') String id,
            UserModel author,
            String name,
            String description,
            String? bio,
            int status,
            String? token,
            String? roomImage,
            String? backgroundImage,
            String? toastMessage,
            List<String> members,
            List<String> banned,
            DateTime createdAt,
            DateTime updatedAt)?
        author,
    required TResult orElse(),
  }) {
    if (author != null) {
      return author(
          id,
          this.author,
          name,
          description,
          bio,
          status,
          token,
          roomImage,
          backgroundImage,
          toastMessage,
          members,
          banned,
          createdAt,
          updatedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RoomCreateModel value) create,
    required TResult Function(RoomAuthorModel value) author,
  }) {
    return author(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RoomCreateModel value)? create,
    TResult? Function(RoomAuthorModel value)? author,
  }) {
    return author?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RoomCreateModel value)? create,
    TResult Function(RoomAuthorModel value)? author,
    required TResult orElse(),
  }) {
    if (author != null) {
      return author(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomAuthorModelImplToJson(
      this,
    );
  }
}

abstract class RoomAuthorModel implements RoomModel {
  const factory RoomAuthorModel(
      {@JsonKey(name: '_id') required final String id,
      required final UserModel author,
      required final String name,
      required final String description,
      final String? bio,
      required final int status,
      final String? token,
      final String? roomImage,
      final String? backgroundImage,
      final String? toastMessage,
      required final List<String> members,
      required final List<String> banned,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$RoomAuthorModelImpl;

  factory RoomAuthorModel.fromJson(Map<String, dynamic> json) =
      _$RoomAuthorModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  UserModel get author;
  @override
  String get name;
  @override
  String get description;
  @override
  String? get bio;
  @override
  int get status;
  @override
  String? get token;
  @override
  String? get roomImage;
  @override
  String? get backgroundImage;
  @override
  String? get toastMessage;
  @override
  List<String> get members;
  @override
  List<String> get banned;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$RoomAuthorModelImplCopyWith<_$RoomAuthorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
