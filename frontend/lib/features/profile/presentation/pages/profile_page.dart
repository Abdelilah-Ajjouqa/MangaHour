import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimens.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: dead_code, prefer_const_declarations
    const bool isLoggedIn = false;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('حسابي'),
        centerTitle: true,
      ),
      // ignore: dead_code
      body: isLoggedIn ? const AuthenticatedProfileView() : const UnauthenticatedProfileView(),
    );
  }
}

class UnauthenticatedProfileView extends StatelessWidget {
  const UnauthenticatedProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'أنت غير مسجل الدخول',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'قم بتسجيل الدخول لحفظ المانجا المفضلة لديك ومزامنة تقدمك عبر الأجهزة.',
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Auth login navigation placeholder
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: AppDimens.cardRadius),
                ),
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Auth register navigation placeholder
              },
              child: Text(
                'إنشاء حساب جديد',
                style: TextStyle(color: theme.primaryColor, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('الإعدادات العامة'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthenticatedProfileView extends StatelessWidget {
  const AuthenticatedProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      children: [
        const ProfileHeaderWidget(
          username: 'عبد الاله',
          email: 'abdelilah@example.com',
          avatarLetter: 'ع',
        ),
        const SizedBox(height: AppDimens.paddingLarge),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('الإعدادات العامة'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => context.push('/settings'),
          shape: RoundedRectangleBorder(borderRadius: AppDimens.cardRadius),
        ),
        const SizedBox(height: AppDimens.paddingMedium),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.logout, color: colorScheme.error),
            label: Text('تسجيل الخروج', style: TextStyle(color: colorScheme.error)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.error),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppDimens.cardRadius),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileHeaderWidget extends StatelessWidget {
  final String username;
  final String email;
  final String avatarLetter;

  const ProfileHeaderWidget({
    super.key,
    required this.username,
    required this.email,
    required this.avatarLetter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.primary,
            child: Text(
              avatarLetter,
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            username,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}
