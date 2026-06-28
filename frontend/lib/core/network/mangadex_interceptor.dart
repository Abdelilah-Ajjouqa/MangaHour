import 'dart:async';
import 'package:dio/dio.dart';

/// MangaDex API Rate limit: 5 requests per second
class MangaDexInterceptor extends Interceptor {
  DateTime? _lastRequestTime;
  final Duration _minInterval = const Duration(milliseconds: 200); // 5 per second

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // MangaDex requires a User-Agent
    options.headers['User-Agent'] = 'MangaHourApp/1.0';

    if (_lastRequestTime != null) {
      final timeSinceLast = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLast < _minInterval) {
        await Future.delayed(_minInterval - timeSinceLast);
      }
    }
    
    _lastRequestTime = DateTime.now();
    handler.next(options);
  }
}
