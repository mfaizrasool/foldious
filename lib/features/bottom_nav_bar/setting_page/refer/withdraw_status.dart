import 'package:flutter/material.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/my_earning_controller.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';

class WithdrawStatusPage extends StatefulWidget {
  const WithdrawStatusPage({super.key});
  @override
  State<WithdrawStatusPage> createState() => _WithdrawStatusPageState();
}

class _WithdrawStatusPageState extends State<WithdrawStatusPage> {
  final MyEarningController controller = Get.find();

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.withdrawStatus();
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
          title: "Withdraw Status",
        ),
        body: controller.isLoading.value
            ? LoadingIndicator()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: SizedBox(
                  height: height,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller
                                  .withdrawStatusModel.withdrawData?.length ??
                              0,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var user = controller
                                .withdrawStatusModel.withdrawData![index];
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
                                        'Amount: ${user.withdrawAmount ?? 'N/A'}',
                                        style: AppTextStyle.bodyMedium,
                                      ),

                                      ///
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        'Account Title: ${user.withdrawAccountName ?? 'N/A'}',
                                        style: AppTextStyle.bodyMedium,
                                      ),

                                      ///
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        'Account Number: ${user.withdrawAccountNumber ?? 'N/A'}',
                                        style: AppTextStyle.bodyMedium,
                                      ),

                                      ///
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        'Method: ${user.withdrawMethod ?? 'N/A'}',
                                        style: AppTextStyle.bodyMedium,
                                      ),

                                      ///
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        'Request Date: ${user.withdrawRequestDate ?? 'N/A'}',
                                        style: AppTextStyle.bodyMedium,
                                      ),

                                      ///
                                      if (user.withdrawTransferDate != null &&
                                          user.withdrawTransferDate!.isNotEmpty)
                                        SizedBox(height: height * 0.005),
                                      if (user.withdrawTransferDate != null &&
                                          user.withdrawTransferDate!.isNotEmpty)
                                        Text(
                                          'Transfer Date: ${user.withdrawTransferDate ?? 'N/A'}',
                                          style: AppTextStyle.bodyMedium,
                                        ),

                                      ///
                                      if (user.withdrawTransactionId != null &&
                                          user.withdrawTransactionId!
                                              .isNotEmpty)
                                        SizedBox(height: height * 0.005),
                                      if (user.withdrawTransactionId != null &&
                                          user.withdrawTransactionId!
                                              .isNotEmpty)
                                        Text(
                                          'Transaction Id: ${user.withdrawTransactionId ?? 'N/A'}',
                                          style: AppTextStyle.bodyMedium,
                                        ),

                                      ///
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        'Status: ${user.withdrawStatus ?? 'N/A'}',
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
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
