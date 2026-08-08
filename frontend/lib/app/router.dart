import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/explore/presentation/pages/explore_page.dart';
import '../features/library/presentation/pages/library_page.dart';
import '../core/entities/manga_entity.dart';
import '../features/manga_detail/presentation/pages/manga_detail_page.dart';
import '../core/widgets/manga_list_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/reader/presentation/pages/manga_reader_page.dart';

final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('الصفحة غير موجودة')),
    body: Center(
      child: Text('الرابط المطلوبة غير موجودة: ${state.uri}'),
    ),
  ),
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const ExplorePage(),
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) => const LibraryPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/manga/:id',
      builder: (context, state) {
        final manga = state.extra as MangaEntity;
        return MangaDetailPage(manga: manga);
      },
    ),
    GoRoute(
      path: '/list',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final String title = extra['title'] as String;
        final List<MangaEntity> items = extra['items'] as List<MangaEntity>;
        return MangaListPage(title: title, mangaList: items);
      },
    ),
    GoRoute(
      path: '/reader/:chapterId',
      builder: (context, state) {
        final String chapterId = state.pathParameters['chapterId']!;
        return MangaReaderPage(chapterId: chapterId);
      },
    ),
  ],
);
