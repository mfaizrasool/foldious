import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/my_earning_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/withdraw_page.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/withdraw_status.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:get/get.dart';

class MyEarningPage extends StatefulWidget {
  const MyEarningPage({super.key});
  @override
  State<MyEarningPage> createState() => _MyEarningPageState();
}

class _MyEarningPageState extends State<MyEarningPage> {
  final UserDetailsController userDetailsController = Get.find();
  final MyEarningController controller = Get.find();

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.referalListView();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Obx(() {
      return Scaffold(
        appBar: PrimaryAppBar(
          title: AppLabels.myEarning,
        ),
        body: userDetailsController.isLoading.value ||
                controller.isLoading.value
            ? LoadingIndicator()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: SizedBox(
                  height: height,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      Text(
                        'Total Earnings: ${controller.myEarning.earnings ?? 0} PKR',
                        style: AppTextStyle.titleMedium,
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        'Total Withdraw: ${controller.myEarning.totalWithdraw ?? 0} PKR',
                        style: AppTextStyle.titleMedium,
                      ),

                      ///
                      SizedBox(height: height * 0.02),
                      Text(
                        'You can withdraw your earnings once you reach a minimum of 100 PKR.',
                        style: AppTextStyle.titleSmall,
                      ),

                      ///
                      SizedBox(height: height * 0.02),

                      // ListView for user data
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.myEarning.userData?.length ?? 0,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var user = controller.myEarning.userData![index];
                            Color textColor = (index % 2 == 0)
                                ? AppColors.greyColor.withValues(alpha: 0.2)
                                : Colors.transparent;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.006),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: textColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: ${user.userName ?? 'N/A'}',
                                        style: AppTextStyle.bodyMedium,
                                      ),
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        'Email: ${user.userEmail ?? 'N/A'}',
                                        style: AppTextStyle.bodyMedium,
                                      ),
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        'Date: ${user.createdAt ?? 'N/A'}',
                                        style: AppTextStyle.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                title: "Withdraw",
                                onPressed: () async {
                                  if ((controller.myEarning.earnings ?? 0) <
                                      100) {
                                    showErrorMessage(
                                        'You need to have at least 100 PKR to withdraw.');
                                  } else {
                                    await Get.to(() => WithDrawPage());
                                    await controller.referalListView();
                                  }
                                },
                              ),
                            ),

                            SizedBox(width: width * 0.02),

                            ///
                            ///
                            ///
                            Expanded(
                              child: PrimaryButton(
                                width: width * 0.3,
                                title: "Status",
                                onPressed: () {
                                  Get.to(() => const WithdrawStatusPage());
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
