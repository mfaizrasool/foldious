import 'package:flutter/material.dart';
import 'package:foldious/utils/theme/constants/app_constants.dart';

class ShapedContainer extends StatelessWidget {
  const ShapedContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    // final appTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    // final height = size.height;
    final width = size.width;
    return Container(
      width: width * 0.85,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
