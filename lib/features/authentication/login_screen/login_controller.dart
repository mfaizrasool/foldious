import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/features/authentication/login_screen/login_model.dart';
import 'package:foldious/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  ///
  ///
  ///
  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  ///
  Future<void> validateAndCallLoginApi({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) {
      showErrorMessage(AppLabels.emptyEmail);
    } else if (!isValidEmail(email)) {
      showErrorMessage(AppLabels.emailFormat);
    }
    // else if (password.length < 6) {
    //   showErrorMessage(AppLabels.emptyPassword);
    // }
    else {
      await login(email: email, password: password, isSocial: 0);
    }
  }

  ///
  ///
  ///
  LoginModel loginModel = LoginModel();

  ///
  Future<void> login({
    required String email,
    String? password,
    required int isSocial,
  }) async {
    isLoading.value = true;
    var payload = {
      "email": email.toLowerCase(),
      "password": password,
      "social": isSocial,
    };

    final result = await Get.find<NetworkClient>().post(
      ApiUrls.login,
      data: payload,
      sendUserAuth: true,
    );

    if (result.isSuccess) {
      loginModel = LoginModel.fromJson(result.rawData);
      await AppPreferencesController().setString(
        key: AppPreferenceLabels.userId,
        value: loginModel.userId.toString(),
      );
      Get.to(() => BottomNavBarScreen());
      isLoading.value = false;
    } else {
      showErrorMessage(result.message ?? "Error");
      isLoading.value = false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                 googleSign                                 */
  /* -------------------------------------------------------------------------- */
  ///
  GoogleSignIn googleSignIn = GoogleSignIn();
  void googleSign() async {
    try {
      var googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        login(email: googleUser.email, isSocial: 1);
      } else {
        showErrorMessage("Please Select Google Account To Continue");
      }
    } catch (e) {
      print("error ${e.toString()}");
      showErrorMessage(e.toString());
    }
  }
}
