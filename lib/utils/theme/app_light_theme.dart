import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/utils/theme/extension/theme_extension.dart';

final lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  cardColor: const Color(0xfff5f6f8),
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: AppColors.primaryColor,
        surface: AppLightThemeColors.appBackgroundColor,
        secondaryContainer: AppLightThemeColors.lightGreyColor,
        primaryContainer: AppColors.greyColor,
      ),
  dividerColor: const Color(0xFFEBEDF1),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppLightThemeColors.bottomSheetColor,
  ),
  listTileTheme: ListTileThemeData(
    textColor: AppLightThemeColors.primaryTextColor,
    titleTextStyle: AppTextStyle.bodyMedium,
  ),
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppLightThemeColors.appBackgroundColor,
  textTheme: TextTheme(
    bodyLarge: AppTextStyle.bodyLarge.copyWith(
      fontSize: 16.0,
      color: AppLightThemeColors.primaryTextColor,
    ),
    bodyMedium: AppTextStyle.bodyMedium.copyWith(
      color: AppLightThemeColors.primaryTextColor,
    ),
    bodySmall: AppTextStyle.bodySmall.copyWith(
      color: AppColors.greyColor,
      fontSize: 14.0,
    ),
    titleLarge: AppTextStyle.titleLarge.copyWith(
      color: AppLightThemeColors.primaryTextColor,
    ),
    titleMedium: AppTextStyle.titleMedium.copyWith(
      color: AppLightThemeColors.primaryTextColor,
    ),
    titleSmall: AppTextStyle.titleSmall.copyWith(
      fontWeight: FontWeight.bold,
      color: AppLightThemeColors.primaryTextColor,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppLightThemeColors.appBackgroundColor,
    elevation: 0,
    titleTextStyle: AppTextStyle.bodyMedium.copyWith(
      fontSize: 16,
      color: AppLightThemeColors.primaryTextColor,
    ),
    iconTheme: const IconThemeData(
      color: AppLightThemeColors.iconColor,
    ),
  ),
  canvasColor: AppLightThemeColors.bottomSheetColor,
  iconTheme: const IconThemeData(
    color: AppLightThemeColors.iconColor,
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: AppTextStyle.bodyMedium.copyWith(
      fontWeight: FontWeight.w600,
      color: AppLightThemeColors.primaryTextColor,
    ),
    indicatorColor: AppLightThemeColors.primaryTextColor,
    unselectedLabelColor: AppLightThemeColors.primaryTextColor,
    labelColor: AppLightThemeColors.primaryTextColor,
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
    indicator: const BoxDecoration(
      color: AppLightThemeColors.appBackgroundColor,
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: AppLightThemeColors.primaryTextColor,
        ),
      ),
    ),
  ),
  cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
    brightness: Brightness.light,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: AppTextStyle.bodyMedium.copyWith(
      color: AppLightThemeColors.primaryTextColor,
    ),
    hintStyle: const TextStyle(
      color: AppColors.greyColor,
    ),
    contentPadding: const EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        // color: AppLightThemeColors.lightGreyColor,
        color: AppColors.primaryColor.withValues(alpha: 0.3),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppLightThemeColors.lightGreyColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.primaryColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.primaryColor,
  ),
  extensions: [
    const CustomThemeExtension(
      positiveColor: AppColors.positiveColor,
    ),
  ],
);
