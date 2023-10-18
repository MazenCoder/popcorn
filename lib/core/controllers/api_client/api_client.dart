import 'package:http/http.dart' as http;
import '../../usecases/constants.dart';
import '../../error/exceptions.dart';
import '../../usecases/enums.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:convert';



class ApiClient extends GetxService {
  static ApiClient instance = Get.find();

  Map<String, String> _headers = {};

  @override
  void onInit() {
    _headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    updateHeader();
    super.onInit();
  }

  Future<void> updateHeader() async {
    String? idToken = await userLogic.getIdToken();
    if (idToken != null) {
      _headers = {
        'authorization': idToken,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
    }
  }

  Future<http.Response> getData({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      await updateHeader();
      final response = await http.get(
        Uri.parse(url), headers: headers ?? _headers,
      );
      log('getData url: $url\n response: ${response.body}');
      return response;
    } catch(e) {
      logger.e(e);
      throw ServerException(
        state: RequestState.error,
        message: '$e',
      );
    }
  }


  Future<http.Response> putData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      await updateHeader();
      final response = await http.put(
        Uri.parse(url), headers: headers ?? _headers,
        body: data != null ? jsonEncode(data) : null,
      );
      log('putData url: $url\n response: ${response.body}');
      return response;
    } catch(e) {
      logger.e(e);
      throw ServerException(
        state: RequestState.error,
        message: '$e',
      );
    }
  }

  Future<http.Response> postData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      await updateHeader();
      final response = await http.post(
        Uri.parse(url), headers: headers ?? _headers,
        body: data != null ? jsonEncode(data) : null,
      );
      log('postData url: $url\n response: ${response.body}');
      return response;
    } catch(e) {
      logger.e(e);
      throw ServerException(
        state: RequestState.error,
        message: '$e',
      );
    }
  }

  Future<http.Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      await updateHeader();
      final response = await http.delete(
        Uri.parse(url), headers: headers ?? _headers,
        body: data != null ? jsonEncode(data) : null,
      );
      log('deleteData url: $url\n response: ${response.body}');
      return response;
    } catch(e) {
      logger.e(e);
      throw ServerException(
        state: RequestState.error,
        message: '$e',
      );
    }
  }

}