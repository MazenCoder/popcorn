import 'package:hive_flutter/hive_flutter.dart';
import 'keys.dart';



class HiveUtils {
  static late HiveUtils _hiveUtils;
  static Future<HiveUtils> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(Keys.loginInfo);
    await Hive.openBox<dynamic>(Keys.settings);
    _hiveUtils = HiveUtils();
    return _hiveUtils;
  }
}