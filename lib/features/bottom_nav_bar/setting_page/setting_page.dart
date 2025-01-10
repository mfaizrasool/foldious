import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/about/app_version_page.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/appearance/appearance_screen.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/change_password/change_password.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/settings_controller.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/terms_page/terms_page.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:get/get.dart';

import 'privacy_policy/privacy_policy_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final SettingsController controller = Get.put(SettingsController());
  final UserDetailsController userDetailsController = Get.find();
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    // double height = size.height;
    double width = size.width;

    return Scaffold(
      appBar: PrimaryAppBar(
        centerTitle: true,
        title: AppLabels.setting,
        showBackArrowIcon: false,
      ),
      body: Obx(
        () {
          return controller.isLoading.value
              ? LoadingIndicator()
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Column(
                      children: [
                        // PrimaryListTile(
                        //   title: AppLabels.notifications,
                        //   icon: Icons.notifications_none_rounded,
                        //   onTap: () {},
                        // ),

                        ///
                        PrimaryListTile(
                          title: AppLabels.appearance,
                          icon: Icons.remove_red_eye_outlined,
                          onTap: () {
                            Get.to(() => const AppearanceScreen());
                          },
                        ),

                        ///
                        PrimaryListTile(
                          title: AppLabels.privacyPolicy,
                          icon: Icons.privacy_tip_outlined,
                          onTap: () {
                            Get.to(() => PrivacyPolicyPage());
                          },
                        ),

                        ///
                        PrimaryListTile(
                          title: AppLabels.termsAndConditions,
                          icon: Icons.privacy_tip_outlined,
                          onTap: () {
                            Get.to(() => TermsPage());
                          },
                        ),
                        if (userDetailsController.userDetails.userPassword !=
                                null &&
                            userDetailsController
                                .userDetails.userPassword!.isNotEmpty)

                          ///
                          PrimaryListTile(
                            title: AppLabels.changePassword,
                            icon: Icons.password_rounded,
                            onTap: () {
                              Get.to(() => const ChangePasswordPage());
                            },
                          ),

                        ///
                        PrimaryListTile(
                          title: AppLabels.appVersion,
                          icon: Icons.help_outline_rounded,
                          onTap: () {
                            Get.to(() => AppVersionPage());
                          },
                        ),

                        ///
                        PrimaryListTile(
                          title: AppLabels.logout,
                          icon: Icons.logout,
                          onTap: () async {
                            Get.defaultDialog(
                              backgroundColor: appTheme.scaffoldBackgroundColor,
                              title: "",
                              titlePadding: EdgeInsets.zero,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              content: Column(
                                children: [
                                  Text(
                                    AppLabels.logoutDescription,
                                    style: AppTextStyle.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 40,
                                          child: PrimaryButton(
                                            title: "Yes",
                                            onPressed: () async {
                                              Get.back();
                                              await controller.logout();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 120,
                                          height: 40,
                                          child: PrimaryButton(
                                            title: "Cancel",
                                            titleColor: Colors.white,
                                            backgroundColor: appTheme
                                                .colorScheme.primaryContainer,
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        PrimaryListTile(
                          title: AppLabels.deleteAccount,
                          icon: Icons.delete_outline,
                          onTap: () {
                            Get.defaultDialog(
                              backgroundColor: appTheme.scaffoldBackgroundColor,
                              title: "",
                              titlePadding: EdgeInsets.zero,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              content: Column(
                                children: [
                                  Text(
                                    AppLabels.deleteDescription,
                                    style: AppTextStyle.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 40,
                                          child: PrimaryButton(
                                            title: "Yes",
                                            onPressed: () async {
                                              Get.back();
                                              await controller.deleteUser();
                                              await controller.logout();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 120,
                                          height: 40,
                                          child: PrimaryButton(
                                            title: "Cancel",
                                            titleColor: Colors.white,
                                            backgroundColor: appTheme
                                                .colorScheme.primaryContainer,
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class PrimaryListTile extends StatelessWidget {
  const PrimaryListTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });
  final VoidCallback onTap;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: width * 0.05,
        ),
        title: Text(
          title,
          style: AppTextStyle.bodyMedium,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: width * 0.05,
        ),
      ),
    );
  }
}
