import 'package:flutter/material.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/privacy_policy/privacy_policy_controller.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({super.key});

  final PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Privacy Policy",
      ),
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              WebViewWidget(
                controller: controller.webController,
              ),
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
