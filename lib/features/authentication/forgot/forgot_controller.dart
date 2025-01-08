import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/features/authentication/forgot/forgot_model.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  var isLoading = false.obs;

  ///
  ///
  ///
  ForgotModel forgotModel = ForgotModel();

  ///
  Future<void> forgot({required String email}) async {
    isLoading.value = true;
    var payload = {"email": email.toLowerCase()};

    final result = await Get.find<NetworkClient>().post(
      ApiUrls.forgetPassword,
      data: payload,
      sendUserAuth: true,
    );

    if (result.isSuccess) {
      forgotModel = ForgotModel.fromJson(result.rawData);
      showSuccessMessage(forgotModel.messaage ?? "");
      Get.back();
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
}
