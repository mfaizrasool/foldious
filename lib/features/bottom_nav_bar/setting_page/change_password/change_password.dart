import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/change_password/change_password_controller.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/show_snackbar.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:foldious/widgets/primary_text_field.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ///
  final ChangePasswordController controller =
      Get.put(ChangePasswordController());

  ///
  final UserDetailsController userDetailsController = Get.find();

  ///
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ///
  final FocusNode currentFocusNode = FocusNode();
  final FocusNode newFocusNode = FocusNode();
  final FocusNode confirmFocusNode = FocusNode();

  ///
  ///
  ///
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    ///
    currentFocusNode.dispose();
    newFocusNode.dispose();
    confirmFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        return Scaffold(
          appBar: PrimaryAppBar(
            title: AppLabels.changePassword,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.03),

                        ///
                        ///
                        PasswordTextField(
                          label: AppLabels.currentPassword,
                          controller: oldPasswordController,
                          hintText: AppLabels.enterPassword,
                          focusNode: currentFocusNode,
                          mandatory: true,
                          readOnly: false,
                          textCapitalization: TextCapitalization.words,
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(newFocusNode);
                          },
                        ),

                        ///
                        PasswordTextField(
                          label: AppLabels.newPassword,
                          controller: newPasswordController,
                          hintText: AppLabels.enterPassword,
                          focusNode: newFocusNode,
                          mandatory: true,
                          readOnly: false,
                          onSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(confirmFocusNode);
                          },
                        ),

                        ///
                        PasswordTextField(
                          label: AppLabels.confirmPassword,
                          hintText: AppLabels.enterPassword,
                          controller: confirmPasswordController,
                          focusNode: confirmFocusNode,
                          mandatory: true,
                          readOnly: false,
                        ),

                        ///
                        SizedBox(height: height * 0.03),
                        PrimaryButton(
                          title: AppLabels.update,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (oldPasswordController.text.trim() !=
                                userDetailsController
                                    .userDetails.userPassword) {
                              showErrorMessage(
                                  "The current password you entered is incorrect.");
                            } else {
                              controller.validateAndCallChangePassword(
                                oldPassword: oldPasswordController.text,
                                confirmPassword: confirmPasswordController.text,
                                newPassword: newPasswordController.text,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.isLoading.value ||
                  userDetailsController.isLoading.value)
                const LoadingIndicator(),
            ],
          ),
        );
      }),
    );
  }
}
