import 'package:flutter/material.dart';

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
  });

  final VoidCallback? onPressed;
  final GestureLongPressCallback? onLongPressed;
  final Widget leading;
  final String title;
  final String subTitle;
  final String? thirdLineText;
  final Widget? trailingWidget;
  final double leadingIconSize;

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
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appTheme.colorScheme.secondaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                  style: appTheme.textTheme.titleSmall,
                ),
                SizedBox(height: height * 0.01),
                Text(
                  subTitle,
                  style: appTheme.textTheme.bodySmall,
                ),
                if (thirdLineText != null)
                  Column(
                    children: [
                      SizedBox(height: height * 0.01),
                      Text(
                        thirdLineText!,
                        style: appTheme.textTheme.bodySmall,
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
