import 'package:flutter/material.dart';
import 'package:foldious/features/authentication/forgot/forgot_controller.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/widgets/app_logo.dart';
import 'package:foldious/widgets/arrow_back_button.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:foldious/widgets/primary_text_field.dart';
import 'package:get/get.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});
  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  ///
  final TextEditingController emailController = TextEditingController();

  final ForgotController controller = Get.put(ForgotController());

  ///
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  ///

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ArrowBackButton(),
                      Center(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.09),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(child: AppLogo()),
                              SizedBox(height: height * 0.01),
                              Text(AppLabels.forgotPassword,
                                  style: AppTextStyle.headlineMedium),
                              SizedBox(height: height * 0.02),
                              Text(
                                AppLabels.forgotDescription,
                                style: AppTextStyle.bodyMedium,
                              ),
                              PrimaryTextField(
                                label: AppLabels.email,
                                controller: emailController,
                                hintText: AppLabels.yourEmail,
                                mandatory: true,
                              ),
                              SizedBox(height: height * 0.1),
                              Center(
                                child: PrimaryButton(
                                  title: AppLabels.submit,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (emailController.text.isEmpty) {
                                      showErrorMessage(AppLabels.emptyEmail);
                                    } else {
                                      controller.forgot(
                                        email: emailController.text,
                                      );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: height * 0.1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value) const LoadingIndicator()
            ],
          ),
        );
      }),
    );
  }
}
