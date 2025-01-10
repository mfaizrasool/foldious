import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/bottom_nav_bar/user_page/edit_user.dart';
import 'package:foldious/features/bottom_nav_bar/user_page/user_controller.dart';
import 'package:foldious/utils/api_urls.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:foldious/widgets/loading_image.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserController controller = Get.put(UserController());
  final UserDetailsController userDetailsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Obx(() {
      return Scaffold(
        appBar: PrimaryAppBar(
          title: AppLabels.user,
          centerTitle: true,
          showBackArrowIcon: false,
          actions: [
            TextButton(
              onPressed: () async {
                await Get.to(() => const EditUserPage());
                userDetailsController.isLoading.value = true;
                await userDetailsController.getUserDetails();
                userDetailsController.isLoading.value = false;
              },
              child: Text(
                AppLabels.edit,
                style: AppTextStyle.bodyLarge,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.03),

                    /// Profile Image
                    Container(
                      width: height * 0.15,
                      height: height * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.colorScheme.secondaryContainer,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: LoadingImage(
                        imageUrl: userDetailsController
                                    .userDetails.userImage?.isNotEmpty ==
                                true
                            ? ApiUrls.profilePath +
                                userDetailsController.userDetails.userImage!
                            : "https://cdn-icons-png.flaticon.com/512/219/219988.png",
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    /// User Name (Title Section)
                    Text(
                      (userDetailsController.userDetails.userName?.isNotEmpty ==
                              true)
                          ? userDetailsController.userDetails.userName!
                              .split(" ")
                              .first
                          : "User",
                      style: AppTextStyle.headlineMedium,
                    ),

                    Text(
                      userDetailsController.userDetails.userContact ?? "",
                      style: AppTextStyle.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: height * 0.03),

                    SizedBox(height: height * 0.02),

                    /// User Details with Icons
                    buildUserDetailRow(
                      icon: Icons.person,
                      label: AppLabels.fullName,
                      value: userDetailsController.userDetails.userName ?? "-",
                    ),
                    buildUserDetailRow(
                      icon: Icons.phone,
                      label: AppLabels.phoneNumber,
                      value:
                          userDetailsController.userDetails.userContact ?? "-",
                    ),
                    buildUserDetailRow(
                      icon: Icons.email,
                      label: AppLabels.email,
                      value: userDetailsController.userDetails.userEmail ?? "-",
                    ),
                    buildUserDetailRow(
                      icon: Icons.cake,
                      label: AppLabels.age,
                      value: userDetailsController.userDetails.userAge ?? "-",
                    ),
                    buildUserDetailRow(
                      icon: Icons.male,
                      label: AppLabels.gender,
                      value:
                          userDetailsController.userDetails.userGender ?? "-",
                    ),
                    buildUserDetailRow(
                      icon: Icons.location_on,
                      label: AppLabels.address,
                      value:
                          userDetailsController.userDetails.userAddress ?? "-",
                    ),
                  ],
                ),
              ),
            ),

            /// Loading Indicator
            if (controller.isLoading.value ||
                userDetailsController.isLoading.value)
              LoadingIndicator(),
          ],
        ),
      );
    });
  }

  /// Helper method to build user detail rows with icons
  Widget buildUserDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          /// Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primaryColor,
            ),
          ),

          SizedBox(width: 16),

          /// Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                value,
                style: AppTextStyle.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
