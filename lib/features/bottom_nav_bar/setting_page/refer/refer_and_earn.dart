import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/my_earning.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnPage extends StatefulWidget {
  const ReferAndEarnPage({super.key});
  @override
  State<ReferAndEarnPage> createState() => _ReferAndEarnPageState();
}

class _ReferAndEarnPageState extends State<ReferAndEarnPage> {
  final UserDetailsController userDetailsController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Obx(() {
      return Scaffold(
        appBar: PrimaryAppBar(
          title: AppLabels.referAndEarn,
        ),
        body: userDetailsController.isLoading.value
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
                      Image.asset(
                        "assets/images/refer.png",
                        height: height * 0.3,
                        width: height * 0.3,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "Your referral code:",
                        style: AppTextStyle.headlineMedium,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05, vertical: height * 0.015),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userDetailsController.userDetails.userId ?? "",
                              style: AppTextStyle.headlineMedium,
                            ),

                            ///
                            ///
                            ///
                            IconButton(
                              onPressed: () {
                                String copiedText =
                                    "Referral code: ${userDetailsController.userDetails.userId} \n\nPlay Store: https://play.google.com/store/apps/details?id=com.foldious.storage\n\n\nApp Store: https://apps.apple.com/us/app/foldious-cloud-storage/id6742392762";
                                copyToClipboard(copiedText);
                              },
                              icon: Icon(
                                Icons.copy,
                              ),
                            ),

                            ///
                            ///
                            ///
                          ],
                        ),
                      ),
                      Text(
                        "Share the link above to earn ${userDetailsController.userDetailsModel.user?.referalAmount} for every account that joins. Just click 'Copy,' then paste and share the link anywhere. You can withdraw your earnings once you reach a minimum of ${userDetailsController.userDetailsModel.user?.minWithdraw}.",
                        style: AppTextStyle.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      PrimaryButton(
                        title: "Invite friends",
                        onPressed: () async {
                          String copiedText =
                              "Referral code: ${userDetailsController.userDetails.userId} \n\nPlay Store: https://play.google.com/store/apps/details?id=com.foldious.storage\n\n\nApp Store: https://apps.apple.com/us/app/foldious-cloud-storage/id6742392762";
                          await SharePlus.instance.share(
                            ShareParams(text: copiedText),
                          );
                        },
                      ),
                      PrimaryButton(
                        title: AppLabels.myEarning,
                        onPressed: () async {
                          await Get.to(() => const MyEarningPage());
                        },
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
