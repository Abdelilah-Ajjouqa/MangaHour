import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme getTextTheme(BuildContext context, bool isArabic) {
    if (isArabic) {
      return GoogleFonts.cairoTextTheme(Theme.of(context).textTheme);
    } else {
      return GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    }
  }
}
