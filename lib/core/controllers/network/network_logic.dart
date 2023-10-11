import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/services.dart';
import '../../usecases/constants.dart';
import 'package:get/get.dart';
import 'network_state.dart';
import 'dart:async';


class NetworkLogic extends GetxController {
  static NetworkLogic instance = Get.find();
  final state = NetworkState();

  late StreamSubscription _streamSubscription;


  @override
  void onInit() {
    _streamSubscription = InternetConnectionChecker().onStatusChange.listen(_updateState);
    super.onInit();
  }

  @override
  void onReady() {
    hasConnection();
    super.onReady();
  }


  Future<void> getConnectionType() async {
    late InternetConnectionStatus result;
    try {
      result = await InternetConnectionChecker().connectionStatus;
    } on PlatformException catch (e) {
      logger.e(e);
    }
    return _updateState(result);
  }

  Future<void> hasConnection() async {
    try {
      state.isConnected = await InternetConnectionChecker().hasConnection;
      update();
      logger.v('Data connection is ${state.isConnected}');
    } on PlatformException catch (e) {
      logger.e(e);
    }
  }

  void _updateState(InternetConnectionStatus status) {
    logger.v('Connection Status: ${status.index}');
    switch (status) {
      case InternetConnectionStatus.connected:
        logger.v('Data connection is true');
        state.isConnected = true;
        update();
        break;
      case InternetConnectionStatus.disconnected:
        logger.v('Data connection is false');
        state.isConnected = false;
        update();
        break;
      default:
        logger.v('Data connection is false');
        state.isConnected = false;
        update();
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}