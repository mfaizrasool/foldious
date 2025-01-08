import 'package:flutter/material.dart';

class AppColors {
  static const white = Colors.white;
  static const black = Colors.black;
  static const transparent = Colors.transparent;
  static const primaryColor = Color(0xFF00695c);
  static const greyColor = Color(0xFF9CA5B0);
  static const gradientDownColor = Color(0xFFC8D6DF);

  static const blue = Colors.blue;
  static const red = Colors.red;
  static const green = Colors.green;
  static const orange = Colors.orange;

  ///
  static const Color positiveColor = Color(0xFF8CC73F);
  static const Color negativeColor = Color(0xFFFF6961);
}

///
///
///
class AppLightThemeColors {
  static const Color appBackgroundColor = Color(0xFFFFFFFF);

  static const Color secondaryButtonColor = Color(0xFFEEEFF1);

  static const Color primaryTextColor = Color(0xFF000229);

  static const Color primaryButtonTextColor = Color(0xFFFFFFFF);

  static const Color secondaryButtonTextColor = AppColors.primaryColor;

  static const Color lightGreyColor = Color(0xFFEEEFF1);

  static const Color bottomSheetColor = Color(0xFFFFFFFF);

  static const Color iconColor = primaryTextColor;
}

///
///
///
class AppDarkThemeColors {
  static const Color appBackgroundColor = Color(0xFF222D32);

  static const Color secondaryButtonColor = Color(0xFFEEEFF1);

  static const Color primaryTextColor = Color(0xFFFFFFFF);

  static const Color primaryButtonTextColor = Color(0xFFFFFFFF);

  static const Color secondaryButtonTextColor = AppColors.primaryColor;

  static const Color lightGreyColor = Color(0xFF454545);

  static const Color bottomSheetColor = Color(0xFF393939);

  static const Color iconColor = primaryTextColor;
}
