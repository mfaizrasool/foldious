import 'package:flutter/material.dart';
import 'package:foldious/utils/app_text_styles.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width * 0.55,
          height: height * 0.05,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                image,
                fit: BoxFit.cover,
                width: 30,
                height: 30,
              ),
              SizedBox(width: width * 0.02),
              Text(
                title,
                style: AppTextStyle.bodyMedium.copyWith(color: AppColors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
