import 'package:dio/dio.dart';

import '../errors/exceptions.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          switch (response.statusCode) {
            case 200:
            case 201:
              handler.next(response);
              break;

            case 400:
              throw BadRequestException('Bad request');

            case 401:
              throw UnauthorizedException('Unauthorized');

            case 403:
              throw ForbiddenException('Forbidden');

            case 404:
             print('404 ERROR: Resource not found');
              throw NotFoundException('Resource not found');

            case 500:
              throw ServerException('Internal server error');

            case 503:
              throw ServerException('Service unavailable');

            default:
              throw ServerException(
                'Unexpected server error: ${response.statusCode}',
              );
          }
        },

        onError: (DioException error, handler) {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            throw TimeoutException('Request timed out');
          }

          if (error.type == DioExceptionType.connectionError) {
            throw NetworkException('No internet connection');
          }

          handler.next(error);
        },
      ),
    );

    return dio;
  }
}