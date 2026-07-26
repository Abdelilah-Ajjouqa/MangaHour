import '../models/shared_dtos.dart';

class ArabicTitleExtractor {
  static String? extract(List<TitleDto>? titles) {
    if (titles != null) {
      for (final t in titles) {
        if (t.type != null && t.type!.toLowerCase() == 'arabic') {
          return t.title;
        }
      }
    }
    return null;
  }
}
