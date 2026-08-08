class MockData {
  static const String _sampleImageUrl1 = 'https://cdn.myanimelist.net/images/manga/3/216464l.jpg'; // Spy x Family
  static const String _sampleImageUrl2 = 'https://cdn.myanimelist.net/images/manga/3/213225l.jpg'; // Jujutsu Kaisen
  static const String _sampleImageUrl3 = 'https://cdn.myanimelist.net/images/manga/1/157897l.jpg'; // Berserk
  static const String _sampleImageUrl4 = 'https://cdn.myanimelist.net/images/manga/3/245842l.jpg'; // Dandadan
  static const String _sampleImageUrl5 = 'https://cdn.myanimelist.net/images/manga/3/222295l.jpg'; // Solo Leveling

  static final List<Map<String, dynamic>> popularMangaList = [
    _createMockManga(1, 'Spy x Family', 'سباي اكس فاميلي', _sampleImageUrl1, 8.7, 1),
    _createMockManga(2, 'Jujutsu Kaisen', 'جوجوتسو كايسين', _sampleImageUrl2, 8.5, 2),
    _createMockManga(3, 'Berserk', 'بيرسيرك', _sampleImageUrl3, 9.4, 3),
    _createMockManga(4, 'Dandadan', 'دان دادان', _sampleImageUrl4, 8.4, 4),
    _createMockManga(5, 'Solo Leveling', 'سولو ليفلينج', _sampleImageUrl5, 8.8, 5),
  ];

  static final List<Map<String, dynamic>> trendingMangaList = [
    _createMockManga(5, 'Solo Leveling', 'سولو ليفلينج', _sampleImageUrl5, 8.8, 1),
    _createMockManga(4, 'Dandadan', 'دان دادان', _sampleImageUrl4, 8.4, 2),
    _createMockManga(1, 'Spy x Family', 'سباي اكس فاميلي', _sampleImageUrl1, 8.7, 3),
  ];

  static final Map<String, dynamic> mangaDetail = _createMockMangaDetail(
    1, 
    'Spy x Family', 
    'سباي اكس فاميلي', 
    _sampleImageUrl1, 
    8.7, 
    'تتبع القصة جاسوساً يضطر لبناء أسرة مزيفة لتنفيذ مهمته، دون أن يدرك أن الفتاة التي تبناها قادرة على قراءة الأفكار، والمرأة التي تزوجها هي قاتلة محترفة. معا، يجب عليهم إخفاء هوياتهم الحقيقية والعيش كعائلة عادية في الظاهر.',
    'Tatsuya Endo'
  );

  static Map<String, dynamic> _createMockManga(int id, String title, String arabicTitle, String imageUrl, double score, int rank) {
    return {
      'mal_id': id,
      'title': title,
      'title_english': title,
      'images': {
        'jpg': {
          'image_url': imageUrl,
          'large_image_url': imageUrl,
        },
        'webp': {
          'image_url': imageUrl,
          'large_image_url': imageUrl,
        }
      },
      'score': score,
      'rank': rank,
      'chapters': 100,
      'publishing': true,
      'titles': [
        {'type': 'Arabic', 'title': arabicTitle}
      ]
    };
  }

  static Map<String, dynamic> _createMockMangaDetail(int id, String title, String arabicTitle, String imageUrl, double score, String synopsis, String author) {
    return {
      'mal_id': id,
      'title': title,
      'title_english': title,
      'images': {
        'jpg': {
          'image_url': imageUrl,
          'large_image_url': imageUrl,
        },
        'webp': {
          'image_url': imageUrl,
          'large_image_url': imageUrl,
        }
      },
      'score': score,
      'chapters': 100,
      'publishing': true,
      'titles': [
        {'type': 'Arabic', 'title': arabicTitle}
      ],
      'synopsis': synopsis,
      'status': 'Publishing',
      'authors': [
        {'mal_id': 1, 'name': author, 'type': 'People', 'url': ''}
      ]
    };
  }
}
