import 'package:flutter/material.dart';
import 'package:foldious/common/controllers/preference_controller.dart';
import 'package:foldious/features/authentication/login_screen/login_screen.dart';
import 'package:foldious/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:foldious/features/splash_screen/splash_controller.dart';
import 'package:foldious/utils/preference_labels.dart';
import 'package:foldious/utils/theme/theme_controller.dart';
import 'package:foldious/widgets/app_logo.dart';
import 'package:foldious/widgets/loading_indicator.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());
  final ThemeController themeController = Get.put(ThemeController());
  final AppPreferencesController appPreferencesController = Get.find();
  String userId = "";

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    userId = await appPreferencesController.getString(
        key: AppPreferenceLabels.userId);
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
          () => userId.isNotEmpty ? BottomNavBarScreen() : const LoginScreen());
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
