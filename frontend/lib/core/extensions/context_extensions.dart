import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
