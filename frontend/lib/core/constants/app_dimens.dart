import 'package:flutter/material.dart';

abstract class AppDimens {
  // Border Radius
  static const double cardBorderRadius = 12.0;
  static const double chipBorderRadius = 8.0;
  static const double buttonBorderRadius = 10.0;

  static final BorderRadius cardRadius = BorderRadius.circular(cardBorderRadius);
  static final BorderRadius chipRadius = BorderRadius.circular(chipBorderRadius);
  static final BorderRadius buttonRadius = BorderRadius.circular(buttonBorderRadius);

  // Spacing & Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Grid
  static const int gridCrossAxisCount = 3;
  static const double gridChildAspectRatio = 0.65;
  static const double gridCrossAxisSpacing = 12.0;
  static const double gridMainAxisSpacing = 16.0;
}
