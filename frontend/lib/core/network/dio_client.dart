import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'jikan_rate_limiter.dart';
import 'mangadex_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  @Named('jikanDio')
  Dio get jikanDio {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.jikan.moe/v4',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    
    dio.interceptors.addAll([
      JikanRateLimiterInterceptor(),
      LogInterceptor(responseBody: true, requestBody: true),
    ]);
    
    return dio;
  }

  @lazySingleton
  @Named('mangadexDio')
  Dio get mangadexDio {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.mangadex.org',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    
    dio.interceptors.addAll([
      MangaDexInterceptor(),
      LogInterceptor(responseBody: true, requestBody: true),
    ]);
    
    return dio;
  }
}
