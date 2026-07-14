import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';
import '../features/home/presentation/pages/home_page.dart';

import '../features/library/presentation/pages/library_page.dart';

// Placeholder Pages for future phases
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.black, centerTitle: true),
      body: const Center(child: Text('قريباً...', style: TextStyle(color: Colors.white70, fontSize: 20))), // "Coming Soon"
    );
  }
}

final router = GoRouter(
  initialLocation: '/',
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
          builder: (context, state) => const PlaceholderPage(title: 'البحث'),
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) => const LibraryPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const PlaceholderPage(title: 'حسابي'),
        ),
      ],
    ),
  ],
);
