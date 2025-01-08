import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/common/models/file_resource.dart';
import 'package:foldious/common/network_client/network_client.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  var isLoading = false.obs;

  ///
  final UserDetailsController userDetailsController = Get.find();
  final List<String> gendersList = ["Male", "Female", "Other"];
  RxString selectedGender = "Other".obs;

  ///
  ///
  ///
  XFile? pickedFile;
  FileResource fileResource = FileResource();

  ///
  ///
  ///
  Future<bool> getImage(ImageSource source) async {
    pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      await addFile();
      return true;
    }
    return false;
  }

  ///
  ///
  ///
  ///
  Future<void> addFile() async {
    isLoading.value = true;
    final result = await Get.find<NetworkClient>().upload<void>(
      ApiUrls.addDP,
      file: pickedFile!,
      sendUserAuth: true,
    );

    if (result.isSuccess) {
      try {
        var data = result.rawData as Map<String, dynamic>;
        fileResource = FileResource.fromJson(data);
        await updateDP(fileName: fileResource.fileName ?? "");
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        print('Error handling JSON data: $e');
        isLoading.value = false;
      }
    } else {
      print('File upload failed');
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  Future<void> updateDP({required String fileName}) async {
    isLoading.value = true;
    String userId = await AppPreferencesController()
        .getString(key: AppPreferenceLabels.userId);

    ///
    var payload = {"user_id": userId, "user_image": fileName};
    final result = await Get.find<NetworkClient>().post(
      ApiUrls.userImageUpdate,
      data: payload,
      sendUserAuth: true,
    );
    if (result.isSuccess) {
      await userDetailsController.getUserDetails();
      isLoading.value = false;
    } else {
      showErrorMessage(
        result.error ?? "Error",
      );
      isLoading.value = false;
    }
  }

  ///
  ///
  ///
  Future<void> profileUpdate({
    required String userName,
    required String userImage,
    required String userAddress,
    required String userContact,
    required String userGender,
    required String userAge,
  }) async {
    isLoading.value = true;
    String userId = await AppPreferencesController()
        .getString(key: AppPreferenceLabels.userId);

    ///
    var payload = {
      "user_id": userId,
      "user_name": userName,
      "user_image": userImage,
      "user_address": userAddress,
      "user_contact": userContact,
      "user_gender": userGender,
      "user_age": userAge,
    };
    final result = await Get.find<NetworkClient>().post(
      ApiUrls.profileUpdate,
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
