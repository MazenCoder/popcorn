// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i6;

import 'package:cloud_firestore/cloud_firestore.dart' as _i9;
import 'package:firebase_auth/firebase_auth.dart' as _i8;
import 'package:firebase_messaging/firebase_messaging.dart' as _i10;
import 'package:firebase_storage/firebase_storage.dart' as _i11;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i12;
import 'package:http/http.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:popcorn/core/injection/register_firebase.dart' as _i15;
import 'package:popcorn/core/injection/register_module.dart' as _i16;
import 'package:popcorn/core/usecases/hive_utils.dart' as _i13;
import 'package:popcorn/core/util/app_utils.dart' as _i3;
import 'package:popcorn/core/util/app_utils_impl.dart' as _i4;
import 'package:popcorn/features/account/cubit/user_profile_cubit.dart' as _i14;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    final registerFirebase = _$RegisterFirebase();
    gh.lazySingleton<_i3.AppUtils>(() => _i4.AppUtilsImpl());
    gh.lazySingleton<_i5.Client>(() => registerModule.httpClient);
    await gh.factoryAsync<_i6.Directory>(
      () => registerModule.directory,
      preResolve: true,
    );
    gh.lazySingleton<_i7.FacebookAuth>(() => registerFirebase.facebookAuth);
    gh.lazySingleton<_i8.FirebaseAuth>(() => registerFirebase.auth);
    gh.lazySingleton<_i9.FirebaseFirestore>(
        () => registerFirebase.cloudfirestore);
    gh.singleton<_i10.FirebaseMessaging>(registerFirebase.firebaseMessaging);
    gh.lazySingleton<_i11.FirebaseStorage>(() => registerFirebase.storage);
    gh.lazySingleton<_i12.GoogleSignIn>(() => registerFirebase.googleSignIn);
    gh.lazySingleton<_i13.HiveUtils>(() => _i13.HiveUtils());
    gh.factory<_i14.UserProfileCubit>(() => _i14.UserProfileCubit());
    return this;
  }
}

class _$RegisterFirebase extends _i15.RegisterFirebase {}

class _$RegisterModule extends _i16.RegisterModule {}
