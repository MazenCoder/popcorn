// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @JsonKey(name: '_id')
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  int? get genderId => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get lastSeen => throw _privateConstructorUsedError;
  String? get photoProfile => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  DateTime? get dateBirth => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get countryCode => throw _privateConstructorUsedError;
  String? get countryName => throw _privateConstructorUsedError;
  String? get dialingCode => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  bool get isBanned => throw _privateConstructorUsedError;
  bool get hideIntro => throw _privateConstructorUsedError;
  List<String> get blocks => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String uid,
      String email,
      String displayName,
      String? password,
      int? genderId,
      String? token,
      DateTime createdAt,
      DateTime lastSeen,
      String? photoProfile,
      String role,
      DateTime? dateBirth,
      String? phone,
      String? countryCode,
      String? countryName,
      String? dialingCode,
      bool isVerified,
      bool isBanned,
      bool hideIntro,
      List<String> blocks,
      String? bio});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? password = freezed,
    Object? genderId = freezed,
    Object? token = freezed,
    Object? createdAt = null,
    Object? lastSeen = null,
    Object? photoProfile = freezed,
    Object? role = null,
    Object? dateBirth = freezed,
    Object? phone = freezed,
    Object? countryCode = freezed,
    Object? countryName = freezed,
    Object? dialingCode = freezed,
    Object? isVerified = null,
    Object? isBanned = null,
    Object? hideIntro = null,
    Object? blocks = null,
    Object? bio = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      genderId: freezed == genderId
          ? _value.genderId
          : genderId // ignore: cast_nullable_to_non_nullable
              as int?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      photoProfile: freezed == photoProfile
          ? _value.photoProfile
          : photoProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      dateBirth: freezed == dateBirth
          ? _value.dateBirth
          : dateBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countryName: freezed == countryName
          ? _value.countryName
          : countryName // ignore: cast_nullable_to_non_nullable
              as String?,
      dialingCode: freezed == dialingCode
          ? _value.dialingCode
          : dialingCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isBanned: null == isBanned
          ? _value.isBanned
          : isBanned // ignore: cast_nullable_to_non_nullable
              as bool,
      hideIntro: null == hideIntro
          ? _value.hideIntro
          : hideIntro // ignore: cast_nullable_to_non_nullable
              as bool,
      blocks: null == blocks
          ? _value.blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String uid,
      String email,
      String displayName,
      String? password,
      int? genderId,
      String? token,
      DateTime createdAt,
      DateTime lastSeen,
      String? photoProfile,
      String role,
      DateTime? dateBirth,
      String? phone,
      String? countryCode,
      String? countryName,
      String? dialingCode,
      bool isVerified,
      bool isBanned,
      bool hideIntro,
      List<String> blocks,
      String? bio});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? password = freezed,
    Object? genderId = freezed,
    Object? token = freezed,
    Object? createdAt = null,
    Object? lastSeen = null,
    Object? photoProfile = freezed,
    Object? role = null,
    Object? dateBirth = freezed,
    Object? phone = freezed,
    Object? countryCode = freezed,
    Object? countryName = freezed,
    Object? dialingCode = freezed,
    Object? isVerified = null,
    Object? isBanned = null,
    Object? hideIntro = null,
    Object? blocks = null,
    Object? bio = freezed,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      genderId: freezed == genderId
          ? _value.genderId
          : genderId // ignore: cast_nullable_to_non_nullable
              as int?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      photoProfile: freezed == photoProfile
          ? _value.photoProfile
          : photoProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      dateBirth: freezed == dateBirth
          ? _value.dateBirth
          : dateBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countryName: freezed == countryName
          ? _value.countryName
          : countryName // ignore: cast_nullable_to_non_nullable
              as String?,
      dialingCode: freezed == dialingCode
          ? _value.dialingCode
          : dialingCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isBanned: null == isBanned
          ? _value.isBanned
          : isBanned // ignore: cast_nullable_to_non_nullable
              as bool,
      hideIntro: null == hideIntro
          ? _value.hideIntro
          : hideIntro // ignore: cast_nullable_to_non_nullable
              as bool,
      blocks: null == blocks
          ? _value._blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl with DiagnosticableTreeMixin implements _UserModel {
  const _$UserModelImpl(
      {@JsonKey(name: '_id') required this.uid,
      required this.email,
      required this.displayName,
      this.password,
      this.genderId,
      this.token,
      required this.createdAt,
      required this.lastSeen,
      this.photoProfile,
      required this.role,
      this.dateBirth,
      this.phone,
      this.countryCode,
      this.countryName,
      this.dialingCode,
      required this.isVerified,
      required this.isBanned,
      required this.hideIntro,
      required final List<String> blocks,
      this.bio})
      : _blocks = blocks;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String uid;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String? password;
  @override
  final int? genderId;
  @override
  final String? token;
  @override
  final DateTime createdAt;
  @override
  final DateTime lastSeen;
  @override
  final String? photoProfile;
  @override
  final String role;
  @override
  final DateTime? dateBirth;
  @override
  final String? phone;
  @override
  final String? countryCode;
  @override
  final String? countryName;
  @override
  final String? dialingCode;
  @override
  final bool isVerified;
  @override
  final bool isBanned;
  @override
  final bool hideIntro;
  final List<String> _blocks;
  @override
  List<String> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  @override
  final String? bio;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName, password: $password, genderId: $genderId, token: $token, createdAt: $createdAt, lastSeen: $lastSeen, photoProfile: $photoProfile, role: $role, dateBirth: $dateBirth, phone: $phone, countryCode: $countryCode, countryName: $countryName, dialingCode: $dialingCode, isVerified: $isVerified, isBanned: $isBanned, hideIntro: $hideIntro, blocks: $blocks, bio: $bio)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserModel'))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('password', password))
      ..add(DiagnosticsProperty('genderId', genderId))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('lastSeen', lastSeen))
      ..add(DiagnosticsProperty('photoProfile', photoProfile))
      ..add(DiagnosticsProperty('role', role))
      ..add(DiagnosticsProperty('dateBirth', dateBirth))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('countryCode', countryCode))
      ..add(DiagnosticsProperty('countryName', countryName))
      ..add(DiagnosticsProperty('dialingCode', dialingCode))
      ..add(DiagnosticsProperty('isVerified', isVerified))
      ..add(DiagnosticsProperty('isBanned', isBanned))
      ..add(DiagnosticsProperty('hideIntro', hideIntro))
      ..add(DiagnosticsProperty('blocks', blocks))
      ..add(DiagnosticsProperty('bio', bio));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.genderId, genderId) ||
                other.genderId == genderId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.photoProfile, photoProfile) ||
                other.photoProfile == photoProfile) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.dateBirth, dateBirth) ||
                other.dateBirth == dateBirth) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.countryName, countryName) ||
                other.countryName == countryName) &&
            (identical(other.dialingCode, dialingCode) ||
                other.dialingCode == dialingCode) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isBanned, isBanned) ||
                other.isBanned == isBanned) &&
            (identical(other.hideIntro, hideIntro) ||
                other.hideIntro == hideIntro) &&
            const DeepCollectionEquality().equals(other._blocks, _blocks) &&
            (identical(other.bio, bio) || other.bio == bio));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uid,
        email,
        displayName,
        password,
        genderId,
        token,
        createdAt,
        lastSeen,
        photoProfile,
        role,
        dateBirth,
        phone,
        countryCode,
        countryName,
        dialingCode,
        isVerified,
        isBanned,
        hideIntro,
        const DeepCollectionEquality().hash(_blocks),
        bio
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {@JsonKey(name: '_id') required final String uid,
      required final String email,
      required final String displayName,
      final String? password,
      final int? genderId,
      final String? token,
      required final DateTime createdAt,
      required final DateTime lastSeen,
      final String? photoProfile,
      required final String role,
      final DateTime? dateBirth,
      final String? phone,
      final String? countryCode,
      final String? countryName,
      final String? dialingCode,
      required final bool isVerified,
      required final bool isBanned,
      required final bool hideIntro,
      required final List<String> blocks,
      final String? bio}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get uid;
  @override
  String get email;
  @override
  String get displayName;
  @override
  String? get password;
  @override
  int? get genderId;
  @override
  String? get token;
  @override
  DateTime get createdAt;
  @override
  DateTime get lastSeen;
  @override
  String? get photoProfile;
  @override
  String get role;
  @override
  DateTime? get dateBirth;
  @override
  String? get phone;
  @override
  String? get countryCode;
  @override
  String? get countryName;
  @override
  String? get dialingCode;
  @override
  bool get isVerified;
  @override
  bool get isBanned;
  @override
  bool get hideIntro;
  @override
  List<String> get blocks;
  @override
  String? get bio;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
