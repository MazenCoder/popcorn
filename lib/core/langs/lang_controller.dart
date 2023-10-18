import 'package:flutter/material.dart';
import '../usecases/constants.dart';
import '../usecases/boxes.dart';
import '../usecases/keys.dart';
import 'package:get/get.dart';



class LangController extends GetxController {
  static LangController instance = Get.find();
  final box = Boxes.settings();


  @override
  void onInit() {
    getLocale();
    super.onInit();
  }


  Locale getLocale() {
    try {
      String locale = box.get(
        Keys.locale,
        defaultValue: 'ar',
      );
      return Locale(locale);
    } catch (e) {
      logger.e(e);
      return const Locale('ar');
    }
  }

  bool isLtr() {
    String locale = box.get(Keys.locale, defaultValue: 'en');
    final lung = Get.locale ?? Locale(locale);
    return lung.languageCode == 'ar';
  }

  Locale getSystemLocale() {
    String locale = box.get(Keys.locale, defaultValue: 'en');
    return Get.deviceLocale ?? Locale(locale);
  }

  Future<void> updateLocal(String long) async {
    var locale = Locale(long);
    await box.put(Keys.locale, long);
    Get.updateLocale(locale);
  }

  bool isRtl() {
    String locale = box.get(Keys.locale, defaultValue: 'en');
    final lung = Get.locale ?? Locale(locale);
    return lung.languageCode == 'ar';
  }


}
