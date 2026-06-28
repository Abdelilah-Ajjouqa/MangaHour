import 'dart:async';
import 'dart:collection';
import 'package:dio/dio.dart';

/// Jikan API Rate limits: 3 requests per second, 60 requests per minute
class JikanRateLimiterInterceptor extends Interceptor {
  final int requestsPerSecond;
  final int requestsPerMinute;
  
  final Queue<DateTime> _secondQueue = Queue<DateTime>();
  final Queue<DateTime> _minuteQueue = Queue<DateTime>();

  JikanRateLimiterInterceptor({
    this.requestsPerSecond = 3,
    this.requestsPerMinute = 60,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _waitForRateLimit();
    final now = DateTime.now();
    _secondQueue.add(now);
    _minuteQueue.add(now);
    handler.next(options);
  }

  Future<void> _waitForRateLimit() async {
    while (true) {
      final now = DateTime.now();
      
      // Clean up old entries
      while (_secondQueue.isNotEmpty && now.difference(_secondQueue.first).inSeconds >= 1) {
        _secondQueue.removeFirst();
      }
      while (_minuteQueue.isNotEmpty && now.difference(_minuteQueue.first).inMinutes >= 1) {
        _minuteQueue.removeFirst();
      }

      if (_secondQueue.length < requestsPerSecond && _minuteQueue.length < requestsPerMinute) {
        break; // We can proceed
      }

      // Calculate how long to wait
      Duration waitTime = const Duration(milliseconds: 100);
      if (_secondQueue.length >= requestsPerSecond) {
        final timeSinceFirst = now.difference(_secondQueue.first);
        final waitSecond = const Duration(seconds: 1) - timeSinceFirst;
        if (waitSecond > waitTime) waitTime = waitSecond;
      }
      
      if (_minuteQueue.length >= requestsPerMinute) {
        final timeSinceFirstMinute = now.difference(_minuteQueue.first);
        final waitMinute = const Duration(minutes: 1) - timeSinceFirstMinute;
        if (waitMinute > waitTime) waitTime = waitMinute;
      }
      
      await Future.delayed(waitTime);
    }
  }
}
