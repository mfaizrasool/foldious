import 'package:flutter/material.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PrimaryLinearProgress extends StatelessWidget {
  const PrimaryLinearProgress({
    super.key,
    required this.progress,
    required this.progressColor,
  });
  final double progress;

  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.1),
          child: LinearPercentIndicator(
            animation: true,
            lineHeight: height * 0.006,
            animationDuration: 500,
            percent: progress,
            backgroundColor: AppColors.greyColor.withValues(alpha: 0.3),
            barRadius: const Radius.circular(20),
            progressColor: progressColor,
            alignment: MainAxisAlignment.center,
            padding: const EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}
