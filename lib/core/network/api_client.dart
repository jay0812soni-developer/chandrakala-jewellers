import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../services/logger_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.debug('HTTP REQ [${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.debug('HTTP RES [${response.statusCode}] <= ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          AppLogger.error(
            'HTTP ERR [${error.response?.statusCode}] ${error.requestOptions.uri}: ${error.message}',
            error,
            error.stackTrace,
          );
          return handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}
