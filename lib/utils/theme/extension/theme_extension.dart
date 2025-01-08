import 'package:flutter/material.dart';

///
///
///
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color? positiveColor;

  const CustomThemeExtension({
    this.positiveColor,
  });

  @override
  CustomThemeExtension copyWith({Color? brandColor, Color? danger}) {
    return CustomThemeExtension(
      positiveColor: positiveColor,
    );
  }

  @override
  CustomThemeExtension lerp(CustomThemeExtension? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      positiveColor: Color.lerp(positiveColor, other.positiveColor, t),
    );
  }
}
