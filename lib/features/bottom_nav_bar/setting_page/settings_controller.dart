import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/features/authentication/login_screen/login_screen.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/date_formatter.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsController extends GetxController {
  var isLoading = false.obs;

  Future<void> logout() async {
    isLoading.value = true;
    GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.signOut();

    AppPreferencesController().deleteString(key: AppPreferenceLabels.userId);

    Get.offAll(() => LoginScreen());
    isLoading.value = false;
  }

  Future<void> deleteUser() async {
    isLoading.value = true;
    var userId = await AppPreferencesController()
        .getString(key: AppPreferenceLabels.userId);

    var payload = {
      "user_id": userId,
      "delete_date": yearMonthDayFormat.format(DateTime.now()),
    };

    final result = await Get.find<NetworkClient>().post(
      ApiUrls.deleteUser,
      data: payload,
      sendUserAuth: true,
    );

    if (result.isSuccess) {
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
}
