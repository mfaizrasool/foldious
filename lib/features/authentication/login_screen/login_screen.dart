import 'package:flutter/material.dart';
import 'package:foldious/features/authentication/forgot/forgot_screen.dart';
import 'package:foldious/features/authentication/login_screen/login_controller.dart';
import 'package:foldious/features/authentication/signup_screen/signup_screen.dart';
import 'package:foldious/features/authentication/widgets/social_buttons.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/widgets/app_logo.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:foldious/widgets/primary_text_field.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ///
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final LoginController controller = LoginController();

  ///
  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
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
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.09),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///
                        const Center(child: AppLogo()),

                        ///
                        SizedBox(height: height * 0.02),
                        Text(AppLabels.login,
                            style: AppTextStyle.headlineMedium),

                        ///
                        SizedBox(height: height * 0.02),
                        Text(
                          AppLabels.enterEmailPass,
                          style: AppTextStyle.bodyMedium,
                        ),

                        ///
                        PrimaryTextField(
                          label: AppLabels.email,
                          controller: emailController,
                          focusNode: emailFocusNode,
                          hintText: AppLabels.yourEmail,
                          mandatory: true,
                          onSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                        ),
                        PasswordTextField(
                          label: AppLabels.password,
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          hintText: AppLabels.passwordHintText,
                          mandatory: true,
                          readOnly: false,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            child: Text(
                              AppLabels.forgotPassword,
                              style: AppTextStyle.bodySmall
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              Get.to(() => const ForgotScreen());
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Center(
                          child: PrimaryButton(
                            title: AppLabels.login,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              await controller.validateAndCallLoginApi(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLabels.dontHaveAccount,
                              style: AppTextStyle.bodySmall
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(4)),
                                minimumSize: WidgetStateProperty.all(Size.zero),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                Get.to(() => const SignupScreen());
                              },
                              child: Text(
                                AppLabels.signUp,
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
                            controller.googleSign();
                          },
                        ),

                        ///
                        SizedBox(height: height * 0.04),
                      ],
                    ),
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
