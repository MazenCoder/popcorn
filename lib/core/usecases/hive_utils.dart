import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'keys.dart';
import 'dart:io';


@lazySingleton
class HiveUtils {
  static late HiveUtils _hiveUtils;
  static Future<HiveUtils> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.openBox<dynamic>(Keys.loginInfo);
    await Hive.openBox<dynamic>(Keys.settings);
    _hiveUtils = HiveUtils();
    return _hiveUtils;
  }
}