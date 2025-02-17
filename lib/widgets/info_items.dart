import 'package:flutter/material.dart';
import 'package:foldious/utils/app_text_styles.dart';

///
///
class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    this.onPressed,
    this.onLongPressed,
    required this.leading,
    required this.title,
    required this.subTitle,
    this.thirdLineText,
    this.trailingWidget,
    this.leadingIconSize = 24.0,
    this.isLeadingPading = true,
  });

  final VoidCallback? onPressed;
  final GestureLongPressCallback? onLongPressed;
  final Widget leading;
  final String title;
  final String subTitle;
  final String? thirdLineText;
  final Widget? trailingWidget;
  final double leadingIconSize;
  final bool? isLeadingPading;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    var screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return InkWell(
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: height * 0.07,
            width: height * 0.07,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appTheme.colorScheme.secondaryContainer,
            ),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: EdgeInsets.all(isLeadingPading == true ? 12.0 : 0),
              child: leading,
            ),
          ),
          SizedBox(width: width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: height * 0.01),
                Text(
                  subTitle,
                  style: AppTextStyle.bodySmall,
                ),
                if (thirdLineText != null)
                  Column(
                    children: [
                      SizedBox(height: height * 0.01),
                      Text(
                        thirdLineText!,
                        style: AppTextStyle.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (trailingWidget != null)
            Padding(
              padding: EdgeInsets.only(left: height * 0.02),
              child: trailingWidget!,
            ),
        ],
      ),
    );
  }
}
