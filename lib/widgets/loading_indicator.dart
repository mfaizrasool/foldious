import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Container(
      width: width,
      height: height,
      color: AppColors.white.withValues(alpha: 0.1),
      child: const Center(
        child: SpinKitSpinningLines(
          color: AppColors.primaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}
