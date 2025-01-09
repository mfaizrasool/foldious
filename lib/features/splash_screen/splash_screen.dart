import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/common/controllers/user_details_controller.dart';
import 'package:foldious/features/authentication/login_screen/login_screen.dart';
import 'package:foldious/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:foldious/features/splash_screen/splash_controller.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/theme/theme_controller.dart';
import 'package:foldious/widgets/app_logo.dart';
import 'package:foldious/widgets/deleted_account_dialog.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());
  final UserDetailsController userDetailsController = Get.find();
  final ThemeController themeController = Get.put(ThemeController());
  final AppPreferencesController appPreferencesController = Get.find();
  String userId = "";

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    // Retrieve the userId from preferences
    userId = await appPreferencesController.getString(
      key: AppPreferenceLabels.userId,
    );

    // Add a delay before navigating
    Future.delayed(const Duration(seconds: 3), () async {
      if (userId.isNotEmpty) {
        // Fetch user details if userId is not empty
        await userDetailsController.getUserDetails();

        // Check if the user's account is marked as deleted
        if (userDetailsController.userDetails.deletedAt != null &&
            userDetailsController.userDetails.deletedAt!.isNotEmpty) {
          Get.off(() => const LoginScreen());
          GoogleSignIn googleSignIn = GoogleSignIn();
          if (await googleSignIn.isSignedIn()) {
            await googleSignIn.signOut();
          }
          AppPreferencesController()
              .deleteString(key: AppPreferenceLabels.userId);

          deletedAccountDialog();
        } else {
          Get.off(() => BottomNavBarScreen());
        }
      } else {
        Get.off(() => const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: controller.isLoading.value
            ? const LoadingIndicator()
            : const Center(
                child: AppLogo(),
              ),
      );
    });
  }
}
