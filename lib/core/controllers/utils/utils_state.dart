import 'package:flutter/material.dart';
import '../../models/frame_model.dart';
import '../../models/gift_model.dart';
import 'package:get/get.dart';


class UtilsState {

  late List<GiftModel> gifts;
  late List<FrameModel> frames;
  RxString id = ''.obs;
  RxBool isDarkTheme = false.obs;
  ThemeMode get themeStateMode => isDarkTheme.value ? ThemeMode.dark : ThemeMode.light;

  late String version;
  late bool isLoading;


  UtilsState() {
    version = '1.0.0';
    isLoading = false;
    gifts = [];
    frames = [];
    id = ''.obs;
  }

}
