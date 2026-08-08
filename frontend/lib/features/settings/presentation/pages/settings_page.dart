import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimens.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _themeMode = ThemeMode.system;
  String _selectedLanguage = 'ar';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('الإعدادات'), // Settings
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        children: [
          // Section: Appearance
          _buildSectionHeader('المظهر واللغة', theme),
          Card(
            shape: RoundedRectangleBorder(borderRadius: AppDimens.cardRadius),
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('المظهر'),
                  trailing: DropdownButton<ThemeMode>(
                    value: _themeMode,
                    underline: const SizedBox.shrink(),
                    onChanged: (newMode) {
                      if (newMode != null) {
                        setState(() {
                          _themeMode = newMode;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('الافتراضي'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('داكن'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('فاتح'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('اللغة'),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    underline: const SizedBox.shrink(),
                    onChanged: (newLang) {
                      if (newLang != null) {
                        setState(() {
                          _selectedLanguage = newLang;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'ar',
                        child: Text('العربية'),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.paddingLarge),

          // Section: Storage & Cache
          _buildSectionHeader('التخزين والذاكرة', theme),
          Card(
            shape: RoundedRectangleBorder(borderRadius: AppDimens.cardRadius),
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.cleaning_services_outlined, color: colorScheme.error),
                  title: Text('مسح ذاكرة التخزين المؤقت', style: TextStyle(color: colorScheme.error)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم مسح ذاكرة التخزين المؤقت بنجاح')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.paddingLarge),

          // Section: About
          _buildSectionHeader('حول التطبيق', theme),
          Card(
            shape: RoundedRectangleBorder(borderRadius: AppDimens.cardRadius),
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('مانجا ساعة — MangaHour'),
                  subtitle: Text('قارئ مانجا مجاني ومفتوح المصدر'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.numbers_outlined),
                  title: Text('الإصدار'),
                  trailing: Text('v1.0.0 (MVP)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingSmall, right: AppDimens.paddingSmall),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
