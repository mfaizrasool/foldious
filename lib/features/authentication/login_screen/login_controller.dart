import 'package:firebase_auth/firebase_auth.dart';
import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/features/authentication/login_screen/auth_service.dart';
import 'package:foldious/features/authentication/login_screen/login_model.dart';
import 'package:foldious/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/date_formatter.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/widgets/deleted_account_dialog.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final UserDetailsController userDetailsController = Get.find();

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
    String deviceToken = await getToken();
    var payload = {
      "email": email.toLowerCase(),
      "password": password,
      "social": isSocial,
      "device_token": deviceToken,
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

      await userDetailsController.getUserDetails();

      if (userDetailsController.userDetails.deletedAt != null &&
          userDetailsController.userDetails.deletedAt!.isNotEmpty) {
        ///
        deletedAccountDialog();

        ///
      } else {
        Get.off(() => BottomNavBarScreen());
      }

      ///
      ///
      ///

      ///
      ///
      ///

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
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  void googleSign() async {
    try {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        final GoogleSignInAccount? user =
            await GoogleSignIn.instance.authenticate();
        if (user != null) {
          login(email: user.email, isSocial: 1);
        } else {
          showErrorMessage("Please Select Google Account To Continue");
        }
      } else {
        showErrorMessage("Google Sign-In not supported on this platform.");
      }
    } catch (e) {
      print("error \\${e.toString()}");
      showErrorMessage(e.toString());
    }
  }

  ///
  ///
  ///
  Future<void> appleSignIn() async {
    UserCredential? userCredential;
    isLoading.value = true;
    try {
      userCredential = await AuthRepo().signInWithApple();
      isLoading.value = false;
    } on FirebaseAuthException catch (exception) {
      isLoading.value = false;

      print('FirebaseAuthException: ${exception.message}');
      return;
    } catch (error) {
      isLoading.value = false;
      showErrorMessage("Error login with Apple.");
      print('Error in Apple Sign-In: $error');
      return;
    }
    if (userCredential != null) {
      await login(email: userCredential.user!.email!, isSocial: 1);
    } else {
      print("Sign-in failed, but no exception was thrown.");
    }
  }
}
