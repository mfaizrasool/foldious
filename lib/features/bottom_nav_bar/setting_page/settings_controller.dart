import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/features/authentication/login_screen/login_screen.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsController extends GetxController {
  var isLoading = false.obs;

  Future<void> logout() async {
    isLoading.value = true;
    GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    AppPreferencesController().deleteString(key: AppPreferenceLabels.userId);

    Get.offAll(() => LoginScreen());
    isLoading.value = false;
  }
}
