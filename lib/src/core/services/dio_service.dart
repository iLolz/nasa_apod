import 'package:dio/dio.dart';

class DioService {
  Dio setup() {
    const baseUrl = String.fromEnvironment('baseUrl');
    const apiKey = String.fromEnvironment('apiKey');

    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      queryParameters: {
        'api_key': apiKey,
      },
    );

    return Dio(options);
  }
}
