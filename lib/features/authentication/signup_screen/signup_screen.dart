import 'package:flutter/material.dart';
import 'package:foldious/features/authentication/login_screen/login_controller.dart';
import 'package:foldious/features/authentication/signup_screen/signup_controller.dart';
import 'package:foldious/features/authentication/widgets/social_buttons.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/widgets/app_logo.dart';
import 'package:foldious/widgets/arrow_back_button.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:foldious/widgets/primary_text_field.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  ///
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ///
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  ///
  final SignupController controller = SignupController();
  final LoginController loginController = LoginController();

  ///
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();

    ///
    nameFocusNode.dispose();
    emailFocusNode.dispose();

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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.09),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(child: AppLogo()),

                            SizedBox(height: height * 0.02),
                            Text(
                              AppLabels.signUp,
                              style: AppTextStyle.headlineMedium,
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              AppLabels.creataAnAccount,
                              style: AppTextStyle.bodyMedium,
                            ),

                            ///
                            ///
                            ///
                            PrimaryTextField(
                              label: AppLabels.fullName,
                              controller: nameController,
                              focusNode: nameFocusNode,
                              hintText: AppLabels.yourEmail,
                              textCapitalization: TextCapitalization.words,
                              mandatory: true,
                              onSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(emailFocusNode);
                              },
                            ),

                            ///
                            PrimaryTextField(
                              label: AppLabels.email,
                              controller: emailController,
                              focusNode: emailFocusNode,
                              hintText: AppLabels.yourEmail,
                              textCapitalization: TextCapitalization.none,
                              mandatory: true,
                            ),

                            SizedBox(height: height * 0.03),
                            Center(
                              child: PrimaryButton(
                                title: AppLabels.signUp,
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  controller.validateAndCallSignUpApi(
                                    userName: nameController.text,
                                    email: emailController.text,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLabels.alreadyHaveAccount,
                                  style: AppTextStyle.bodySmall
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    padding:
                                        WidgetStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(4)),
                                    minimumSize:
                                        WidgetStateProperty.all(Size.zero),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    AppLabels.login,
                                    style: AppTextStyle.bodySmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.04),

                            ///
                            SocialButtons(
                              title: "Sign in with Google",
                              image:
                                  "http://pngimg.com/uploads/google/google_PNG19635.png",
                              onTap: () async {
                                loginController.googleSign();
                              },
                            ),

                            ///
                            SizedBox(height: height * 0.04),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value || loginController.isLoading.value)
                const LoadingIndicator()
            ],
          ),
        );
      }),
    );
  }
}
