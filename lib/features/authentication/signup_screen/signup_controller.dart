import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  ///
  ///
  ///

  void validateAndCallSignUpApi({
    required String userName,
    required String email,
  }) async {
    if (userName.isEmpty) {
      showErrorMessage(AppLabels.emptyUserName);
    } else if (email.isEmpty) {
      showErrorMessage(AppLabels.emptyEmail);
    } else if (!isValidEmail(email)) {
      showErrorMessage(AppLabels.emailFormat);
    } else if (email.endsWith("mailinator.com")) {
      showErrorMessage("Temporary email addresses are not allowed");
    } else {
      await signUp(userName: userName, email: email);
    }
  }

  ///
  Future<void> signUp({
    required String userName,
    required String email,
  }) async {
    isLoading.value = true;

    final response = await Get.find<NetworkClient>().post(
      ApiUrls.register,
      data: {
        "username": userName,
        "email": email.toLowerCase(),
      },
      sendUserAuth: true,
    );

    if (response.isSuccess) {
      isLoading.value = false;
      showSuccessMessage(response.rawData['message']);
      Get.back();
    } else {
      isLoading.value = false;
      showErrorMessage(response.error ?? "Error occurred during sign up");
    }
  }
}
