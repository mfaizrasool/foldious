import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';

import '../theme/extension/theme_extension.dart';

final darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  cardColor: AppDarkThemeColors.bottomSheetColor,
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: AppColors.primaryColor,
        surface: AppDarkThemeColors.appBackgroundColor,
        secondaryContainer: AppDarkThemeColors.lightGreyColor,
        primaryContainer: AppColors.greyColor,
      ),
  dividerColor: const Color(0x7feeeff1),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppDarkThemeColors.bottomSheetColor,
  ),
  listTileTheme: ListTileThemeData(
    textColor: AppDarkThemeColors.primaryTextColor,
    titleTextStyle: AppTextStyle.bodyMedium,
  ),
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppDarkThemeColors.appBackgroundColor,
  textTheme: TextTheme(
    bodyLarge: AppTextStyle.bodyLarge.copyWith(
      fontSize: 16.0,
      color: AppDarkThemeColors.primaryTextColor,
    ),
    bodyMedium: AppTextStyle.bodyMedium.copyWith(
      color: AppDarkThemeColors.primaryTextColor,
    ),
    bodySmall: AppTextStyle.bodySmall.copyWith(
      color: AppColors.greyColor,
      fontSize: 14.0,
    ),
    titleLarge: AppTextStyle.titleLarge.copyWith(
      color: AppDarkThemeColors.primaryTextColor,
    ),
    titleMedium: AppTextStyle.titleMedium.copyWith(
      color: AppDarkThemeColors.primaryTextColor,
    ),
    titleSmall: AppTextStyle.titleSmall.copyWith(
      fontWeight: FontWeight.bold,
      color: AppDarkThemeColors.primaryTextColor,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppDarkThemeColors.appBackgroundColor,
    elevation: 0,
    titleTextStyle: AppTextStyle.bodyMedium.copyWith(
      fontSize: 16,
      color: AppDarkThemeColors.primaryTextColor,
    ),
    iconTheme: const IconThemeData(
      color: AppDarkThemeColors.iconColor,
    ),
  ),
  cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
    brightness: Brightness.dark,
  ),
  canvasColor: AppDarkThemeColors.bottomSheetColor,
  iconTheme: const IconThemeData(
    color: AppDarkThemeColors.iconColor,
  ),
  tabBarTheme: TabBarThemeData(
    labelStyle: AppTextStyle.bodyMedium.copyWith(
      fontWeight: FontWeight.w600,
      color: AppDarkThemeColors.primaryTextColor,
    ),
    indicatorColor: AppDarkThemeColors.primaryTextColor,
    unselectedLabelColor: AppDarkThemeColors.primaryTextColor,
    labelColor: AppDarkThemeColors.primaryTextColor,
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
    indicator: const BoxDecoration(
      color: AppDarkThemeColors.appBackgroundColor,
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: AppDarkThemeColors.primaryTextColor,
        ),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: AppTextStyle.bodyMedium.copyWith(
      color: AppDarkThemeColors.primaryTextColor,
    ),
    hintStyle: const TextStyle(
      color: AppColors.greyColor,
    ),
    contentPadding: const EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        // color: AppDarkThemeColors.lightGreyColor,
        color: AppColors.primaryColor.withValues(alpha: 0.3),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppDarkThemeColors.lightGreyColor,
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
