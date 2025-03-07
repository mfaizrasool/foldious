import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/refer/my_earning_controller.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/widgets/loading_image.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:foldious/widgets/primary_text_field.dart';
import 'package:get/get.dart';

class AddReferalDialog extends StatelessWidget {
  AddReferalDialog({super.key});
  final MyEarningController controller = Get.find();
  final UserDetailsController userDetailsController = Get.find();
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.sizeOf(context);
    double height = screenSize.height;
    double width = screenSize.width;

    return Obx(() {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Scaffold(
              appBar: PrimaryAppBar(
                title: "Radeem Code",
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * 0.03),
                        Text(
                          "We're so delighted\nyou're here!",
                          style: AppTextStyle.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.03),
                        SizedBox(
                          width: width * 0.5,
                          height: width * 0.5,
                          child: LoadingImage(
                            imageUrl:
                                "https://cdn-icons-png.freepik.com/256/6934/6934631.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "Collect Your Gift\nOn Entering Invite Code",
                          style: AppTextStyle.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "Enter Invite Code:",
                          style: AppTextStyle.bodyMedium,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(
                          width: width * 0.5,
                          child: PrimaryTextField(
                            hintText: "Enter code",
                            controller: codeController,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        PrimaryButton(
                          title: "REDEEM NOW",
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (codeController.text.isEmpty) {
                              showErrorMessage("Please enter code");
                            } else if (userDetailsController
                                    .userDetails.userId ==
                                codeController.text.trim()) {
                              showErrorMessage("Invalid code");
                            } else {
                              await controller.addReferal(
                                code: codeController.text.trim(),
                              );
                            }
                          },
                        )

                        ///
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (controller.isLoading.value) LoadingIndicator()
          ],
        ),
      );
    });
  }
}
