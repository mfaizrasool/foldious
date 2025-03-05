import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/my_earning_model.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';

class MyEarningController extends GetxController {
  var isLoading = true.obs;

  @override
  void onInit() {
    getMyEarning();
    super.onInit();
  }

  MyEarningModel myEarning = MyEarningModel();
  Future<void> getMyEarning() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 0));
      String userId = await AppPreferencesController()
          .getString(key: AppPreferenceLabels.userId);
      final result = await Get.find<NetworkClient>().get(
        ApiUrls.referalListView,
        queryParameters: {'user_id': userId},
        sendUserAuth: true,
      );

      if (result.isSuccess) {
        myEarning = MyEarningModel.fromJson(result.rawData);
      } else {
        showErrorMessage(result.error ?? 'An error occurred');
      }
    } catch (e) {
      showErrorMessage('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
