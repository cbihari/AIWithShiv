import 'package:dio/dio.dart';

import '../../config/env.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio(_defaultOptions);

  final Dio _dio;

  static BaseOptions get _defaultOptions => BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      );

  Future<Response<Map<String, dynamic>>> postJson(
    String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) {
    return _dio.post<Map<String, dynamic>>(
      url,
      data: data,
      options: Options(headers: headers),
    );
  }

  String get openAiBaseUrl => Env.openAiApiBaseUrl;
  String get geminiBaseUrl => Env.geminiApiBaseUrl;
  String get bedrockProxyBaseUrl => Env.bedrockProxyBaseUrl;
}
