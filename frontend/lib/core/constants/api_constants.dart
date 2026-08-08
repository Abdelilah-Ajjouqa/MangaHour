abstract class ApiConstants {
  static const String jikanBaseUrl = 'https://api.jikan.moe/v4';
  static const String mangadexBaseUrl = 'https://api.mangadex.org';
  
  static const int defaultPageSize = 10;
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
