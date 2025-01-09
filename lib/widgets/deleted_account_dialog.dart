import 'package:flutter/material.dart';
import 'package:foldious/features/authentication/contact_us/contact_us_page.dart';
import 'package:foldious/utils/app_labels.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/widgets/primary_button.dart';
import 'package:get/get.dart';

Future<dynamic> deletedAccountDialog() {
  final appTheme = Theme.of(Get.context!);
  return Get.defaultDialog(
    backgroundColor: appTheme.scaffoldBackgroundColor,
    title: "",
    titlePadding: EdgeInsets.zero,
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    content: Column(
      children: [
        Text(
          AppLabels.deletedAccount,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 40,
                child: PrimaryButton(
                  title: AppLabels.cancel,
                  onPressed: () async {
                    Get.back();
                    FocusScope.of(Get.context!).unfocus();
                  },
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 120,
                height: 40,
                child: PrimaryButton(
                  title: AppLabels.contactUs,
                  onPressed: () async {
                    Get.back();
                    Get.to(() => ContactUsPage());
                    FocusScope.of(Get.context!).unfocus();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
