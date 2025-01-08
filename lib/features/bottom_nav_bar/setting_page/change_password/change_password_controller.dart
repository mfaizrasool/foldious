import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;

  ///
  ///
  ///
  void validateAndCallChangePassword({
    required String oldPassword,
    required String confirmPassword,
    required String newPassword,
  }) async {
    if (oldPassword.isEmpty) {
      showErrorMessage("Please enter your current password.");
    } else if (newPassword.isEmpty) {
      showErrorMessage("Please enter a new password.");
    } else if (confirmPassword.isEmpty) {
      showErrorMessage("Please confirm your new password.");
    } else if (newPassword.length < 8) {
      showErrorMessage("The new password must be at least 8 characters long.");
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\W)')
        .hasMatch(newPassword)) {
      showErrorMessage(
          "The new password must include at least one lowercase letter, one uppercase letter, and one special character.");
    } else if (newPassword != confirmPassword) {
      showErrorMessage(
          "The new password and confirmation password do not match.");
    } else {
      // All validations passed
      await updatePassword(
        newPassword: newPassword,
      );
    }
  }

  ///
  ///
  ///

  Future<void> updatePassword({
    required String newPassword,
  }) async {
    isLoading.value = true;
    String userId = await AppPreferencesController()
        .getString(key: AppPreferenceLabels.userId);

    ///
    var payload = {
      "user_id": userId,
      "user_password": newPassword,
    };
    final result = await Get.find<NetworkClient>().post(
      ApiUrls.updatePassword,
      data: payload,
      sendUserAuth: true,
    );
    if (result.isSuccess) {
      showSuccessMessage(AppLabels.profileUpdate);
      Get.back();
      isLoading.value = false;
    } else {
      showErrorMessage(
        result.error ?? "Error",
      );
      isLoading.value = false;
    }
  }
}
