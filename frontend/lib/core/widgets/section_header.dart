import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final String? viewAllText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.viewAllText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title, 
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                viewAllText ?? AppLocalizations.of(context)!.viewAll, 
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
