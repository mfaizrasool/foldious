import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isLoading = false.obs;
  var selectedTheme = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedTheme();
  }

  ///
  /// Loads the saved theme from preferences
  ///
  Future<void> _loadSavedTheme() async {
    isLoading.value = true;
    String savedTheme = "ThemeMode.system";
    savedTheme = await AppPreferencesController().getString(
      key: AppPreferenceLabels.userTheme,
    );

    selectedTheme.value = ThemeMode.values.firstWhere(
      (e) => e.toString() == savedTheme,
      orElse: () => ThemeMode.system,
    );

    isLoading.value = false;
  }

  ///
  /// Sets the new theme mode and saves it in preferences
  ///
  void setTheme(ThemeMode mode) async {
    selectedTheme.value = mode;
    if (kDebugMode) {
      print('Selected theme mode: ${mode.toString()}');
    }

    await AppPreferencesController().setString(
      key: AppPreferenceLabels.userTheme,
      value: mode.toString(),
    );

    Get.changeThemeMode(mode);
    update();
  }
}
