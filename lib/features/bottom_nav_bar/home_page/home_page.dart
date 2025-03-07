import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/chart_data.dart';
import 'package:foldious/features/bottom_nav_bar/home_page/file_types/file_types.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/add_referral_dialog.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/my_earning_controller.dart';
import 'package:foldious/utils/app_assets.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/date_formatter.dart';
import 'package:foldious/utils/file_types.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/loading_image.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:foldious/widgets/primary_linear_progress.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  final UserDetailsController userDetailsController = Get.find();
  final MyEarningController myEarningController =
      Get.put(MyEarningController());

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.sizeOf(context);
    var height = screenSize.height;
    var width = screenSize.width;

    return Obx(() {
      return Scaffold(
        appBar: PrimaryAppBar(
          title: userDetailsController.userDetails.userName ?? "",
          showBackArrowIcon: false,
          actions: [
            IconButton(
              onPressed: () async {
                if (userDetailsController.userDetails.userReferalId == "0") {
                  await Get.to(() => AddReferalDialog());
                  await userDetailsController.getUserDetails();
                } else {
                  showErrorMessage("You have already redeemed referal code");
                }
              },
              icon: LoadingImage(
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/512/6213/6213799.png",
              ),
            )
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: controller.isLoading.value ||
                  userDetailsController.isLoading.value
              ? const LoadingIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.02),

                      /// Doughnut Chart
                      if (controller.chartData.isNotEmpty)
                        SizedBox(
                          width: width,
                          height: height * 0.26,
                          child: SfCircularChart(
                            series: <CircularSeries>[
                              DoughnutSeries<ChartData, String>(
                                dataSource: controller.chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) {
                                  final remainingStorage = controller
                                      .parseStorageSize(userDetailsController
                                          .storageDetails.remainingStorage);
                                  return data.y / remainingStorage;
                                },
                                pointColorMapper: (ChartData data, _) =>
                                    data.color,
                                dataLabelMapper: (ChartData data, _) =>
                                    "${data.x}\n${formatFileSize(size: data.y.toString())}",
                                radius: '80%',
                                innerRadius: '70%',
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.outside,
                                  textStyle: AppTextStyle.bodySmall
                                      .copyWith(fontSize: height * 0.01),
                                  connectorLineSettings:
                                      const ConnectorLineSettings(
                                    type: ConnectorType.curve,
                                  ),
                                ),
                                cornerStyle: CornerStyle.bothFlat,
                              )
                            ],
                          ),
                        ),

                      /// Progress Bar
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: PrimaryLinearProgress(
                          progress: userDetailsController.calculateProgress(),
                          progressColor: AppColors.green,
                        ),
                      ),

                      /// Total, Available, Used Space
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                AppLabels.total,
                                style: AppTextStyle.bodyLarge,
                              ),
                              Text(
                                formatFileSize(
                                    size: userDetailsController
                                        .storageDetails.totalStorage),
                                style: AppTextStyle.headlineSmall,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                AppLabels.available,
                                style: AppTextStyle.bodyLarge,
                              ),
                              Text(
                                formatFileSize(
                                    size: userDetailsController
                                        .storageDetails.remainingStorage),
                                style: AppTextStyle.headlineSmall,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                AppLabels.used,
                                style: AppTextStyle.bodyLarge,
                              ),
                              Text(
                                formatFileSize(
                                    size: userDetailsController
                                        .storageDetails.storageUsed),
                                style: AppTextStyle.headlineSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),

                      /// GridView for folders
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                          vertical: height * 0.03,
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: width * 0.04,
                            mainAxisSpacing: height * 0.02,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                navigateToScreen(index);
                              },
                              child: Container(
                                decoration: ShapeDecoration(
                                  color:
                                      folderColor(index).withValues(alpha: 0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(width * 0.03),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.folderSvg,
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        // ignore: deprecated_member_use
                                        color: folderColor(index),
                                      ),
                                      Text(
                                        folderName(index),
                                        style: AppTextStyle.bodyLarge,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${folderFiles(index)} Files",
                                            style: AppTextStyle.bodySmall,
                                          ),
                                          Spacer(),
                                          Text(
                                            folderSpace(index),
                                            style: AppTextStyle.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  /// Navigation logic
  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        Get.to(() => const FileTypesScreen(fileType: FileTypes.image));
        break;
      case 1:
        Get.to(() => const FileTypesScreen(fileType: FileTypes.video));
        break;
      case 2:
        Get.to(() => const FileTypesScreen(fileType: FileTypes.text));
        break;
      case 3:
        Get.to(() => const FileTypesScreen(fileType: FileTypes.application));
        break;
      default:
        Get.to(() => const Placeholder());
    }
  }

  /// Folder details
  String folderSpace(int index) {
    final details = userDetailsController.storageDetails;
    switch (index) {
      case 0:
        return formatFileSize(size: details.totalImagesSize);
      case 1:
        return formatFileSize(size: details.totalVideoSize);
      case 2:
        return formatFileSize(size: details.totalTextSize);
      case 3:
        return formatFileSize(size: details.totalApplicationSize);
      default:
        return "";
    }
  }

  String folderName(int index) {
    switch (index) {
      case 0:
        return AppLabels.images;
      case 1:
        return AppLabels.videos;
      case 2:
        return AppLabels.documents;
      case 3:
        return AppLabels.others;
      default:
        return "";
    }
  }

  String folderFiles(int index) {
    switch (index) {
      case 0:
        return userDetailsController.storageDetails.totalImageFiles ?? "0";
      case 1:
        return userDetailsController.storageDetails.totalVideoFiles ?? "0";
      case 2:
        return userDetailsController.storageDetails.totalTextFiles ?? "0";
      case 3:
        return userDetailsController.storageDetails.totalApplicationFiles ??
            "0";
      default:
        return "";
    }
  }

  Color folderColor(int index) {
    switch (index) {
      case 0:
        return AppColors.blue;
      case 1:
        return AppColors.red;
      case 2:
        return AppColors.green;
      case 3:
        return AppColors.orange;
      default:
        return AppColors.blue;
    }
  }
}
