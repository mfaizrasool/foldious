import 'package:flutter/material.dart';
import 'package:foldious/features/authentication/contact_us/contact_us_controller.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/widgets/primary_appbar.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key});

  final ContactUsController controller = Get.put(ContactUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: AppLabels.contactUs,
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
