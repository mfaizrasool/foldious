import 'package:foldious/features/bottom_nav_bar/setting_page/about/app_version_controller.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppVersionPage extends StatelessWidget {
  AppVersionPage({super.key});

  final AppVersionController controller = Get.put(AppVersionController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppLabels.appVersion),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: height * 0.035),
              const AppLogo(),
              SizedBox(height: height * 0.035),
              Obx(
                () => Text(
                  controller.version.value,
                  style: AppTextStyle.headlineMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
