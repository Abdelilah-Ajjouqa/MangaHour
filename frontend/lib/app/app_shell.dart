import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/localization/app_localizations.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the router's location
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/search')) {
      currentIndex = 1;
    } else if (location.startsWith('/library')) {
      currentIndex = 2;
    } else if (location.startsWith('/profile')) {
      currentIndex = 3;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor, width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/search');
                break;
              case 2:
                context.go('/library');
                break;
              case 3:
                context.go('/profile');
                break;
            }
          },
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: AppLocalizations.of(context)!.homeTab),
            BottomNavigationBarItem(icon: const Icon(Icons.search_outlined), activeIcon: const Icon(Icons.search), label: AppLocalizations.of(context)!.searchTab),
            BottomNavigationBarItem(icon: const Icon(Icons.book_outlined), activeIcon: const Icon(Icons.book), label: AppLocalizations.of(context)!.libraryTab),
            BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: AppLocalizations.of(context)!.profileTab),
          ],
        ),
      ),
    );
  }
}
