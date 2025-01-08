import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/models/user_details_model.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';

class UserDetailsController extends GetxController {
  var isLoading = false.obs;

  ///
  ///
  UserDetailsModel userDetailsModel = UserDetailsModel();

  ///
  UserDetails userDetails = UserDetails();
  PackageDetails packageDetails = PackageDetails();
  FolderDetails folderDetails = FolderDetails();
  StorageDetails storageDetails = StorageDetails();
  TransactionDetails transactionDetails = TransactionDetails();

  ///
  ///
  ///
  ///

  double calculateProgress() {
    final used = double.tryParse(storageDetails.storageUsed ?? "0") ?? 0;
    final total = double.tryParse(storageDetails.totalStorage ?? "1") ?? 1;
    return total > 0 ? used / total : 0;
  }

  ///
  Future<void> getUserDetails() async {
    isLoading.value = false;
    Future.delayed(const Duration(seconds: 0), () {
      isLoading.value = true;
    });

    ///
    ///
    ///
    String userId = await AppPreferencesController()
        .getString(key: AppPreferenceLabels.userId);

    ///
    ///
    ///
    final result = await Get.find<NetworkClient>().get(
      ApiUrls.userDetails,
      queryParameters: {'user_id': userId},
      sendUserAuth: true,
    );
    if (result.isSuccess) {
      userDetailsModel = UserDetailsModel.fromJson(result.rawData);
      userDetails = userDetailsModel.user!.userDetails!;
      packageDetails = userDetailsModel.user!.packageDetails!;
      folderDetails = userDetailsModel.user!.folderDetails!;
      storageDetails = userDetailsModel.user!.storageDetails!;
      transactionDetails = userDetailsModel.user!.transactionDetails!;
      isLoading.value = false;
    } else {
      showErrorMessage(result.error ?? 'An error occurred');
      isLoading.value = false;
    }
  }
}
