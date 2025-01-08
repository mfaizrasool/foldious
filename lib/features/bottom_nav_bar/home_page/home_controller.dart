import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/chart_data.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  final UserDetailsController userDetailsController = Get.find();
  RxList<double> folderSpace = [0.0, 0.0, 0.0, 0.0].obs;
  RxList<ChartData> chartData = <ChartData>[].obs;

  List<String> folderNames = [
    AppLabels.images,
    AppLabels.videos,
    AppLabels.documents,
    AppLabels.others,
    
  ];

  List<Color> folderColors = [
    AppColors.blue,
    AppColors.red,
    AppColors.green,
    AppColors.orange,
  ];

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    isLoading.value = true;
    try {
      await userDetailsController.getUserDetails();
      setData();
    } catch (e) {
      print("Error fetching user details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  double parseStorageSize(String? size) {
    if (size == null) return 0.0;
    try {
      return double.parse(size.split(" ").first);
    } catch (e) {
      print("Error parsing size '$size': $e");
      return 0.0;
    }
  }

  void setData() {
    folderSpace[0] =
        parseStorageSize(userDetailsController.storageDetails.totalImagesSize);
    folderSpace[1] =
        parseStorageSize(userDetailsController.storageDetails.totalVideoSize);
    folderSpace[2] =
        parseStorageSize(userDetailsController.storageDetails.totalTextSize);
    folderSpace[3] = parseStorageSize(
        userDetailsController.storageDetails.totalApplicationSize);

    // Generate chart data
    chartData.value = List.generate(folderNames.length, (index) {
      return ChartData(
        folderNames[index],
        folderSpace[index],
        folderColors[index],
      );
    });
  }
}
