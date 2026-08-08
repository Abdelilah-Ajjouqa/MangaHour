import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock authentication state. In the future, this will come from an AuthBloc.
    // ignore: prefer_const_declarations
    bool isLoggedIn = false;

    // ignore: dead_code
    return isLoggedIn ? _buildAuthenticatedView(context) : _buildUnauthenticatedView(context);
  }

  Widget _buildUnauthenticatedView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('حسابي'), // My Account
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(height: 24),
              Text(
                'أنت غير مسجل الدخول', // You are not logged in
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'قم بتسجيل الدخول لحفظ المانجا المفضلة لديك ومزامنة تقدمك عبر الأجهزة.',
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Login Page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to Register Page
                },
                child: Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(color: theme.primaryColor, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView(BuildContext context) {
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
                  backgroundColor: Colors.blueAccent,
                  child: Text('ع', style: TextStyle(fontSize: 40, color: Colors.white)), // 'A' in Arabic
                ),
                const SizedBox(height: 16),
                Text(
                  'عبد الاله', // Username
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'abdelilah@example.com',
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // General Settings Group
          _buildSectionHeader('إعدادات عامة', theme),
          _buildListTile(
            icon: Icons.language,
            title: 'اللغة',
            trailing: const Text('العربية'),
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.dark_mode,
            title: 'المظهر',
            trailing: const Text('داكن'),
            theme: theme,
          ),
          
          const SizedBox(height: 24),
          
          // Data Settings Group
          _buildSectionHeader('البيانات والتخزين', theme),
          _buildListTile(
            icon: Icons.cleaning_services,
            title: 'مسح ذاكرة التخزين المؤقت',
            theme: theme,
            isDestructive: true,
          ),
          _buildListTile(
            icon: Icons.delete_sweep,
            title: 'حذف جميع التنزيلات',
            theme: theme,
            isDestructive: true,
          ),
          
          const SizedBox(height: 24),
          
          // About Group
          _buildSectionHeader('حول التطبيق', theme),
          _buildListTile(
            icon: Icons.info_outline,
            title: 'إصدار التطبيق',
            trailing: const Text('v1.0.0'),
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.discord,
            title: 'مجتمع ديسكورد',
            theme: theme,
          ),
          
          const SizedBox(height: 24),
          
          // Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
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
