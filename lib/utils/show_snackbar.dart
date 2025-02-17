import 'package:flutter/material.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

///
///
///
void showSuccessMessage(
  String message, {
  ScaffoldMessengerState? messengerState,
}) {
  final s = messengerState ?? ScaffoldMessenger.of(Get.context!);
  s.showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 500),
      content: Text(
        message,
        style: GoogleFonts.nunitoSans(
            textStyle: AppTextStyle.bodySmall.copyWith(color: AppColors.white)),
      ),
      backgroundColor: AppColors.primaryColor,
      dismissDirection: DismissDirection.down,
    ),
  );
}

///
///
///
void showErrorMessage(
  String message, {
  ScaffoldMessengerState? messengerState,
}) {
  final s = messengerState ?? ScaffoldMessenger.of(Get.context!);
  s.showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 500),
      content: Text(
        message,
        style: GoogleFonts.nunitoSans(
            textStyle: AppTextStyle.bodySmall.copyWith(color: AppColors.white)),
      ),
      backgroundColor: AppColors.negativeColor,
      dismissDirection: DismissDirection.down,
    ),
  );
}
