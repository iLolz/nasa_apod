import 'package:dio/dio.dart';

class DioService {
  Dio setup() {
    String baseUrl = const String.fromEnvironment('baseUrl');
    String apiKey = const String.fromEnvironment('apiKey');

    final BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        queryParameters: {
          'api_key': apiKey,
        });

    return Dio(options);
  }
}
