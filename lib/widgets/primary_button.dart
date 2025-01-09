import 'package:flutter/material.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';

class PrimaryButton extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String title;
  final VoidCallback onPressed;
  final bool enabled;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? height;
  final double? width;

  const PrimaryButton({
    super.key,
    this.margin,
    this.padding,
    required this.title,
    required this.onPressed,
    this.enabled = true,
    this.backgroundColor,
    this.titleColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Container(
      margin: margin,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: enabled
            ? backgroundColor ?? appTheme.primaryColor
            : appTheme.colorScheme.primaryContainer,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: width ?? 220,
            height: height ?? 48,
            alignment: Alignment.center,
            padding: padding,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium.copyWith(
                color: titleColor ?? AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
