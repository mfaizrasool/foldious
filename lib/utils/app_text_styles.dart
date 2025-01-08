import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  ///

  static TextStyle titleSmall = GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  ///
  static TextStyle titleMedium = GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  ///
  static TextStyle titleLarge = GoogleFonts.nunitoSans(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  ///
  ///
  ///

  static TextStyle bodySmall = GoogleFonts.nunitoSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  ///
  static TextStyle bodyMedium = GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  ///
  static TextStyle bodyLarge = GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  ///
  static TextStyle headlineSmall = GoogleFonts.nunitoSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  ///
  static TextStyle headlineMedium = GoogleFonts.nunitoSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  ///
  static BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withValues(alpha: 0.1),
    spreadRadius: 10,
    blurRadius: 10,
    offset: const Offset(0, 3),
  );
}
