import 'package:flutter/material.dart';
import 'package:foldious/features/bottom_nav_bar/setting_page/terms_page/terms_controller.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsPage extends StatelessWidget {
  TermsPage({super.key});

  final TermsController controller = Get.put(TermsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
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
