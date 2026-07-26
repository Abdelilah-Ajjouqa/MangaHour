import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

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
      if (kDebugMode) LogInterceptor(responseBody: true, requestBody: true),
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
      if (kDebugMode) LogInterceptor(responseBody: true, requestBody: true),
    ]);
    
    return dio;
  }
}
