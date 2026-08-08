import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('حسابي'), // My Account
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Header
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'مستخدم ضيف', // Guest User
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'سجل الدخول لحفظ تقدمك', // Log in to save progress
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('تسجيل الدخول'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // General Settings Group
          _buildSectionHeader('إعدادات عامة', theme),
          _buildListTile(
            icon: Icons.language,
            title: 'اللغة', // Language
            trailing: const Text('العربية'),
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.dark_mode,
            title: 'المظهر', // Theme
            trailing: const Text('داكن'), // Dark
            theme: theme,
          ),
          
          const SizedBox(height: 24),
          
          // Data Settings Group
          _buildSectionHeader('البيانات والتخزين', theme),
          _buildListTile(
            icon: Icons.cleaning_services,
            title: 'مسح ذاكرة التخزين المؤقت', // Clear Cache
            theme: theme,
            isDestructive: true,
          ),
          _buildListTile(
            icon: Icons.delete_sweep,
            title: 'حذف جميع التنزيلات', // Delete all downloads
            theme: theme,
            isDestructive: true,
          ),
          
          const SizedBox(height: 24),
          
          // About Group
          _buildSectionHeader('حول التطبيق', theme),
          _buildListTile(
            icon: Icons.info_outline,
            title: 'إصدار التطبيق', // App Version
            trailing: const Text('v1.0.0'),
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.discord,
            title: 'مجتمع ديسكورد', // Discord Community
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0), // RTL layout
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required ThemeData theme,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? theme.colorScheme.error : theme.colorScheme.onSurface),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? theme.colorScheme.error : theme.colorScheme.onSurface),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
