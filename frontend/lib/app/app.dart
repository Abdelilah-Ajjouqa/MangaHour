import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We will hook this up to a SettingsBloc later.
    // For now, we default to Arabic RTL mode.
    const isArabic = true; 
    
    return MaterialApp.router(
      title: 'MangaHour',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.getDarkTheme(context, isArabic: isArabic),
      themeMode: ThemeMode.dark,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale(isArabic ? 'ar' : 'en'),

      // Routing
      routerConfig: router,
    );
  }
}
