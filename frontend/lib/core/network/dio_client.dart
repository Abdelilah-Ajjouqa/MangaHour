import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import 'jikan_rate_limiter.dart';
import 'mangadex_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  @Named('jikanDio')
  Dio get jikanDio {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.jikanBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
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
        baseUrl: ApiConstants.mangadexBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );
    
    dio.interceptors.addAll([
      MangaDexInterceptor(),
      if (kDebugMode) LogInterceptor(responseBody: true, requestBody: true),
    ]);
    
    return dio;
  }
}
