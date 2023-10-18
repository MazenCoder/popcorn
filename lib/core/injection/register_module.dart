import 'package:path_provider/path_provider.dart';
import 'package:injectable/injectable.dart';
// import 'package:agora_rtm/agora_rtm.dart';
import 'package:http/http.dart' as http;
import '../usecases/constants.dart';
import 'dart:io';

import '../usecases/hive_utils.dart';


@module
abstract class RegisterModule {

  @preResolve
  Future<Directory> get directory => getApplicationDocumentsDirectory();

  // @lazySingleton
  // Future<AgoraRtmClient> get client => AgoraRtmClient.createInstance(appId);

  @lazySingleton
  http.Client get httpClient => http.Client();

  @preResolve
  Future<HiveUtils> get hiveUtils => HiveUtils.init();

}
